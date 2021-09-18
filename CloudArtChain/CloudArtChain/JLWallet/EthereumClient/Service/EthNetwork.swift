//
//  EthNetwork.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/15.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import PromiseKit
import Moya
import TrustCore
import TrustKeystore
import JSONRPCKit
import APIKit
import Result
import BigInt

import enum Result.Result

enum EthNetworkProtocolError: LocalizedError {
    case missingContractInfo
}

protocol NetworkProtocol: EthNetworkProtocol {
    func getBalance(address: EthereumAddress) -> Promise<String>
}

final class EthNetwork: NetworkProtocol {
    
    var provider: MoyaProvider<EthServiceAPI>
    let wallet: EthWalletInfo
    
    init(
        provider: MoyaProvider<EthServiceAPI>,
        wallet: EthWalletInfo) {
        self.provider = provider
        self.wallet = wallet
    }
    
    func getBalance(address: EthereumAddress) -> Promise<String> {
        return Promise { seal in
            provider.request(.getBalance(address: address.description)) { result in
                switch result {
                case .success(let response):
                    do {
                        let balance = try response.mapString()
                        seal.fulfill(balance)
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}
