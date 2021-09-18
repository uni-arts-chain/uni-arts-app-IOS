//
//  EthBalanceProtocol.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/15.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import BigInt

protocol EthBalanceProtocol {
    var value: BigInt { get }
    var amountShort: String { get }
    var amountFull: String { get }
}
