//
//  EthCoinTicker.swift
//  CloudArtChain
//
//  Created by jielian on 2021/10/12.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import TrustCore

final class EthCoinTicker: Decodable {
    var price: String = ""
    var percent_change_24h: String = ""
    var contract: String = ""
    var tickersKey: String = ""
    var key: String = ""
    var base: String = ""
    var symbol: String = ""
    var change_24h: String = ""
    var provider: String = ""
    var id = 0

    convenience init(
        price: String = "",
        percent_change_24h: String = "",
        contract: EthereumAddress,
        tickersKey: String = "",
        base: String = "",
        symbol: String = "",
        change_24h: String = "",
        provider: String = "",
        id: Int = 0
    ) {
        self.init()
        self.price = price
        self.percent_change_24h = percent_change_24h
        self.contract = contract.description
        self.tickersKey = tickersKey
        self.base = base
        self.symbol = symbol
        self.change_24h = change_24h
        self.provider = provider
        self.id = id

        self.key = EthCoinTickerKeyMaker.makePrimaryKey(contract: contract, currencyKey: tickersKey)
    }
    
    enum CodingKeys: String, CodingKey {
        case base
        case symbol
        case change_24h
        case provider
        case price
        case id
    }
}

struct EthCoinTickerKeyMaker {
    static func makePrimaryKey(contract: Address, currencyKey: String) -> String {
        return "\(contract)_\(currencyKey)"
    }

    static func makeCurrencyKey() -> String {
        return "tickers-" + EthConfig.current.currency.rawValue
    }
}
