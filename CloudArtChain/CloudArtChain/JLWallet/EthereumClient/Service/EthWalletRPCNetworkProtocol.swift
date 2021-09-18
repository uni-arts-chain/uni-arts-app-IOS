//
//  EthWalletRPCNetworkProtocol.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import BigInt
import TrustCore
import PromiseKit

protocol EthWalletRPCNetworkProtocol {
    func getLastBlock() -> Promise<Int>
    func getBalance() -> Promise<EthBalance>
    func getGasPrice() -> Promise<String>
    func getEstimateGasLimit(signTransaction: EthSignTransaction) -> Promise<BigInt>
    func getTransactionCount() -> Promise<BigInt>
    func sendRawTransaction(signedTransactionHexString: String) -> Promise<String>
}
