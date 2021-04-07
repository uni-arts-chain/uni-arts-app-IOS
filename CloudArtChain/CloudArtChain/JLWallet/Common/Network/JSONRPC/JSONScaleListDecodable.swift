import Foundation
import FearlessUtils

struct JSONScaleListDecodable: Decodable {
    var underlyingValue: Array<BidHistory>?

    init(value: Array<BidHistory>?) {
        self.underlyingValue = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            underlyingValue = nil
        } else {
            let value = try container.decode(String.self)
            let data = try Data(hexString: value)
            let scaleDecoder = try ScaleDecoder(data: data)
            underlyingValue = try Array<BidHistory>(scaleDecoder: scaleDecoder)
        }
    }
}
