//
//  EthDappAction.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import BigInt
import TrustCore
import WebKit

enum EthDappAction {
    case signMessage(String)
    case signPersonalMessage(String)
    case signTypedMessage([EthTypedData])
    case signTransaction(EthUnconfirmedTransaction)
    case sendTransaction(EthUnconfirmedTransaction)
    case unknown
}

extension EthDappAction {
    static func fromCommand(_ command: EthDappCommand, transfer: Transfer) -> EthDappAction {
        switch command.name {
        case .signTransaction:
            return .signTransaction(EthDappAction.makeUnconfirmedTransaction(command.object, transfer: transfer))
        case .sendTransaction:
            return .sendTransaction(EthDappAction.makeUnconfirmedTransaction(command.object, transfer: transfer))
        case .signMessage:
            let data = command.object["data"]?.value ?? ""
            return .signMessage(data)
        case .signPersonalMessage:
            let data = command.object["data"]?.value ?? ""
            return .signPersonalMessage(data)
        case .signTypedMessage:
            let array = command.object["data"]?.array ?? []
            return .signTypedMessage(array)
        case .unknown:
            return .unknown
        }
    }

    private static func makeUnconfirmedTransaction(_ object: [String: EthDappCommandObjectValue], transfer: Transfer) -> EthUnconfirmedTransaction {
        let to = EthereumAddress(string: object["to"]?.value ?? "")
        let value = BigInt((object["value"]?.value ?? "0").drop0x, radix: 16) ?? BigInt()
        let nonce: BigInt? = {
            guard let value = object["nonce"]?.value else { return .none }
            return BigInt(value.drop0x, radix: 16)
        }()
        let gasLimit: BigInt? = {
            guard let value = object["gasLimit"]?.value ?? object["gas"]?.value else { return .none }
            return BigInt((value).drop0x, radix: 16)
        }()
        let gasPrice: BigInt? = {
            guard let value = object["gasPrice"]?.value else { return .none }
            return BigInt((value).drop0x, radix: 16)
        }()
        let data = Data(hex: object["data"]?.value ?? "0x")

        return EthUnconfirmedTransaction(
            transfer: transfer,
            value: value,
            to: to,
            data: data,
            gasLimit: gasLimit,
            gasPrice: gasPrice,
            nonce: nonce
        )
    }

    static func fromMessage(_ message: WKScriptMessage) -> EthDappCommand? {
        let decoder = JSONDecoder()
        guard let body = message.body as? [String: AnyObject],
            let jsonString = body.jsonString,
            let command = try? decoder.decode(EthDappCommand.self, from: jsonString.data(using: .utf8)!) else {
                return .none
        }
        return command
    }
}
