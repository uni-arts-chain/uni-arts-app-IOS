//
//  EthBalance.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/15.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import BigInt

struct EthBalance: EthBalanceProtocol {

    let value: BigInt

    init(value: BigInt) {
        self.value = value
    }

    var isZero: Bool {
        return value.isZero
    }

    var amountShort: String {
        return EthNumberFormatter.short.string(from: value)
    }

    var amountFull: String {
        return EthNumberFormatter.full.string(from: value)
    }
}
