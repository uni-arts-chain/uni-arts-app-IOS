import Foundation
import FearlessUtils
import BigInt

class AuctionInfo: NSObject, ScaleDecodable {
    let id: UInt64
    let collection_id: UInt64
    let item_id: UInt64
    let value: UInt64
    let owner: AccountId
    @objc let start_price: UInt64
    @objc let increment: UInt64
    @objc let current_price: UInt64
    @objc let start_time: UInt32
    @objc let end_time: UInt32

    required init(scaleDecoder: ScaleDecoding) throws {
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
    
    @objc func getStartPrice(precision: Int16) -> Double {
        return Decimal.fromSubstrateAmount(BigUInt(self.start_price), precision: precision)?.doubleValue ?? 0.0
    }
    
    @objc func getPriceIncrement(precision: Int16) -> Double {
        return Decimal.fromSubstrateAmount(BigUInt(self.increment), precision: precision)?.doubleValue ?? 0.0
    }
    
    @objc func getCurrentPrice(precision: Int16) -> Double {
        return Decimal.fromSubstrateAmount(BigUInt(self.current_price), precision: precision)?.doubleValue ?? 0.0
    }
    
    @objc func getStartTime(currentDate: Date, currentBlockNumber: UInt32) -> Date {
        let currentInterval = currentDate.timeIntervalSince1970
        let auctionStartTimeInterval = TimeInterval(self.start_time - currentBlockNumber) * 6 + currentInterval
        return Date(timeIntervalSince1970: TimeInterval(auctionStartTimeInterval))
    }
    
    @objc func getEndTime(currentDate: Date, currentBlockNumber: UInt32) -> Date {
        let currentInterval = currentDate.timeIntervalSince1970
        let auctionEndTimeInterval = TimeInterval(self.end_time - currentBlockNumber) * 6 + currentInterval
        return Date(timeIntervalSince1970: auctionEndTimeInterval)
    }
}
