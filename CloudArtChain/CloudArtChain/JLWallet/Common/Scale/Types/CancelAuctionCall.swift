//
//  CancelAuctionCall.swift
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/7.
//  Copyright © 2021 朱彬. All rights reserved.
//

import Foundation
import FearlessUtils
import BigInt

struct CancelAuctionCall: ScaleCodable {
    let collectionId: UInt64
    let itemId: UInt64

    init(collectionId: UInt64, itemId: UInt64) {
        self.collectionId = collectionId
        self.itemId = itemId
    }

    init(scaleDecoder: ScaleDecoding) throws {
        collectionId = try UInt64(scaleDecoder: scaleDecoder)
        itemId = try UInt64(scaleDecoder: scaleDecoder)
    }

    func encode(scaleEncoder: ScaleEncoding) throws {
        try collectionId.encode(scaleEncoder: scaleEncoder)
        try itemId.encode(scaleEncoder: scaleEncoder)
    }
}
