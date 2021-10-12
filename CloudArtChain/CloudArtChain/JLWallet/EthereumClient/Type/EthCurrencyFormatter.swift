//
//  EthCurrencyFormatter.swift
//  CloudArtChain
//
//  Created by jielian on 2021/10/11.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

final class EthCurrencyFormatter {
    static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = EthConfig().currency.rawValue
        formatter.numberStyle = .decimal
        return formatter
    }

    static var persentFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter
    }

    static var plainFormatter: EthNumberFormatter {
        let formatter = EthNumberFormatter.full
        formatter.groupingSeparator = ""
        return formatter
    }
}
