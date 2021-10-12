//
//  EthArrayResponse.swift
//  CloudArtChain
//
//  Created by jielian on 2021/10/12.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

struct EthArrayResponse<T: Decodable>: Decodable {
    let docs: [T]
}

struct EthPricesResponse<T: Decodable>: Decodable {
    let tickers: [T]
}

struct EthHeadBodyResponse<T: Decodable>: Decodable {
    let head: EthResponseHead
    let body: T
}

struct EthHeadResponse : Decodable {
    let head: EthResponseHead
}
