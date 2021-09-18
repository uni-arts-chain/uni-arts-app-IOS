//
//  EthEstimateGasRequest.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import JSONRPCKit
import TrustCore
import BigInt

struct EthEstimateGasRequest: JSONRPCKit.Request {
    typealias Response = String

    let transaction: EthSignTransaction

    var method: String {
        return EthRPCMethods.estimateGas
    }

    var parameters: Any? {
        return [
            [
                "from": transaction.account.address.description.lowercased(),
                "to": transaction.to?.description.lowercased() ?? "",
                //TODO: Update gas limit when changed by the user.
                // Hardcoded for simplicify to fetch estimated gas
                //"gas": BigInt(7_000_000).hexEncoded,
                "gasPrice": transaction.gasPrice.hexEncoded,
                "value": transaction.value.hexEncoded,
                "data": transaction.data.hexEncoded,
            ],
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
