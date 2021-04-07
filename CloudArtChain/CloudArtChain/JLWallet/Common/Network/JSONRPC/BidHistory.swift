import Foundation
import FearlessUtils
import BigInt

@objc class BidHistory: NSObject, ScaleCodable {
    func encode(scaleEncoder: ScaleEncoding) throws {
        
    }
    
    let auction_id: UInt64
    @objc let bidder: AccountId
    let bid_price: UInt64
    @objc let bid_time: UInt32
    
    required init(scaleDecoder: ScaleDecoding) throws {
        auction_id = try UInt64(scaleDecoder: scaleDecoder)
        bidder = try AccountId(scaleDecoder: scaleDecoder)
        bid_price = try UInt64(scaleDecoder: scaleDecoder)
        bid_time = try UInt32(scaleDecoder: scaleDecoder)
    }
    
    @objc func getBidPrice(precision: Int16) -> Double {
        return (Decimal.fromSubstrateAmount(BigUInt(bid_price), precision: precision)!).doubleValue
    }
    
    @objc func getBidTime(currentDate: Date, blockNumber: UInt32) -> Date {
        let currentInterval = currentDate.timeIntervalSince1970
        let auctionStartTimeInterval = (self.bid_time - blockNumber) * 6 + UInt32(currentInterval);
        return Date(timeIntervalSince1970: TimeInterval(auctionStartTimeInterval))
    }
    
    @objc func getDoubleBidTime() -> Double {
        return (Decimal.fromSubstrateAmount(BigUInt(bid_time), precision: 0)!).doubleValue
    }
}
