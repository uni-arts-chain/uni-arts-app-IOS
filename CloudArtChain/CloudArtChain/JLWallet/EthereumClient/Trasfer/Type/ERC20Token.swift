//
//  ERC20Token.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/9.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import TrustCore

struct ERC20Token {
    let contract: Address
    let name: String
    let symbol: String
    let decimals: Int
    let coin: Coin
    let isDisable: Bool = false
    let type: TokenObjectType
}
