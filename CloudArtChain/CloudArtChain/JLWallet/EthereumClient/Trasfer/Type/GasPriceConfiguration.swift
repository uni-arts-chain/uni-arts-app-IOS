//
//  GasPriceConfiguration.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/9.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import BigInt

public struct GasPriceConfiguration {
    static let `default`: BigInt = EthNumberFormatter.full.number(from: "24", units: UnitConfiguration.gasPriceUnit)!
    static let min: BigInt = EthNumberFormatter.full.number(from: "0", units: UnitConfiguration.gasPriceUnit)!
    static let max: BigInt = EthNumberFormatter.full.number(from: "100", units: UnitConfiguration.gasPriceUnit)!
}
