//
//  EthSendTransactionCoordinator.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/17.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import BigInt
import Foundation
import APIKit
import JSONRPCKit
import Result
import TrustCore

final class EthSendTransactionCoordinator {
    private let keystore: EthKeystore
    let formatter = EthNumberFormatter.full
    let confirmType: EthConfirmType
    let server: EthRPCServer

    init(
        keystore: EthKeystore,
        confirmType: EthConfirmType,
        server: EthRPCServer
    ) {
        self.keystore = keystore
        self.confirmType = confirmType
        self.server = server
    }
    
    func send(
        transaction: EthSignTransaction,
        completion: @escaping (Result<EthConfirmResult, AnyError>) -> Void
    ) {
        if transaction.nonce >= 0 {
            signAndSend(transaction: transaction, completion: completion)
        } else {
            guard let ethAddress = transaction.account.address as? EthereumAddress  else { return
                completion(.failure(AnyError(EthWalletRPCServiceError.nullAddress)))
            }
            EthWalletRPCService(server: server, addressUpdate: ethAddress).getTransactionCount().done { [weak self] nonce in
                guard let `self` = self else { return }
                let transaction = self.appendNonce(to: transaction, currentNonce: nonce)
                self.signAndSend(transaction: transaction, completion: completion)
            }.catch { error in
                completion(.failure(AnyError(error)))
            }
        }
    }

    private func appendNonce(to: EthSignTransaction, currentNonce: BigInt) -> EthSignTransaction {
        return EthSignTransaction(
            value: to.value,
            account: to.account,
            to: to.to,
            nonce: currentNonce,
            data: to.data,
            gasPrice: to.gasPrice,
            gasLimit: to.gasLimit,
            chainID: to.chainID,
            localizedObject: to.localizedObject
        )
    }

    private func signAndSend(
        transaction: EthSignTransaction,
        completion: @escaping (Result<EthConfirmResult, AnyError>) -> Void
    ) {
        let signedTransaction = keystore.signTransaction(transaction)

        switch signedTransaction {
        case .success(let data):
            approve(confirmType: confirmType, transaction: transaction, data: data, completion: completion)
        case .failure(let error):
            completion(.failure(AnyError(error)))
        }
    }

    private func approve(confirmType: EthConfirmType, transaction: EthSignTransaction, data: Data, completion: @escaping (Result<EthConfirmResult, AnyError>) -> Void) {
        let id = data.sha3(.keccak256).hexEncoded
        let sentTransaction = EthSentTransaction(
            id: id,
            original: transaction,
            data: data
        )
        let dataHex = data.hexEncoded
        switch confirmType {
        case .sign:
            completion(.success(.sentTransaction(sentTransaction)))
        case .signThenSend:
            EthWalletRPCService(server: server).sendRawTransaction(signedTransactionHexString: dataHex).done { result in
                completion(.success(.sentTransaction(sentTransaction)))
            }.catch { error in
                completion(.failure(AnyError(error)))
            }
        }
    }
}
