//
//  EthGasPriceRequest.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import JSONRPCKit

struct EthGasPriceRequest: JSONRPCKit.Request {
    typealias Response = String

    var method: String {
        return EthRPCMethods.gasPrice
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw EthCastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
