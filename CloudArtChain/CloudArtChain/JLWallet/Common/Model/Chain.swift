import Foundation
import IrohaCrypto

enum Chain: String, Codable, CaseIterable {
    case kusama = "Kusama"
    case uniarts = "UniArts"
    case westend = "Westend"
}

extension Chain {
    var addressType: SNAddressType {
        switch self {
        case .uniarts:
            return .genericSubstrate
        case .kusama:
            return .kusamaMain
        case .westend:
            return .genericSubstrate
        }
    }

    var balanceModuleIndex: UInt8 {
        switch self {
        case .uniarts:
//            return 13
            return 29
        default:
            return 4
        }
    }
    
    var nftModuleIndex: UInt8 {
        return 29
    }

    var transferCallIndex: UInt8 { 0 }
    var createSaleOrderCallIndex: UInt8 { 19 }
    var cancelSaleOrderCallIndex: UInt8 { 20 }

    var keepAliveTransferCallIndex: UInt8 { 3 }
}
