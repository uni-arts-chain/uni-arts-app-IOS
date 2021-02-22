import Foundation
import IrohaCrypto

extension WalletAssetId {
    var chain: Chain? {
        switch self {
        case .uniarts:
            return .uniarts
        case .kusama:
            return .kusama
        case .westend:
            return .westend
        case .usd:
            return nil
        }
    }
}
