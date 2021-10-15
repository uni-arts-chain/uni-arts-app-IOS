//
//  EthCoinTicker.swift
//  CloudArtChain
//
//  Created by jielian on 2021/10/12.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import TrustCore

struct EthCoinTickerPrice: Decodable {
    var eth: String
}

struct EthCoinTicker: Decodable {
    var price: EthCoinTickerPrice
    var last_updated: String
    var interval_time: Int
}
