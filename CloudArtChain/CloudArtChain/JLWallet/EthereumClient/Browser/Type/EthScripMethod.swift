//
//  EthScripMethod.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

enum EthScripMethod: String, Decodable {
    case sendTransaction
    case signTransaction
    case signPersonalMessage
    case signMessage
    case signTypedMessage
    case unknown

    init(string: String) {
        self = EthScripMethod(rawValue: string) ?? .unknown
    }
}
