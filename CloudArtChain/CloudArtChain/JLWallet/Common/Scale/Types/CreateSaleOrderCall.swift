//
//  CreateSaleOrderCall.swift
//  fearless
//
//  Created by 朱彬 on 2021/1/15.
//  Copyright © 2021 Soramitsu. All rights reserved.
//

import Foundation
import FearlessUtils
import BigInt

struct CreateSaleOrderCall: ScaleCodable {
    let collectionId: UInt64
    let itemId: UInt64
    let value: UInt64
    let price: UInt64

    init(collectionId: UInt64, itemId: UInt64, value: UInt64, price: UInt64) {
        self.collectionId = collectionId
        self.itemId = itemId
        self.value = value
        self.price = price
    }

    init(scaleDecoder: ScaleDecoding) throws {
        collectionId = try UInt64(scaleDecoder: scaleDecoder)
        itemId = try UInt64(scaleDecoder: scaleDecoder)
        value = try UInt64(scaleDecoder: scaleDecoder)
        price = try UInt64(scaleDecoder: scaleDecoder)
    }

    func encode(scaleEncoder: ScaleEncoding) throws {
        try collectionId.encode(scaleEncoder: scaleEncoder)
        try itemId.encode(scaleEncoder: scaleEncoder)
        try value.encode(scaleEncoder: scaleEncoder)
        try price.encode(scaleEncoder: scaleEncoder)
    }
}
