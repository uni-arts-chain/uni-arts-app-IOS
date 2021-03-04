//
//  RPCTest.swift
//  CloudArtChainTests
//
//  Created by 朱彬 on 2020/11/13.
//  Copyright © 2020 朱彬. All rights reserved.
//

import XCTest
import RobinHood
import IrohaCrypto
import FearlessUtils
import BigInt

class RPCTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testHelthCheck() {
        // given

        let url = URL(string: "wss://westend-rpc.polkadot.io/")!
        let logger = Logger.shared
        let operationQueue = OperationQueue()

        let engine = WebSocketEngine(url: url, logger: logger)

        // when

        let operation = JSONRPCListOperation<Health>(engine: engine,
                                                     method: "system_health")

        operationQueue.addOperations([operation], waitUntilFinished: true)

        // then

        do {
            let result = try operation.extractResultData(throwing: BaseOperationError.parentOperationCancelled)
            logger.debug("Received response: \(result)")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testAccountInfoUniArts() throws {
        try performAccountInfoTest(url: URL(string: "wss://testnet.uniarts.me")!,
                                   address: "14rVH93jroTfgBZF1KLxnvaDYkxiZYgk7ggsJKVa5gFJUMdG",
                                   type: .genericSubstrate,
                                   precision: 12)
    }
    
    func performAccountInfoTest(url: URL, address: String, type: SNAddressType, precision: Int16) throws {
        // given

        let logger = Logger.shared
        let operationQueue = OperationQueue()

        let engine = WebSocketEngine(url: url, logger: logger)

        // when

        let identifier = try SS58AddressFactory().accountId(fromAddress: address,
                                                            type: type)

        let key = try StorageKeyFactory().accountInfoKeyForId(identifier).toHex(includePrefix: true)

        let operation = JSONRPCListOperation<JSONScaleDecodable<AccountInfo>>(engine: engine,
                                                                              method: RPCMethod.getStorage,
                                                                              parameters: [key])

        operationQueue.addOperations([operation], waitUntilFinished: true)

        // then

        do {
            let result = try operation.extractResultData(throwing: BaseOperationError.parentOperationCancelled)

            guard let accountData = result.underlyingValue?.data else {
                XCTFail("Empty account id")
                return
            }

            Logger.shared.debug("Free: \(Decimal.fromSubstrateAmount(accountData.free.value, precision: precision)!)")
            Logger.shared.debug("Reserved: \(Decimal.fromSubstrateAmount(accountData.reserved.value, precision: precision)!)")
            Logger.shared.debug("Misc Frozen: \(Decimal.fromSubstrateAmount(accountData.miscFrozen.value, precision: precision)!)")
            Logger.shared.debug("Fee Frozen: \(Decimal.fromSubstrateAmount(accountData.feeFrozen.value, precision: precision)!)")

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testAuctionList() throws {
        try performAuctionList(url: URL(string: "wss://testnet.uniarts.me")!, collectionID: 1, itemID: 67, precision: 12)
    }
    
    func performAuctionList(url: URL, collectionID: UInt64, itemID: UInt64, precision: Int16) throws {
        let logger = Logger.shared
        let operationQueue = OperationQueue()
        let engine = WebSocketEngine(url: url, logger: logger)
        
        let call = AuctionListCall(collectionId: collectionID)
        let callEncoder = ScaleEncoder()
        try call.encode(scaleEncoder: callEncoder)
        let callArguments = callEncoder.encode()
        
        var collectionInt = collectionID
        let collectionData: Data = Data(bytes: &collectionInt, count: MemoryLayout<UInt64>.size)
        
        var itemInt = itemID
        let itemData: Data = Data(bytes: &itemInt, count: MemoryLayout<UInt64>.size)
        
        let key = try (StorageKeyFactory().auctionList() + (collectionData.blake128Concat() + itemData.blake128Concat())).toHex(includePrefix: true)
//        let key = "0xf43ffbe61ef468749d3617ac1a63c4b7636beab08dba743172af6792d8ec59019ea2d098b5f70192f96c06f38d3fbc9701000000000000009451b00276b84c5a3e7b7be2aedc6df74300000000000000"
        
        let operation = JSONRPCListOperation<JSONScaleDecodable<AuctionInfo>>(engine: engine,
                                                                              method: RPCMethod.getStorage,
                                                                              parameters: [key])
        operationQueue.addOperations([operation], waitUntilFinished: true)
        do {
            let result = try operation.extractResultData(throwing: BaseOperationError.parentOperationCancelled)

            guard let aunctionData = result.underlyingValue else {
                XCTFail("Empty aunction list")
                return
            }

            print("start_price: \(Decimal.fromSubstrateAmount(BigUInt(aunctionData.start_price), precision: precision)!)")
            print("increment: \(Decimal.fromSubstrateAmount(BigUInt(aunctionData.increment), precision: precision)!)")
            print("current_price: \(Decimal.fromSubstrateAmount(BigUInt(aunctionData.current_price), precision: precision)!)")
            print(NSString(data: aunctionData.owner.value, encoding: String.Encoding.utf8.rawValue) ?? "解析错误")
            print(aunctionData)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testMetaData() throws {
        try getMetaData(url: URL(string: "wss://testnet.uniarts.me")!)
    }
    
    func getMetaData(url: URL) throws {
        let logger = Logger.shared
        let operationQueue = OperationQueue()

        let engine = WebSocketEngine(url: url, logger: logger)
        
        let operation = JSONRPCListOperation<JSONScaleDecodable<String>>(engine: engine,
                                                                              method: RPCMethod.getMetaData,
                                                                              parameters: nil)

        operationQueue.addOperations([operation], waitUntilFinished: true)

        // then

        do {
            let result = try operation.extractResultData(throwing: BaseOperationError.parentOperationCancelled)

            guard let metaData = result.underlyingValue?.data else {
                XCTFail("Empty metaData")
                return
            }
            print("matadata: \(metaData)")

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
