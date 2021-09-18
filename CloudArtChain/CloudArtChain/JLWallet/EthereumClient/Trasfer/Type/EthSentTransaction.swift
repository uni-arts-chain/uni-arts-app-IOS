//
//  EthSentTransaction.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import TrustCore

struct EthSentTransaction {
    let id: String
    let original: EthSignTransaction
    let data: Data
}
