//
//  EthTransactionConfigurator.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import BigInt
import Result
import TrustCore
import TrustKeystore

public struct EthPreviewTransaction {
    let value: BigInt
    let account: Account
    let address: EthereumAddress?
    let contract: EthereumAddress?
    let nonce: BigInt
    let data: Data
    let gasPrice: BigInt
    let gasLimit: BigInt
    let transfer: Transfer
}

final class EthTransactionConfigurator {
    
    let walletInfo: EthWalletInfo
    let transaction: EthUnconfirmedTransaction
    let forceFetchNonce: Bool
    let server: EthRPCServer
    let chainState: EthChainState
    var configuration: EthTransactionConfiguration {
        didSet {
            configurationUpdate.value = configuration
        }
    }
    var requestEstimateGas: Bool
    
    var configurationUpdate: EthSubscribable<EthTransactionConfiguration> = EthSubscribable(nil)
    
    var signTransaction: EthSignTransaction {
        let value: BigInt = {
            switch transaction.transfer.type {
            case .ether, .dapp: return valueToSend()
            case .token: return 0
            }
        }()
        let address: EthereumAddress? = {
            switch transaction.transfer.type {
            case .ether, .dapp: return transaction.to
            case .token(let token): return token.contractAddress
            }
        }()
        let localizedObject: EthLocalizedOperationObject? = {
            switch transaction.transfer.type {
            case .ether, .dapp: return .none
            case .token(let token):
                return EthLocalizedOperationObject(
                    from: walletInfo.currentAccount.address.description,
                    to: transaction.to?.description ?? "",
                    contract: token.contract,
                    type: EthOperationType.tokenTransfer.rawValue,
                    value: BigInt(transaction.value.magnitude).description,
                    symbol: token.symbol,
                    name: token.name,
                    decimals: token.decimals
                )
            }
        }()

        return EthSignTransaction(
            value: value,
            account: walletInfo.currentAccount,
            to: address,
            nonce: configuration.nonce,
            data: configuration.data,
            gasPrice: configuration.gasPrice,
            gasLimit: configuration.gasLimit,
            chainID: server.chainID,
            localizedObject: localizedObject
        )
    }
    
    init(
        walletInfo: EthWalletInfo,
        transaction: EthUnconfirmedTransaction,
        server: EthRPCServer,
        chainState: EthChainState,
        forceFetchNonce: Bool = true
    ) {
        self.walletInfo = walletInfo
        self.transaction = transaction
        self.server = server
        self.chainState = chainState
        self.forceFetchNonce = forceFetchNonce
        self.requestEstimateGas = transaction.gasLimit == .none
        
        let data: Data = EthTransactionConfigurator.data(for: transaction, from: walletInfo.currentAccount.address)
        let calculatedGasLimit = transaction.gasLimit ?? EthTransactionConfigurator.gasLimit(for: transaction.transfer.type)
        let calculatedGasPrice = min(max(transaction.gasPrice ?? chainState.gasPrice ?? GasPriceConfiguration.default, GasPriceConfiguration.min), GasPriceConfiguration.max)
        
        self.configuration = EthTransactionConfiguration(
            gasPrice: calculatedGasPrice,
            gasLimit: calculatedGasLimit,
            data: data,
            nonce: transaction.nonce ?? -1
        )
    }
    
    func load(completion: @escaping (Result<Void, AnyError>) -> Void) {
        if requestEstimateGas {
            estimateGasLimit { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case .success(let gasLimit):
                    self.refreshGasLimit(gasLimit)
                case .failure: break
                }
            }
        }
        loadNextNonce(completion: completion)
    }
    
    func estimateGasLimit(completion: @escaping (Result<BigInt, AnyError>) -> Void) {
        EthWalletRPCService(server: server).getEstimateGasLimit(signTransaction: signTransaction).done { gasLimit in
            completion(.success(gasLimit))
        }.catch { error in
            completion(.failure(AnyError(error)))
        }
    }
    
    func loadNextNonce(completion: @escaping (Result<Void, AnyError>) -> Void) {
        EthWalletRPCService(server: server).getTransactionCount().done { [weak self] nonce in
            self?.refreshNonce(nonce + 1)
            completion(.success(()))
        }.catch { error in
            completion(.failure(AnyError(error)))
        }
    }
    
    func refreshGasLimit(_ gasLimit: BigInt) {
        configuration = EthTransactionConfiguration(
            gasPrice: configuration.gasPrice,
            gasLimit: gasLimit,
            data: configuration.data,
            nonce: configuration.nonce
        )
    }

    func refreshNonce(_ nonce: BigInt) {
        configuration = EthTransactionConfiguration(
            gasPrice: configuration.gasPrice,
            gasLimit: configuration.gasLimit,
            data: configuration.data,
            nonce: nonce
        )
    }
    
    func valueToSend() -> BigInt {
        var value = transaction.value
        switch transaction.transfer.type.token.type {
        case .coin:
            let balance = EthBalance(value: transaction.transfer.type.token.valueBigInt)
            if !balance.value.isZero && balance.value == transaction.value {
                value = transaction.value - configuration.gasLimit * configuration.gasPrice
                //We work only with positive numbers.
                if value.sign == .minus {
                    value = BigInt(value.magnitude)
                }
            }
            return value
        case .ERC20, .QRC20:
            return value
        }
    }
    
    func balanceValidStatus() -> EthBalanceStatus {
        var etherSufficient = true
        var gasSufficient = true
        var tokenSufficient = true

        // fetching price of the coin, not the erc20 token.
        let currentBalance = self.transaction.transfer.type.token.valueBalance

        let transaction = previewTransaction()
        let totalGasValue = transaction.gasPrice * transaction.gasLimit

        //We check if it is ETH or token operation.
        switch transaction.transfer.type {
        case .ether, .dapp:
            if transaction.value > currentBalance.value {
                etherSufficient = false
                gasSufficient = false
            } else {
                if totalGasValue + transaction.value > currentBalance.value {
                    gasSufficient = false
                }
            }
            return .ether(etherSufficient: etherSufficient, gasSufficient: gasSufficient)
        case .token(let token):
            if totalGasValue > currentBalance.value {
                etherSufficient = false
                gasSufficient = false
            }
            if transaction.value > token.valueBigInt {
                tokenSufficient = false
            }
            return .token(tokenSufficient: tokenSufficient, gasSufficient: gasSufficient)
        }
    }
    
    func previewTransaction() -> EthPreviewTransaction {
        return EthPreviewTransaction(
            value: valueToSend(),
            account: walletInfo.currentAccount,
            address: transaction.to,
            contract: .none,
            nonce: configuration.nonce,
            data: configuration.data,
            gasPrice: configuration.gasPrice,
            gasLimit: configuration.gasLimit,
            transfer: transaction.transfer
        )
    }
    
    private static func data(for transaction: EthUnconfirmedTransaction, from: Address) -> Data {
        guard let to = transaction.to else { return Data() }
        switch transaction.transfer.type {
        case .ether, .dapp:
            return transaction.data ?? Data()
        case .token:
            return ERC20Encoder.encodeTransfer(to: to, tokens: transaction.value.magnitude)
        }
    }
    
    private static func gasLimit(for type: TransferType) -> BigInt {
        switch type {
        case .ether:
            return GasLimitConfiguration.default
        case .token:
            return GasLimitConfiguration.tokenTransfer
        case .dapp:
            return GasLimitConfiguration.dappTransfer
        }
    }

    private static func gasPrice(for type: Transfer) -> BigInt {
        return GasPriceConfiguration.default
    }
}
