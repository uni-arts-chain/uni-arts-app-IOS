//
//  EthCallRequest.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/15.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import JSONRPCKit

struct EthCallRequest: JSONRPCKit.Request {
    typealias Response = String

    let to: String
    let data: String

    var method: String {
        return EthRPCMethods.call
    }

    var parameters: Any? {
        return [["to": to, "data": data], "latest"]
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw EthCastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
