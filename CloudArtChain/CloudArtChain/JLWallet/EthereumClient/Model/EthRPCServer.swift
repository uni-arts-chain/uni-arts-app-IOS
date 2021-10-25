//
//  EthRPCServer.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/9.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import TrustCore

struct EthRPCServer {
    var chainID = 1
    var name = "Mainnet"
    var symbol = "ETH"
    var rpcURL = URL(string: "https://mainnet.infura.io/v3/" + ETH_DAPP_RPC_SERVER)!
    var coin = Coin.ethereum
    var priceID: Address = EthereumAddress(string: "0x000000000000000000000000000000000000003c")!
    var decimals = 18
}

//enum EthRPCServer {
//    case main
//    case rinkeby
//
//    var id: String {
//        switch self {
//        case .main: return "ethereum"
//        case .rinkeby: return "rinkeby"
//        }
//    }
//
//    var chainID: Int {
//        switch self {
//        case .main: return 1
//        case .rinkeby: return 4
//        }
//    }
//
//    var priceID: Address {
//        switch self {
//        case .main: return EthereumAddress(string: "0x000000000000000000000000000000000000003c")!
//        case .rinkeby: return EthereumAddress(string: "0x000000000000000000000000000000000000003c")!
//        }
//    }
//
//    var isDisabledByDefault: Bool {
//        switch self {
//        case .main: return false
//        case .rinkeby: return false
//        }
//    }
//
//    var name: String {
//        switch self {
//        case .main: return "Ethereum"
//        case .rinkeby: return "Rinkeby"
//        }
//    }
//
//    var displayName: String {
//        return "\(self.name) (\(self.symbol))"
//    }
//
//    var symbol: String {
//        switch self {
//        case .main: return "ETH"
//        case .rinkeby: return "ETH"
//        }
//    }
//
//    var decimals: Int {
//        switch self {
//        case .main:
//            return 18
//        case .rinkeby:
//            return 18
//        }
//    }
//
//    var rpcURL: URL {
////        #if DEBUG
////        let urlString: String = {
////            switch self {
////            case .main: return "https://ropsten.infura.io/v3/8ddd215139c849559864f7aaf7097307"
////            case .rinkeby: return "https://rinkeby.infura.io/v3/8ddd215139c849559864f7aaf7097307"
////            }
////        }()
////        return URL(string: urlString)!
////        #else
//        let urlString: String = {
//            switch self {
//            case .main: return "https://mainnet.infura.io/v3/7e2855d5896946cb985af8944713a371"
//            case .rinkeby: return "https://rinkeby.infura.io/v3/7e2855d5896946cb985af8944713a371"
//            }
//        }()
//        return URL(string: urlString)!
////        #endif
//    }
//
//    var remoteURL: URL {
//        let urlString: String = {
//            switch self {
//            case .main: return "https://api.trustwalletapp.com"
//            case .rinkeby: return "https://api.trustwalletapp.com"
//            }
//        }()
//        return URL(string: urlString)!
//    }
//
//    var ensContract: EthereumAddress {
//        // https://docs.ens.domains/en/latest/introduction.html#ens-on-ethereum
//        switch self {
//        case .main:
//            return EthereumAddress(string: "0x314159265dd8dbb310642f98f50c066173c1259b")!
//        case .rinkeby:
//            return EthereumAddress(string: "0x314159265dd8dbb310642f98f50c066173c1259b")!
//        }
//    }
//
//
//    var openseaPath: String {
//        switch self {
//        case .main, .rinkeby:
//            return EthConstants.dappsOpenSea
//        }
//    }
//
//    var openseaURL: URL? {
//        return URL(string: openseaPath)
//    }
//
//    func opensea(with contract: String, and id: String) -> URL? {
//        return URL(string: (openseaPath + "/assets/\(contract)/\(id)"))
//    }
//
//    var coin: Coin {
//        switch self {
//        case .main: return Coin.ethereum
//        case .rinkeby: return Coin.rinkeby
//        }
//    }
//}

extension EthereumAddress {
    static var zero: EthereumAddress {
        return EthereumAddress(string: "0x0000000000000000000000000000000000000000")!
    }
}

extension Coin {
    public static let rinkeby = Coin(coinType: 60, blockchain: .ethereum)
}
