//
//  EthWalletType.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/3.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import TrustCore
import TrustKeystore

enum EthWalletType {
    struct Keys {
        static let walletPrivateKey = "wallet-private-key-"
        static let walletHD = "wallet-hd-wallet-"
        static let address = "wallet-address-"
    }

    case privateKey(Wallet)
    case hd(Wallet)
    case address(Coin, EthereumAddress)

    var description: String {
        switch self {
        case .privateKey(let account):
            return Keys.walletPrivateKey + account.identifier
        case .hd(let account):
            return Keys.walletHD + account.identifier
        case .address(let coin, let address):
            return Keys.address + "\(coin.coinType)" + "-" + address.description
        }
    }
}

extension EthWalletType: Equatable {
    static func == (lhs: EthWalletType, rhs: EthWalletType) -> Bool {
        switch (lhs, rhs) {
        case (let .privateKey(lhs), let .privateKey(rhs)):
            return lhs == rhs
        case (let .hd(lhs), let .hd(rhs)):
            return lhs == rhs
        case (let .address(lhs1, lhs2), let .address(rhs1, rhs2)):
            return lhs1 == rhs1 && lhs2 == rhs2
        case (.privateKey, _),
             (.hd, _),
             (.address, _):
            return false
        }
    }
}
