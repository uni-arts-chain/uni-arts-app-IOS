import Foundation
import IrohaCrypto

extension SNAddressType {
    init(chain: Chain) {
        switch chain {
        case .uniarts:
            self = .polkadotMain
        case .kusama:
            self = .kusamaMain
        case .westend:
            self = .genericSubstrate
        }
    }

    var chain: Chain {
        switch self {
        case .kusamaMain:
            return .kusama
        case .polkadotMain:
            return .uniarts
        default:
            return .westend
        }
    }

    var precision: Int16 {
        switch self {
        case .polkadotMain:
            return 12
        case .genericSubstrate:
            return 12
        default:
            return 12
        }
    }
}
