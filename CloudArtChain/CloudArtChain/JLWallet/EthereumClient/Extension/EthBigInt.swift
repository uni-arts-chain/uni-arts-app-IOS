//
//  EthBigInt.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/15.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import BigInt

extension BigInt {
    var hexEncoded: String {
        return "0x" + String(self, radix: 16)
    }
}
