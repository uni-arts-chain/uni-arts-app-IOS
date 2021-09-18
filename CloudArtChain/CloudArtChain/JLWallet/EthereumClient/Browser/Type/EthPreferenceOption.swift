//
//  EthPreferenceOption.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

enum EthPreferenceOption {
    case airdropNotifications
    case browserSearchEngine
    case testNetworks

    var key: String {
        switch self {
        case .airdropNotifications: return "airdropNotifications"
        case .browserSearchEngine: return "browserSearchEngine"
        case .testNetworks: return "browserSearchEngine"
        }
    }
}
