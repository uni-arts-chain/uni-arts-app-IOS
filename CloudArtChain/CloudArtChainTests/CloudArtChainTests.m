//
//  CloudArtChainTests.m
//  CloudArtChainTests
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import "CloudArtChain-swift.h"

@interface CloudArtChainTests : XCTestCase

@end

@implementation CloudArtChainTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

//- (void)testHelthCheck {
//    // given
//    [NSURL URLWithString:@"wss://westend-rpc.polkadot.io/"];
//    let logger = Logger.shared
//    let operationQueue = OperationQueue()
//
//    let engine = WebSocketEngine(url: url, logger: logger)
//
//    // when
//
//    let operation = JSONRPCListOperation<Health>(engine: engine,
//                                                 method: "system_health")
//
//    operationQueue.addOperations([operation], waitUntilFinished: true)
//
//    // then
//
//    do {
//        let result = try operation.extractResultData(throwing: BaseOperationError.parentOperationCancelled)
//        logger.debug("Received response: \(result)")
//    } catch {
//        XCTFail("Unexpected error: \(error)")
//    }
//}

@end
