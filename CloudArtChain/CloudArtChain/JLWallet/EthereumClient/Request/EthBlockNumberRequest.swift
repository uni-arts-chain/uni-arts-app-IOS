//
//  EthBlockNumberRequest.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import BigInt
import Foundation
import JSONRPCKit

struct BlockNumberRequest: JSONRPCKit.Request {
    typealias Response = Int

    var method: String {
        return EthRPCMethods.blockNumber
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String, let value = BigInt(response.drop0x, radix: 16) {
            return numericCast(value)
        } else {
            throw EthCastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
