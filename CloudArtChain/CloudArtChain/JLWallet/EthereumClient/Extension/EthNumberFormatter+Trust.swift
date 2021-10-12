//
//  EthNumberFormatter+Trust.swift
//  CloudArtChain
//
//  Created by jielian on 2021/10/11.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

extension EthNumberFormatter {
    static let balance: EthNumberFormatter = {
        let formatter = EthNumberFormatter()
        formatter.maximumFractionDigits = 7
        return formatter
    }()
}
