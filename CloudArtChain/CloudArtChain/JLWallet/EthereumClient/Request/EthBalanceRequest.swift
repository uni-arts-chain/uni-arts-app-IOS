//
//  EthBalanceRequest.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/15.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import BigInt
import JSONRPCKit

struct EthBalanceRequest: JSONRPCKit.Request {
    typealias Response = EthBalance

    let address: String

    var method: String {
        return EthRPCMethods.getBalance
    }

    var parameters: Any? {
        return [address, "latest"]
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String, let value = BigInt(response.drop0x, radix: 16) {
            return EthBalance(value: value)
        } else {
            throw EthCastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
