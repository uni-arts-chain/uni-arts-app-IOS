//
//  EthRPCMethods.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/15.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

struct EthRPCMethods {
    static let getBalance = "eth_getBalance"
    static let blockNumber = "eth_blockNumber"
    static let getTransactionByHash = "eth_getTransactionByHash"
    static let sendRawTransaction = "eth_sendRawTransaction"
    static let getTransactionCount = "eth_getTransactionCount"
    static let call = "eth_call"
    static let gasPrice = "eth_gasPrice"
    static let estimateGas = "eth_estimateGas"
}
