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
                                   type: .polkadotMain,
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
