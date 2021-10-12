//
//  EthTokensPrice.swift
//  CloudArtChain
//
//  Created by jielian on 2021/10/12.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

struct EthTokensPrice: Encodable {
    let currency: String
    let tokens: [EthTokenPrice]
}

struct EthTokenPrice: Encodable {
    let contract: String
    let symbol: String
}
