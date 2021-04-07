//
//  CreateAuctionCall.swift
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/7.
//  Copyright © 2021 朱彬. All rights reserved.
//

import Foundation
import FearlessUtils
import BigInt

struct CreateAuctionCall: ScaleCodable {
    let collectionId: UInt64
    let itemId: UInt64
    let value: UInt64
    let startPrice: UInt64
    let increment: UInt64
    let startTime: UInt32
    let endTime: UInt32

    init(collectionId: UInt64, itemId: UInt64, value: UInt64, startPrice: UInt64, increment: UInt64, startTime: UInt32, endTime: UInt32) {
        self.collectionId = collectionId
        self.itemId = itemId
        self.value = value
        self.startPrice = startPrice
        self.increment = increment
        self.startTime = startTime
        self.endTime = endTime
    }

    init(scaleDecoder: ScaleDecoding) throws {
        collectionId = try UInt64(scaleDecoder: scaleDecoder)
        itemId = try UInt64(scaleDecoder: scaleDecoder)
        value = try UInt64(scaleDecoder: scaleDecoder)
        startPrice = try UInt64(scaleDecoder: scaleDecoder)
        increment = try UInt64(scaleDecoder: scaleDecoder)
        startTime = try UInt32(scaleDecoder: scaleDecoder)
        endTime = try UInt32(scaleDecoder: scaleDecoder)
    }

    func encode(scaleEncoder: ScaleEncoding) throws {
        try collectionId.encode(scaleEncoder: scaleEncoder)
        try itemId.encode(scaleEncoder: scaleEncoder)
        try value.encode(scaleEncoder: scaleEncoder)
        try startPrice.encode(scaleEncoder: scaleEncoder)
        try increment.encode(scaleEncoder: scaleEncoder)
        try startTime.encode(scaleEncoder: scaleEncoder)
        try endTime.encode(scaleEncoder: scaleEncoder)
    }
}
