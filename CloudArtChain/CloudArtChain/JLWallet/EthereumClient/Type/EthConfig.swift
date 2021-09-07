//
//  EthConfig.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/3.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import TrustCore

struct EthConfig {

    private struct Keys {
        static let currencyID = "currencyID"
        static let hideCoinBalance = "hideCoinBalance"
    }

    static let dbMigrationSchemaVersion: UInt64 = 77

    static let current: EthConfig = EthConfig()

    let defaults: UserDefaults

    init(
        defaults: UserDefaults = UserDefaults.standard
    ) {
        self.defaults = defaults
    }

    var currency: EthCurrency {
        get {
            //If it is saved currency
            if let currency = defaults.string(forKey: Keys.currencyID) {
                return EthCurrency(rawValue: currency)!
            }
            //If ther is not saved currency try to use user local currency if it is supported.
            let avaliableCurrency = EthCurrency.allValues.first { currency in
                return currency.rawValue == Locale.current.currencySymbol
            }
            if let isAvaliableCurrency = avaliableCurrency {
                return isAvaliableCurrency
            }
            //If non of the previous is not working return CNY.
            return EthCurrency.CNY
        }
        set { defaults.set(newValue.rawValue, forKey: Keys.currencyID) }
    }

    var servers: [Coin] {
        return [
            Coin.ethereum
        ]
    }

    var hideCoin: Bool {
        get {
            if defaults.bool(forKey: Keys.hideCoinBalance) {
                return defaults.bool(forKey: Keys.hideCoinBalance)
            }
            return false
        }
        set {
            defaults.set(newValue, forKey: Keys.hideCoinBalance)
            defaults.synchronize()
        }
    }
}

