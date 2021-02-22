//
//  NetworkRPCRequest.swift
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/18.
//  Copyright © 2021 朱彬. All rights reserved.
//

import Foundation
import RobinHood
import IrohaCrypto
import FearlessUtils

class NetworkRPCRequest: NSObject {
    @objc public static func testAccountInfoUniArts(block: @escaping (_ success: Bool) -> Void) throws {
        try performAccountInfoTest(url: URL(string: "wss://testnet.uniarts.me")!,
                                   address: "14rVH93jroTfgBZF1KLxnvaDYkxiZYgk7ggsJKVa5gFJUMdG",
                                   type: .polkadotMain,
                                   precision: 12)
        block(true)
    }

    static func performAccountInfoTest(url: URL, address: String, type: SNAddressType, precision: Int16) throws {
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
                print("Empty account id")
                return
            }

            Logger.shared.info("Free: \(Decimal.fromSubstrateAmount(accountData.free.value, precision: 12)!)")
            Logger.shared.info("Reserved: \(Decimal.fromSubstrateAmount(accountData.reserved.value, precision: 12)!)")
            Logger.shared.info("Misc Frozen: \(Decimal.fromSubstrateAmount(accountData.miscFrozen.value, precision: 12)!)")
            Logger.shared.info("Fee Frozen: \(Decimal.fromSubstrateAmount(accountData.feeFrozen.value, precision: 12)!)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}
