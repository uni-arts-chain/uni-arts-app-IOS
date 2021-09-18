//
//  EthOperationType.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

enum EthOperationType: String {
    case tokenTransfer = "token_transfer"
    case unknown

    init(string: String) {
        self = EthOperationType(rawValue: string) ?? .unknown
    }
}

extension EthOperationType: Decodable { }
