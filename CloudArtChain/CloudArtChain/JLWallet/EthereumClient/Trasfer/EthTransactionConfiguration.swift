//
//  EthTransactionConfiguration.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import BigInt

struct EthTransactionConfiguration {
    let gasPrice: BigInt
    let gasLimit: BigInt
    let data: Data
    let nonce: BigInt
}
