//
//  EthDappCommand.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

struct EthDappCommand: Decodable {
    let name: EthScripMethod
    let id: Int
    let object: [String: EthDappCommandObjectValue]
}

struct EthDappCallback {
    let id: Int
    let value: EthDappCallbackValue
}

enum EthDappCallbackValue {
    case signTransaction(Data)
    case sentTransaction(Data)
    case signMessage(Data)
    case signPersonalMessage(Data)
    case signTypedMessage(Data)

    var object: String {
        switch self {
        case .signTransaction(let data):
            return data.hexEncoded
        case .sentTransaction(let data):
            return data.hexEncoded
        case .signMessage(let data):
            return data.hexEncoded
        case .signPersonalMessage(let data):
            return data.hexEncoded
        case .signTypedMessage(let data):
            return data.hexEncoded
        }
    }
}

struct EthDappCommandObjectValue: Decodable {
    public var value: String = ""
    public var array: [EthTypedData] = []
    public init(from coder: Decoder) throws {
        let container = try coder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self.value = String(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self.value = stringValue
        } else {
            guard var arrayContainer = try? coder.unkeyedContainer() else {
                return
            }
//            var arrayContainer = try coder.unkeyedContainer()
            while !arrayContainer.isAtEnd {
                self.array.append(try arrayContainer.decode(EthTypedData.self))
            }
        }
    }
}
