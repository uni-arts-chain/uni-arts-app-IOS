//
//  EthWalletInfo.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/3.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import TrustKeystore
import TrustCore
import BigInt

struct EthWalletInfo {
    let type: EthWalletType
    let storeKey: String

    var address: Address {
        switch type {
        case .privateKey, .hd:
            return currentAccount.address
        case .address(_, let address):
            return address
        }
    }

    var coin: Coin? {
        switch type {
        case .privateKey, .hd:
            guard let account = currentAccount else {
                    return .none
            }
            return Coin(coinType: account.derivationPath.coinType)
        case .address(let coin, _):
            return coin
        }
    }

    var multiWallet: Bool {
        return accounts.count > 1
    }
    
    var accounts: [Account] {
        switch type {
        case .privateKey(let account), .hd(let account):
            return account.accounts
        case .address(let coin, let address):
            return [
                Account(wallet: .none, address: address, derivationPath: coin.derivationPath(at: 0)),
            ]
        }
    }

    var currentAccount: Account! {
        switch type {
        case .privateKey, .hd:
            return accounts.first //.filter { $0.description == info.selectedAccount }.first ?? accounts.first!
        case .address(let coin, let address):
            return Account(wallet: .none, address: address, derivationPath: coin.derivationPath(at: 0))
        }
    }

    var currentWallet: Wallet? {
        switch type {
        case .privateKey(let wallet), .hd(let wallet):
            return wallet
        case .address:
            return .none
        }
    }

    var isWatch: Bool {
        switch type {
        case .privateKey, .hd:
            return false
        case .address:
            return true
        }
    }

    init(
        type: EthWalletType,
        storeKey: String
    ) {
        self.type = type
        self.storeKey = storeKey
    }

    var description: String {
        return type.description
    }
}

extension EthWalletInfo: Equatable {
    static func == (lhs: EthWalletInfo, rhs: EthWalletInfo) -> Bool {
        return lhs.type.description == rhs.type.description
    }
}
