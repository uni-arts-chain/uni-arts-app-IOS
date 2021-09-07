//
//  EthereumUnit.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/3.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

public enum EthereumUnit: Int64 {
    case wei = 1
    case kwei = 1_000
    case mwei = 1_000_000
    case gwei = 1_000_000_000
    case ether = 1_000_000_000_000_000_000
}

extension EthereumUnit {
    var name: String {
        switch self {
        case .wei: return "Wei"
        case .kwei: return "Kwei"
        case .mwei: return "Mwei"
        case .gwei: return "Gwei"
        case .ether: return "Ether"
        }
    }
}

//https://github.com/ethereumjs/ethereumjs-units/blob/master/units.json
