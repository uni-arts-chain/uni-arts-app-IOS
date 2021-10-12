//
//  EthRPCServer.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/9.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import TrustCore

enum EthRPCServer {
    case main
    case rinkeby
    case quaternions
    case uniarts

    var id: String {
        switch self {
        case .main: return "ethereum"
        case .rinkeby: return "rinkeby"
        case .quaternions: return "quaternions"
        case .uniarts: return "uniarts"
        }
    }

    var chainID: Int {
        switch self {
        case .main: return 1
        case .rinkeby: return 4
        case .quaternions: return 1596421679
        case .uniarts: return 1596421679
        }
    }

    var priceID: Address {
        switch self {
        case .main: return EthereumAddress(string: "0x000000000000000000000000000000000000003c")!
        case .rinkeby: return EthereumAddress(string: "0x000000000000000000000000000000000000003c")!
        case .quaternions: return EthereumAddress(string: "0x000000000000000000000000000000000000003E")!
        case .uniarts: return EthereumAddress(string: "0x000000000000000000000000000000000000003E")!
        }
    }

    var isDisabledByDefault: Bool {
        switch self {
        case .main: return false
        case .rinkeby: return false
        case .quaternions: return false
        case .uniarts: return false
        }
    }

    var name: String {
        switch self {
        case .main: return "Ethereum"
        case .rinkeby: return "Rinkeby"
        case .quaternions: return "Quaternions"
        case .uniarts: return "UniArts"
        }
    }

    var displayName: String {
        return "\(self.name) (\(self.symbol))"
    }

    var symbol: String {
        switch self {
        case .main: return "ETH"
        case .rinkeby: return "ETH"
        case .quaternions: return "ETH"
        case .uniarts: return "ETH"
        }
    }

    var decimals: Int {
        switch self {
        case .main:
            return 18
        case .rinkeby:
            return 18
        case .quaternions:
            return 18
        case .uniarts:
            return 18
        }
    }

    var rpcURL: URL {
//        #if DEBUG
//        let urlString: String = {
//            switch self {
//            case .main: return "https://ropsten.infura.io/v3/8ddd215139c849559864f7aaf7097307"
//            case .rinkeby: return "https://rinkeby.infura.io/v3/YOUR-PROJECT-ID"
//            case .quaternions: return "http://rpc.tatmasglobal.com"
//            }
//        }()
//        return URL(string: urlString)!
//        #else
        let urlString: String = {
            switch self {
            case .main: return "https://mainnet.infura.io/v3/7e2855d5896946cb985af8944713a371"
            case .rinkeby: return "https://rinkeby.infura.io/v3/7e2855d5896946cb985af8944713a371"
            case .quaternions: return "https://rpc.tatmasglobal.com"
            case .uniarts: return "https://demo.uniarts.network"
            }
        }()
        return URL(string: urlString)!
//        #endif
    }

    var remoteURL: URL {
        let urlString: String = {
            switch self {
            case .main: return "https://api.trustwalletapp.com"
            case .rinkeby: return "https://api.trustwalletapp.com"
            case .quaternions: return "https://api.trustwalletapp.com"
            case .uniarts: return "https://api.trustwalletapp.com"
            }
        }()
        return URL(string: urlString)!
    }

    var ensContract: EthereumAddress {
        // https://docs.ens.domains/en/latest/introduction.html#ens-on-ethereum
        switch self {
        case .main:
            return EthereumAddress(string: "0x314159265dd8dbb310642f98f50c066173c1259b")!
        case .rinkeby:
            return EthereumAddress(string: "0x314159265dd8dbb310642f98f50c066173c1259b")!
        case .quaternions:
            return EthereumAddress.zero
        case .uniarts:
            return EthereumAddress.zero
        }
    }
    
    

    var openseaPath: String {
        switch self {
        case .main, .rinkeby, .quaternions, .uniarts:
            return EthConstants.dappsOpenSea
        }
    }

    var openseaURL: URL? {
        return URL(string: openseaPath)
    }

    func opensea(with contract: String, and id: String) -> URL? {
        return URL(string: (openseaPath + "/assets/\(contract)/\(id)"))
    }

    var coin: Coin {
        switch self {
        case .main: return Coin.ethereum
        case .rinkeby: return Coin.rinkeby
        case .quaternions: return Coin.quaternions
        case .uniarts: return Coin.uniarts
        }
    }
}

extension EthereumAddress {
    static var zero: EthereumAddress {
        return EthereumAddress(string: "0x0000000000000000000000000000000000000000")!
    }
}

extension Coin {
    public static let rinkeby = Coin(coinType: 60, blockchain: .ethereum)
    public static let quaternions = Coin(coinType: 1596421679, blockchain: .ethereum)
    public static let uniarts = Coin(coinType: 1596421679, blockchain: .ethereum)
}
