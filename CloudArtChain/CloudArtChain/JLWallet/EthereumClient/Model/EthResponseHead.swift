//
//  EthResponseHead.swift
//  CloudArtChain
//
//  Created by jielian on 2021/10/12.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

struct EthResponseHead: Decodable {
    var code: Int
    var msg: String
}
