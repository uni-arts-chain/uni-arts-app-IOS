//
//  EthBrowserViewController+Transfer.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/29.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import UIKit
import BigInt
import TrustKeystore
import WebKit
import Result

enum EthConfirmType {
    case sign
    case signThenSend
}

enum EthConfirmResult {
    case signedTransaction(EthSentTransaction)
    case sentTransaction(EthSentTransaction)
}

extension EthBrowserViewController {
    
    func didCall(action: EthDappAction, callbackID: Int) {
        guard let account = keystore.recentlyUsedWalletInfo?.currentAccount, let _ = account.wallet else {
            notifyFinish(callbackID: callbackID, value: .failure(EthDAppError.cancelled))
            return
        }
        switch action {
        case .signTransaction(let unconfirmedTransaction):
            executeTransaction(account: account, action: action, callbackID: callbackID, transaction: unconfirmedTransaction, type: .signThenSend, server: self.server)
        case .sendTransaction(let unconfirmedTransaction):
            executeTransaction(account: account, action: action, callbackID: callbackID, transaction: unconfirmedTransaction, type: .signThenSend, server: self.server)
        case .signMessage(let hexMessage):
            signMessage(with: .message(Data(hex: hexMessage)), account: account, callbackID: callbackID)
        case .signPersonalMessage(let hexMessage):
            signMessage(with: .personalMessage(Data(hex: hexMessage)), account: account, callbackID: callbackID)
        case .signTypedMessage(let typedData):
            signMessage(with: .typedMessage(typedData), account: account, callbackID: callbackID)
        case .unknown:
            break
        }
    }
    
    func signMessage(with type: EthSignMesageType, account: Account, callbackID: Int) {
        let coordinator = EthSignMessageCoordinator(
            viewController: self,
            keystore: keystore,
            account: account
        )
        coordinator.didComplete = { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                let callback: EthDappCallback
                switch type {
                case .message:
                    callback = EthDappCallback(id: callbackID, value: .signMessage(data))
                case .personalMessage:
                    callback = EthDappCallback(id: callbackID, value: .signPersonalMessage(data))
                case .typedMessage:
                    callback = EthDappCallback(id: callbackID, value: .signTypedMessage(data))
                }
                self.notifyFinish(callbackID: callbackID, value: .success(callback))
            case .failure:
                self.notifyFinish(callbackID: callbackID, value: .failure(EthDAppError.cancelled))
            }
            coordinator.didComplete = nil
        }
        coordinator.delegate = self
        coordinator.start(with: type)
    }
    
    private func executeTransaction(account: Account, action: EthDappAction, callbackID: Int, transaction: EthUnconfirmedTransaction, type: EthConfirmType, server: EthRPCServer) {
        let configurator = EthTransactionConfigurator(
            walletInfo: keystore.recentlyUsedWalletInfo!,
            transaction: transaction,
            server: server,
            chainState: EthChainState(server: server)
        )
        let coordinator = EthConfirmCoordinator(
            configurator: configurator,
            keystore: keystore,
            type: type,
            server: server
        )
        coordinator.didCompleted = { [unowned self] result in
            switch result {
            case .success(let type):
                switch type {
                case .signedTransaction(let transaction):
                    // on signing we pass signed hex of the transaction
                    let callback = EthDappCallback(id: callbackID, value: .signTransaction(transaction.data))
                    self.notifyFinish(callbackID: callbackID, value: .success(callback))
                    self.delegate?.didSentTransaction(transaction: transaction)
                case .sentTransaction(let transaction):
                    // on send transaction we pass transaction ID only.
                    let data = Data(hex: transaction.id)
                    let callback = EthDappCallback(id: callbackID, value: .sentTransaction(data))
                    self.notifyFinish(callbackID: callbackID, value: .success(callback))
                    self.delegate?.didSentTransaction(transaction: transaction)
                }
            case .failure:
                self.notifyFinish(
                    callbackID: callbackID,
                    value: .failure(EthDAppError.cancelled)
                )
            }
            coordinator.didCompleted = nil
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: EthSignMessageCoordinatorDelegate
extension EthBrowserViewController: EthSignMessageCoordinatorDelegate {
    func didCancel(in coordinator: EthSignMessageCoordinator) {
        coordinator.didComplete = nil
    }
}
