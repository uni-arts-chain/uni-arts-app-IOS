//
//  EthCryptoAddressValidator.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

enum EthAddressValidatorType {
    case ethereum

    var addressLength: Int {
        switch self {
        case .ethereum: return 42
        }
    }
}

struct EthCryptoAddressValidator {
    static func isValidAddress(_ value: String?, type: EthAddressValidatorType = .ethereum) -> Bool {
        return value?.range(of: "^0x[a-fA-F0-9]{40}$", options: .regularExpression) != nil
    }
}
