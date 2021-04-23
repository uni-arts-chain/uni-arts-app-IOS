//
//  productSellTransferCall.swift
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/22.
//  Copyright © 2021 朱彬. All rights reserved.
//

import Foundation
import FearlessUtils
import BigInt

struct ProductSellTransferCall: ScaleCodable {
    let recipient: AccountId
    let collectionId: UInt64
    let itemId: UInt64
    let value: UInt64

    init(recipient: AccountId, collectionId: UInt64, itemId: UInt64, value: UInt64) {
        self.recipient = recipient
        self.collectionId = collectionId
        self.itemId = itemId
        self.value = value
    }

    init(scaleDecoder: ScaleDecoding) throws {
        recipient = try AccountId(scaleDecoder: scaleDecoder)
        collectionId = try UInt64(scaleDecoder: scaleDecoder)
        itemId = try UInt64(scaleDecoder: scaleDecoder)
        value = try UInt64(scaleDecoder: scaleDecoder)
    }

    func encode(scaleEncoder: ScaleEncoding) throws {
        try recipient.encode(scaleEncoder: scaleEncoder)
        try collectionId.encode(scaleEncoder: scaleEncoder)
        try itemId.encode(scaleEncoder: scaleEncoder)
        try value.encode(scaleEncoder: scaleEncoder)
    }
}
