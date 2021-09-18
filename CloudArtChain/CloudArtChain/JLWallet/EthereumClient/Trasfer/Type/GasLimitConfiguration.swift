//
//  GasLimitConfiguration.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/9.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import BigInt

public struct GasLimitConfiguration {
    static let `default` = BigInt(90_000)
    static let min = BigInt(21_000)
    static let max = BigInt(600_000)
    static let tokenTransfer = BigInt(144_000)
    static let dappTransfer = BigInt(600_000)
}
