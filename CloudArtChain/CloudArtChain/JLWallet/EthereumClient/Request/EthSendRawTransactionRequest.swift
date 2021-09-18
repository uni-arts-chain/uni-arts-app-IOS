//
//  EthSendRawTransactionRequest.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/17.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import JSONRPCKit

struct EthSendRawTransactionRequest: JSONRPCKit.Request {
    typealias Response = String

    let signedTransaction: String

    var method: String {
        return EthRPCMethods.sendRawTransaction
    }

    var parameters: Any? {
        return [
            signedTransaction
        ]
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw EthCastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
