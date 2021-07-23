import Foundation
import FearlessUtils
import BigInt

struct BidHistory: ScaleCodable {
    func encode(scaleEncoder: ScaleEncoding) throws {
        
    }
    
    let auction_id: UInt64
    let bidder: AccountId
    let bid_price: UInt64
    let bid_time: UInt32
    
    init(scaleDecoder: ScaleDecoding) throws {
        auction_id = try UInt64(scaleDecoder: scaleDecoder)
        bidder = try AccountId(scaleDecoder: scaleDecoder)
        bid_price = try UInt64(scaleDecoder: scaleDecoder)
        bid_time = try UInt32(scaleDecoder: scaleDecoder)
    }
}

struct BidHistoryTest: ScaleDecodable, Decodable {
    init(scaleDecoder: ScaleDecoding) throws {
        auction_id = try UInt64(scaleDecoder: scaleDecoder)
        bidder = try scaleDecoder.readAndConfirm(count: 32)
        bid_price = try UInt64(scaleDecoder: scaleDecoder)
        bid_time = try UInt32(scaleDecoder: scaleDecoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case auction_id
        case bidder
        case bid_price
        case bid_time
    }

    let auction_id: UInt64
    let bidder: Data
    let bid_price: UInt64
    let bid_time: UInt32
    
    func encode(to encoder: Encoder) throws {
        
    }
}


struct AuctionInfo: ScaleDecodable {
    let id: UInt64
    let collection_id: UInt64
    let item_id: UInt64
    let value: UInt64
    let owner: AccountId
    let start_price: UInt64
    let increment: UInt64
    let current_price: UInt64
    let start_time: UInt32
    let end_time: UInt32

    init(scaleDecoder: ScaleDecoding) throws {
        id = try UInt64(scaleDecoder: scaleDecoder)
        collection_id = try UInt64(scaleDecoder: scaleDecoder)
        item_id = try UInt64(scaleDecoder: scaleDecoder)
        value = try UInt64(scaleDecoder: scaleDecoder)
        owner = try AccountId(scaleDecoder: scaleDecoder)
        start_price = try UInt64(scaleDecoder: scaleDecoder)
        increment = try UInt64(scaleDecoder: scaleDecoder)
        current_price = try UInt64(scaleDecoder: scaleDecoder)
        start_time = try UInt32(scaleDecoder: scaleDecoder)
        end_time = try UInt32(scaleDecoder: scaleDecoder)
    }
}

struct AccountInfo: ScaleDecodable {
    let nonce: UInt32
    let consumers: UInt32
    let providers: UInt32
    let data: AccountData

    init(scaleDecoder: ScaleDecoding) throws {
        nonce = try UInt32(scaleDecoder: scaleDecoder)
        consumers = try UInt32(scaleDecoder: scaleDecoder)
        providers = try UInt32(scaleDecoder: scaleDecoder)
        data = try AccountData(scaleDecoder: scaleDecoder)
    }
}

struct AccountData: ScaleDecodable {
    let free: Balance
    let reserved: Balance
    let miscFrozen: Balance
    let feeFrozen: Balance

    init(scaleDecoder: ScaleDecoding) throws {
        free = try Balance(scaleDecoder: scaleDecoder)
        reserved = try Balance(scaleDecoder: scaleDecoder)
        miscFrozen = try Balance(scaleDecoder: scaleDecoder)
        feeFrozen = try Balance(scaleDecoder: scaleDecoder)
    }
}

struct Balance: ScaleCodable {
    let value: BigUInt

    init(value: BigUInt) {
        self.value = value
    }

    init(scaleDecoder: ScaleDecoding) throws {
        let data = try scaleDecoder.read(count: 16)
        value = BigUInt(Data(data.reversed()))
        try scaleDecoder.confirm(count: 16)
    }

    func encode(scaleEncoder: ScaleEncoding) throws {
        var encodedData: [UInt8] = value.serialize().reversed()

        while encodedData.count < 16 {
            encodedData.append(0)
        }

        scaleEncoder.appendRaw(data: Data(encodedData))
    }
}
