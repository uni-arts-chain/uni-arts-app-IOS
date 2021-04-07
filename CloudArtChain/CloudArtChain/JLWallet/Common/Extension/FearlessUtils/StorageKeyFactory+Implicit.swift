import Foundation
import FearlessUtils

extension StorageKeyFactoryProtocol {
    func nftCreateSaleOrder(_ identifier: Data) throws -> Data {
        try createStorageKey(moduleName: "Nft",
                             serviceName: "CreateSaleOrder",
                             identifier: identifier,
                             hasher: Blake128Concat())
    }
    
    func accountInfoKeyForId(_ identifier: Data) throws -> Data {
        try createStorageKey(moduleName: "System",
                             serviceName: "Account",
                             identifier: identifier,
                             hasher: Blake128Concat())
    }

    func bondedKeyForId(_ identifier: Data) throws -> Data {
        try createStorageKey(moduleName: "Staking",
                             serviceName: "Bonded",
                             identifier: identifier,
                             hasher: Twox64Concat())
    }

    func stakingInfoForControllerId(_ identifier: Data) throws -> Data {
        try createStorageKey(moduleName: "Staking",
                             serviceName: "Ledger",
                             identifier: identifier,
                             hasher: Blake128Concat())
    }

    func activeEra() throws -> Data {
        try createStorageKey(moduleName: "Staking",
                             serviceName: "ActiveEra")
    }
    
    func auctionList() throws -> Data {
        try createStorageKey(moduleName: "Nft", serviceName: "AuctionList")
    }
    
    func auctionBidHistoryList() throws -> Data {
        try createStorageKey(moduleName: "Nft", serviceName: "BidHistoryList")
    }
 }
