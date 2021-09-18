//
//  EthWalletRPCService.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import TrustCore
import PromiseKit
import BigInt
import APIKit
import JSONRPCKit

enum EthWalletRPCServiceError:LocalizedError {
    case nullAddress
    
    var errorDescription: String? {
        switch self {
        case .nullAddress:
            return "地址为空"
        }
    }
}

final class EthWalletRPCService: EthWalletRPCNetworkProtocol {
    let server: EthRPCServer
    var addressUpdate: EthereumAddress?

    init(
        server: EthRPCServer,
        addressUpdate: EthereumAddress? = nil
        ) {
        self.server = server
        self.addressUpdate = addressUpdate
    }
    
    /// 获取块
    func getLastBlock() -> Promise<Int> {
        return Promise { seal in
            let request = EtherServiceRequest(for: server, batch: BatchFactory().create(BlockNumberRequest()), timeoutInterval: 5.0)
            Session.send(request) { result in
                switch result {
                case .success(let number):
                    seal.fulfill(number)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    /// 获取以太坊地址余额
    func getBalance() -> Promise<EthBalance> {
        return Promise { seal in
            guard let address = addressUpdate?.description else { return  seal.reject(EthWalletRPCServiceError.nullAddress)
            }
            let request = EtherServiceRequest(for: server, batch: BatchFactory().create(EthBalanceRequest(address: address)))
            Session.send(request) { result in
                switch result {
                case .success(let balance):
                    seal.fulfill(balance)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    /// 获取gasPrice
    func getGasPrice() -> Promise<String> {
        return Promise { seal in
            let request = EtherServiceRequest(for: server, batch: BatchFactory().create(EthGasPriceRequest()))
            Session.send(request) { result in
                switch result {
                case .success(let balance):
                    seal.fulfill(String(BigInt(balance.drop0x, radix: 16) ?? BigInt()))
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    /// 获取gasLimit
    func getEstimateGasLimit(signTransaction: EthSignTransaction) -> Promise<BigInt> {
        return Promise { seal in
            let request = EthEstimateGasRequest(
                transaction: signTransaction
            )
            Session.send(EtherServiceRequest(for: server, batch: BatchFactory().create(request))) { result in
                switch result {
                case .success(let gasLimit):
                    let gasLimit: BigInt = {
                        let limit = BigInt(gasLimit.drop0x, radix: 16) ?? BigInt()
                        if limit == BigInt(21000) {
                            return limit
                        }
                        return limit + (limit * 20 / 100)
                    }()
                    seal.fulfill(gasLimit)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    /// 获取交易次数
    func getTransactionCount() -> Promise<BigInt> {
        return Promise { seal in
            guard let address = addressUpdate?.description else { return  seal.reject(EthWalletRPCServiceError.nullAddress)
            }
            let request = EtherServiceRequest(for: server, batch: BatchFactory().create(EthGetTransactionCountRequest(
                address: address,
                state: "latest"
            )))
            Session.send(request) { result in
                switch result {
                case .success(let count):
                    seal.fulfill(count)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    /// 发送交易
    func sendRawTransaction(signedTransactionHexString: String) -> Promise<String> {
        return Promise { seal in
            let request = EtherServiceRequest(for: server, batch: BatchFactory().create(EthSendRawTransactionRequest(signedTransaction: signedTransactionHexString)))
            Session.send(request) { result in
                switch result {
                case .success(let response):
                    seal.fulfill(response)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}
