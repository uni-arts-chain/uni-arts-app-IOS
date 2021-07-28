import Foundation
import FearlessUtils

extension StorageKeyFactoryProtocol {
    func updatedTripleRefCount() throws -> Data {
        try createStorageKey(moduleName: "System",
                             storageName: "UpgradedToTripleRefCount")
    }
    func nftCreateSaleOrder(_ identifier: Data) throws -> Data {
        try createStorageKey(moduleName: "Nft",
                             storageName: "CreateSaleOrder",
                             key: identifier,
                             hasher: .blake128Concat)
    }
    
    func accountInfoKeyForId(_ identifier: Data) throws -> Data {
        try createStorageKey(moduleName: "System",
                             storageName: "Account",
                             key: identifier,
                             hasher: .blake128Concat)
    }

    func bondedKeyForId(_ identifier: Data) throws -> Data {
        try createStorageKey(moduleName: "Staking",
                             storageName: "Bonded",
                             key: identifier,
                             hasher: .twox64Concat)
    }

    func stakingInfoForControllerId(_ identifier: Data) throws -> Data {
        try createStorageKey(moduleName: "Staking",
                             storageName: "Ledger",
                             key: identifier,
                             hasher: .blake128Concat)
    }

    func activeEra() throws -> Data {
        try createStorageKey(moduleName: "Staking",
                             storageName: "ActiveEra")
    }
    
    func auctionList() throws -> Data {
        try createStorageKey(moduleName: "Nft", storageName: "AuctionList")
    }
    
    func auctionBidHistoryList() throws -> Data {
        try createStorageKey(moduleName: "Nft", storageName: "BidHistoryList")
    }
 }
