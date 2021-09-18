//
//  TokenObject.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/9.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import BigInt
import TrustCore

struct TokenObjectList: Decodable {
    let contract: TokenObject
}

enum TokenObjectType: String {
    case coin
    case ERC20
    case QRC20
}

final class TokenObject: Decodable {
    static let DEFAULT_BALANCE = 0.00
    static let DEFAULT_ORDER = 100000

    @objc dynamic var contract: String = ""
    @objc dynamic var name: String = ""

    @objc private dynamic var rawCoin = -1
    public var coin: Coin {
        get { return Coin(coinType: rawCoin) }
        set { rawCoin = newValue.coinType }
    }

    @objc private dynamic var rawType = ""
    public var type: TokenObjectType {
        get { return TokenObjectType(rawValue: rawType)! }
        set { rawType = newValue.rawValue }
    }

    @objc dynamic var symbol: String = ""
    @objc dynamic var decimals: Int = 0
    @objc dynamic var value: String = ""
    @objc dynamic var isCustom: Bool = false
    @objc dynamic var isDisabled: Bool = false
    @objc dynamic var balance: Double = DEFAULT_BALANCE
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var order: Int = DEFAULT_ORDER
    @objc dynamic var icon: String = ""

    convenience init(
        contract: String = "",
        name: String = "",
        coin: Coin,
        type: TokenObjectType,
        symbol: String = "",
        decimals: Int = 0,
        value: String,
        isCustom: Bool = false,
        isDisabled: Bool = false,
        order: Int = DEFAULT_ORDER,
        icon: String = ""
    ) {
        self.init()
        self.contract = contract
        self.name = name
        self.coin = coin
        self.rawCoin = coin.coinType
        self.type = type
        self.rawType = type.rawValue
        self.symbol = symbol
        self.decimals = decimals
        self.value = value
        self.isCustom = isCustom
        self.isDisabled = isDisabled
        self.order = order
        self.icon = icon
    }

    private enum TokenObjectCodingKeys: String, CodingKey {
        case address
        case name
        case symbol
        case decimals
        case type
        case coin
    }

    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TokenObjectCodingKeys.self)
        var contract = try container.decode(String.self, forKey: .address)
        let name = try container.decode(String.self, forKey: .name)
        let symbol = try container.decode(String.self, forKey: .symbol)
        let decimals = try container.decode(Int.self, forKey: .decimals)
        let coin = try container.decode(Coin.self, forKey: .coin)
        let type = try container.decode(TokenObjectType.self, forKey: .type)
        if let convertedAddress = EthereumAddress(string: contract)?.description {
            contract = convertedAddress
        }
        self.init(contract: contract, name: name, coin: coin, type: type, symbol: symbol, decimals: decimals, value: "0", isCustom: false, isDisabled: false)
    }

    var address: EthereumAddress {
        return EthereumAddress(string: contract)!
    }

    var valueBigInt: BigInt {
        return BigInt(value) ?? BigInt()
    }
    
    var valueBalance: EthBalance {
        return EthBalance(value: valueBigInt)
    }
    
    var contractAddress: EthereumAddress {
        return EthereumAddress(string: contract)!
    }
}

extension TokenObjectType: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawType = try container.decode(String.self)
        guard let type = TokenObjectType(rawValue: rawType) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid type")
        }
        self = type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

