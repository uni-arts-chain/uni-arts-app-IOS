//
//  JLWalletTool+Transfer.swift
//  CloudArtChain
//
//  Created by jielian on 2021/8/3.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import UIKit
import CommonWallet
import SoraKeystore
import RobinHood
import IrohaCrypto
import SoraFoundation
import BigInt
import FearlessUtils

// MARK: 交易
extension JLWalletTool {
    
    func transfer(accountId: AccountId, collectionId: UInt64, itemId: UInt64, value: UInt64, block: @escaping (Bool, String?) -> Void) {
        let productSellTransferCall = ProductSellTransferCall(recipient: accountId, collectionId: collectionId, itemId: itemId, value: value)
        // module、call名称
        let moduleName = "Nft"
        let callName = "transfer"
        // 验证metadata的有效性
        verificationRuntimeMetadata(moduleName: moduleName, callName: callName) { [weak self] isSuccess, moduleIndex, callIndex, errorMessage in
            if isSuccess {
                do {
                    try self?.transferOp(receiverAccountId: accountId,call: productSellTransferCall, moduleIndex: moduleIndex!, callIndex: callIndex!, block: block)
                } catch {
                    print(error)
                }
            }else {
                block(isSuccess, errorMessage)
            }
        }
    }
    
    func transferOp(receiverAccountId: AccountId, call: ScaleCodable, moduleIndex: UInt8, callIndex: UInt8, block: @escaping (Bool, String?) -> Void) throws {
        
        guard let selectedAccount = SettingsManager.shared.selectedAccount else {
            return
        }

        guard let connection = WebSocketService.shared.connection else {
            return
        }
        print("======>>>>selectedAccount: ", selectedAccount)
        print("======>>>>selectedConnection: ", connection)
        print("======>>>>当前地址: \(selectedAccount.address)")
        print("======>>>>转让地址: ", receiverAccountId.address()!)
        print("======>>>>moduleIndex: ", moduleIndex)
        print("======>>>>callIndex: ", callIndex)

        let networkType = SettingsManager.shared.selectedConnection.type
        let chain = networkType.chain
        print("======>>>>networkType: ", networkType)
        print("======>>>>chain: ", chain)

        let accountSigner = SigningWrapper(keystore: Keychain(), settings: SettingsManager.shared)
        print("======>>>>accountSigner: ", accountSigner)
        
        let operationQueue = OperationQueue()

        let transferOperation = JSONRPCListOperation<String>(engine: connection,
                                                             method: RPCMethod.submitExtrinsic)
        
        let compoundTransfer = try setupTransferExtrinsic(transferOperation,
                                                      call: call,
                                                      moduleIndex: moduleIndex,
                                                      callIndex: callIndex,
                                                      receiverAccountId: receiverAccountId.value,
                                                      chain: chain,
                                                      signer: accountSigner,
        engine: connection)
        
        let mapOperation: ClosureOperation<Data> = ClosureOperation {
                do {
                    let hashString = try transferOperation
                        .extractResultData(throwing: BaseOperationError.parentOperationCancelled)
                    DispatchQueue.main.async {
                        block(true,"")
                    }
                    return try Data(hexString: hashString)
                } catch {
                    DispatchQueue.main.async {
                        block(false, error.localizedDescription)
                    }
                    print("Unexpected error: \(error)")
                    return Data()
                }
        }

        mapOperation.addDependency(compoundTransfer.targetOperation)
        
        let operationWrapper = CompoundOperationWrapper(targetOperation: mapOperation,
                                        dependencies: compoundTransfer.allOperations)
        
        operationQueue.addOperations(operationWrapper.allOperations, waitUntilFinished: false)
    }
    
    func setupTransferExtrinsic<T>(_ targetOperation: JSONRPCListOperation<T>,
                                   call: ScaleCodable?,
                                   moduleIndex: UInt8,
                                   callIndex: UInt8,
                                   receiverAccountId: Data,
                                   chain: Chain,
                                   signer: IRSignatureCreatorProtocol,
                                   engine: JSONRPCEngine) throws -> CompoundOperationWrapper<T> {
        
        let primitiveFactory = WalletPrimitiveFactory(keystore: Keychain(),
                                   settings: SettingsManager.shared)
        let accountSettings = try primitiveFactory.createAccountSettings()
        let sender = accountSettings.accountId
        
        let selectedAccount = SettingsManager.shared.selectedAccount
        let currentCryptoType = selectedAccount!.cryptoType

        let nonceOperation = createExtrinsicNonceFetchOperation(chain, engine: engine)
        let runtimeVersionOperation = createRuntimeVersionOperation(engine: engine)

        targetOperation.configurationBlock = {
            do {
                let nonce = try nonceOperation
                    .extractResultData(throwing: BaseOperationError.parentOperationCancelled)

                let runtimeVersion = try runtimeVersionOperation
                    .extractResultData(throwing: BaseOperationError.parentOperationCancelled)
                
                let senderAccountId = try Data(hexString: sender)
                let genesisHashData = try Data(hexString: chain.genesisHash)
                print("======>>>>nonce: ",nonce)
                print("======>>>>RuntimeVersion: ",runtimeVersion)
                print("======>>>>genesisHashData: ",chain.genesisHash)

                let additionalParameters = ExtrinsicParameters(nonce: nonce,
                                                               genesisHash: genesisHashData,
                                                               specVersion: runtimeVersion.specVersion,
                                                               transactionVersion: runtimeVersion.transactionVersion,
                                                               signatureVersion: currentCryptoType.version,
                                                               moduleIndex: moduleIndex,
                                                               callIndex: callIndex)

                let extrinsicData = try ExtrinsicFactory
                    .transferExtrinsic(from: senderAccountId,
                                       to: receiverAccountId,
                                       call: call,
                                       additionalParameters: additionalParameters,
                                       signer: signer)
                print("======>>>>extrinsicData: ",extrinsicData.toHex(includePrefix: true))
                targetOperation.parameters = [extrinsicData.toHex(includePrefix: true)]
            } catch {
                targetOperation.result = .failure(error)
            }
        }

        let dependencies: [Operation] = [nonceOperation, runtimeVersionOperation]

        dependencies.forEach { targetOperation.addDependency($0)}

        return CompoundOperationWrapper(targetOperation: targetOperation,
                                        dependencies: dependencies)
    }
    
    func createExtrinsicNonceFetchOperation(_ chain: Chain, accountId: Data? = nil, engine: JSONRPCEngine) -> BaseOperation<UInt32> {
        do {
            let primitiveFactory = WalletPrimitiveFactory(keystore: Keychain(),
                                       settings: SettingsManager.shared)
            let accountSettings = try primitiveFactory.createAccountSettings()
            let identifier = try Data(hexString: accountSettings.accountId)

            let address = try SS58AddressFactory()
                .address(fromPublicKey: AccountIdWrapper(rawData: identifier),
                         type: SNAddressType(chain: chain))

            return JSONRPCListOperation<UInt32>(engine:engine,
                                                method: RPCMethod.getExtrinsicNonce,
                                                parameters: [address])
        } catch {
            return createBaseOperation(result: .failure(error))
        }
    }

    func createRuntimeVersionOperation(engine: JSONRPCEngine) -> BaseOperation<RuntimeVersion> {
        return JSONRPCListOperation(engine: engine, method: RPCMethod.getRuntimeVersion)
    }
    
    func createBaseOperation<T>(result: Result<T, Error>) -> BaseOperation<T> {
        let baseOperation: BaseOperation<T> = BaseOperation()
        baseOperation.result = result
        return baseOperation
    }
}
