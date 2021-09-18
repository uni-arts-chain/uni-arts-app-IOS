//
//  EthGetTransactionCountRequest.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/17.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import BigInt
import Foundation
import JSONRPCKit

struct EthGetTransactionCountRequest: JSONRPCKit.Request {
    typealias Response = BigInt

    let address: String
    let state: String

    var method: String {
        return EthRPCMethods.getTransactionCount
    }

    var parameters: Any? {
        return [
            address,
            state,
        ]
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String {
            return BigInt(response.drop0x, radix: 16) ?? BigInt()
        } else {
            throw EthCastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
