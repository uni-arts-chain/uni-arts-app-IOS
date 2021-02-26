//
//  AuctionListCall.swift
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/26.
//  Copyright © 2021 朱彬. All rights reserved.
//

import Foundation
import FearlessUtils
import BigInt

struct AuctionListCall: ScaleCodable {
    let collectionId: UInt64

    init(collectionId: UInt64) {
        self.collectionId = collectionId
    }

    init(scaleDecoder: ScaleDecoding) throws {
        collectionId = try UInt64(scaleDecoder: scaleDecoder)
    }

    func encode(scaleEncoder: ScaleEncoding) throws {
        try collectionId.encode(scaleEncoder: scaleEncoder)
    }
}
