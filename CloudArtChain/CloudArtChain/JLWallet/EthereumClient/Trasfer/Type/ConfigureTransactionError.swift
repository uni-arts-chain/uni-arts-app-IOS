//
//  ConfigureTransactionError.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/9.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import BigInt

enum ConfigureTransactionError: LocalizedError {
    case gasLimitTooHigh
    case gasFeeTooHigh(EthRPCServer)

    var errorDescription: String? {
        switch self {
        case .gasLimitTooHigh:
            return String(
                format: NSLocalizedString(
                    "configureTransaction.error.gasLimitTooHigh",
                    value: "Gas Limit too high. Max available: %d",
                    comment: ""
                ),
                ConfigureTransaction.gasLimitMax
            )
        case .gasFeeTooHigh(let server):
            return String(
                format: NSLocalizedString(
                    "configureTransaction.error.gasFeeHigh",
                    value: "Gas Fee is too high. Max available: %@ %@",
                    comment: ""
                ),
                EthNumberFormatter.full.string(from: ConfigureTransaction.gasFeeMax),
                server.symbol
            )
        }
    }
}
