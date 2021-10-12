//
//  EthFeeCalculator.swift
//  CloudArtChain
//
//  Created by jielian on 2021/10/11.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import UIKit

struct EthFeeCalculator {

    static func estimate(fee: String, with price: String) -> Double? {
        guard let feeInDouble = Double(fee) else {
            return nil
        }
        guard let price = Double(price) else {
            return nil
        }
        return price * feeInDouble
    }

    static func format(fee: Double, formatter: NumberFormatter = EthCurrencyFormatter.formatter) -> String? {
        if let fee = formatter.string(from: NSNumber(value: fee)) {
            return EthConfig().currency.show + fee
        }
        return nil
    }

}
