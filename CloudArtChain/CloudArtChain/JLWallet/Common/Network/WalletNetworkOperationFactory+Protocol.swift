import Foundation
import CommonWallet
import RobinHood
import xxHash_Swift
import FearlessUtils
import IrohaCrypto
import Starscream
import BigInt

enum WalletNetworkOperationFactoryError: Error {
    case invalidAmount
    case invalidAsset
    case invalidChain
    case invalidReceiver
}

extension WalletNetworkOperationFactory: WalletNetworkOperationFactoryProtocol {
    func fetchBalanceOperation(_ assets: [String]) -> CompoundOperationWrapper<[BalanceData]?> {
        return CompoundOperationWrapper<[BalanceData]?>.createWithResult(nil)
    }

    func fetchTransactionHistoryOperation(_ filter: WalletHistoryRequest,
                                          pagination: Pagination)
        -> CompoundOperationWrapper<AssetTransactionPageData?> {
            let operation = ClosureOperation<AssetTransactionPageData?> {
                nil
            }

            return CompoundOperationWrapper(targetOperation: operation)
    }

    func transferMetadataOperation(_ info: TransferMetadataInfo) -> CompoundOperationWrapper<TransferMetaData?> {
        guard
            let asset = accountSettings.assets.first(where: { $0.identifier == info.assetId }),
            let assetId = WalletAssetId(rawValue: asset.identifier) else {
            let error = WalletNetworkOperationFactoryError.invalidAsset
            return createCompoundOperation(result: .failure(error))
        }

        guard let chain = assetId.chain else {
            let error = WalletNetworkOperationFactoryError.invalidChain
            return createCompoundOperation(result: .failure(error))
        }

        guard let amount = Decimal(1.0).toSubstrateAmount(precision: asset.precision) else {
            let error = WalletNetworkOperationFactoryError.invalidAmount
            return createCompoundOperation(result: .failure(error))
        }

        guard let receiver = try? Data(hexString: info.receiver),
              let accountKey = try? StorageKeyFactory().accountInfoKeyForId(receiver)
                .toHex(includePrefix: true) else {
            let error = WalletNetworkOperationFactoryError.invalidReceiver
            return createCompoundOperation(result: .failure(error))
        }

        let receiverOperation = JSONRPCListOperation<JSONScaleDecodable<AccountInfo>>(engine: engine,
                                                                  method: RPCMethod.getStorage,
                                                                  parameters: [accountKey])

        let infoOperation = JSONRPCListOperation<RuntimeDispatchInfo>(engine: engine,
                                                                      method: RPCMethod.paymentInfo)

        let compoundInfo = setupTransferExtrinsic(infoOperation,
                                                  amount: amount,
                                                  receiver: info.receiver,
                                                  chain: chain,
                                                  signer: dummySigner)

        let mapOperation: ClosureOperation<TransferMetaData?> = ClosureOperation {
            let paymentInfo = try infoOperation
                .extractResultData(throwing: BaseOperationError.parentOperationCancelled)

            guard let fee = BigUInt(paymentInfo.fee),
                let decimalFee = Decimal.fromSubstrateAmount(fee, precision: asset.precision) else {
                return nil
            }

            let amount = AmountDecimal(value: decimalFee)

            let feeDescription = FeeDescription(identifier: asset.identifier,
                                                assetId: asset.identifier,
                                                type: FeeType.fixed.rawValue,
                                                parameters: [amount])

            if let receiverInfo = try receiverOperation
                    .extractResultData(throwing: BaseOperationError.parentOperationCancelled)
                    .underlyingValue {
                let context = TransferMetadataContext(data: receiverInfo.data,
                                                      precision: asset.precision)
                    .toContext()
                return TransferMetaData(feeDescriptions: [feeDescription],
                                        context: context)
            } else {
                return TransferMetaData(feeDescriptions: [feeDescription])
            }
        }

        mapOperation.addDependency(compoundInfo.targetOperation)
        mapOperation.addDependency(receiverOperation)

        let dependencies = compoundInfo.allOperations + [receiverOperation]

        return CompoundOperationWrapper(targetOperation: mapOperation,
                                        dependencies: dependencies)
    }
    
    func transferMetadataOperation(_ info: TransferMetadataInfo, _ call: ScaleCodable?, _ moduleIndex: UInt8, _ callIndex: UInt8) -> CompoundOperationWrapper<TransferMetaData?> {
        guard
            let asset = accountSettings.assets.first(where: { $0.identifier == info.assetId }),
            let assetId = WalletAssetId(rawValue: asset.identifier) else {
            let error = WalletNetworkOperationFactoryError.invalidAsset
            return createCompoundOperation(result: .failure(error))
        }

        guard let chain = assetId.chain else {
            let error = WalletNetworkOperationFactoryError.invalidChain
            return createCompoundOperation(result: .failure(error))
        }

        guard let receiver = try? Data(hexString: info.receiver),
              let accountKey = try? StorageKeyFactory().accountInfoKeyForId(receiver)
                .toHex(includePrefix: true) else {
            let error = WalletNetworkOperationFactoryError.invalidReceiver
            return createCompoundOperation(result: .failure(error))
        }

        let receiverOperation = JSONRPCListOperation<JSONScaleDecodable<AccountInfo>>(engine: engine,
                                                                  method: RPCMethod.getStorage,
                                                                  parameters: [accountKey])

        let infoOperation = JSONRPCListOperation<RuntimeDispatchInfo>(engine: engine,
                                                                      method: RPCMethod.paymentInfo)

        let compoundInfo = setupTransferExtrinsic(infoOperation,
                                                  call: call,
                                                  moduleIndex: moduleIndex,
                                                  callIndex: callIndex,
                                                  receiver: info.receiver,
                                                  chain: chain, signer: dummySigner)

        let mapOperation: ClosureOperation<TransferMetaData?> = ClosureOperation {
            let paymentInfo = try infoOperation
                .extractResultData(throwing: BaseOperationError.parentOperationCancelled)

            guard let fee = BigUInt(paymentInfo.fee),
                let decimalFee = Decimal.fromSubstrateAmount(fee, precision: asset.precision) else {
                return nil
            }

            let amount = AmountDecimal(value: decimalFee)

            let feeDescription = FeeDescription(identifier: asset.identifier,
                                                assetId: asset.identifier,
                                                type: FeeType.fixed.rawValue,
                                                parameters: [amount])

            if let receiverInfo = try receiverOperation
                    .extractResultData(throwing: BaseOperationError.parentOperationCancelled)
                    .underlyingValue {
                let context = TransferMetadataContext(data: receiverInfo.data,
                                                      precision: asset.precision)
                    .toContext()
                return TransferMetaData(feeDescriptions: [feeDescription],
                                        context: context)
            } else {
                return TransferMetaData(feeDescriptions: [feeDescription])
            }
        }

        mapOperation.addDependency(compoundInfo.targetOperation)
        mapOperation.addDependency(receiverOperation)

        let dependencies = compoundInfo.allOperations + [receiverOperation]

        return CompoundOperationWrapper(targetOperation: mapOperation,
                                        dependencies: dependencies)
    }

    func transferOperation(_ info: TransferInfo) -> CompoundOperationWrapper<Data> {
        guard
            let asset = accountSettings.assets.first(where: { $0.identifier == info.asset }),
            let assetId = WalletAssetId(rawValue: asset.identifier) else {
            let error = WalletNetworkOperationFactoryError.invalidAsset
            return createCompoundOperation(result: .failure(error))
        }

        guard let amount = info.amount.decimalValue.toSubstrateAmount(precision: asset.precision) else {
            let error = WalletNetworkOperationFactoryError.invalidAmount
            return createCompoundOperation(result: .failure(error))
        }

        guard let chain = assetId.chain else {
            let error = WalletNetworkOperationFactoryError.invalidChain
            return createCompoundOperation(result: .failure(error))
        }

        let transferOperation = JSONRPCListOperation<String>(engine: engine,
                                                             method: RPCMethod.submitExtrinsic)

        let compoundTransfer = setupTransferExtrinsic(transferOperation,
                                                      amount: amount,
                                                      receiver: info.destination,
                                                      chain: chain,
                                                      signer: accountSigner)

        let mapOperation: ClosureOperation<Data> = ClosureOperation {
            let hashString = try transferOperation
                .extractResultData(throwing: BaseOperationError.parentOperationCancelled)

            return try Data(hexString: hashString)
        }

        mapOperation.addDependency(compoundTransfer.targetOperation)

        return CompoundOperationWrapper(targetOperation: mapOperation,
                                        dependencies: compoundTransfer.allOperations)
    }
    
    func transferOperation(_ info: TransferInfo, _ call: ScaleCodable?, _ moduleIndex: UInt8, _ callIndex: UInt8) -> CompoundOperationWrapper<Data> {
        guard
            let asset = accountSettings.assets.first(where: { $0.identifier == info.asset }),
            let assetId = WalletAssetId(rawValue: asset.identifier) else {
            let error = WalletNetworkOperationFactoryError.invalidAsset
            return createCompoundOperation(result: .failure(error))
        }

        guard let amount = info.amount.decimalValue.toSubstrateAmount(precision: asset.precision) else {
            let error = WalletNetworkOperationFactoryError.invalidAmount
            return createCompoundOperation(result: .failure(error))
        }

        guard let chain = assetId.chain else {
            let error = WalletNetworkOperationFactoryError.invalidChain
            return createCompoundOperation(result: .failure(error))
        }

        let transferOperation = JSONRPCListOperation<String>(engine: engine,
                                                             method: RPCMethod.submitExtrinsic)

        let compoundTransfer = setupTransferExtrinsic(transferOperation,
                                                      call: call,
                                                      moduleIndex: moduleIndex,
                                                      callIndex: callIndex,
                                                      receiver: info.destination,
                                                      chain: chain,
                                                      signer: accountSigner)

        let mapOperation: ClosureOperation<Data> = ClosureOperation {
            let hashString = try transferOperation
                .extractResultData(throwing: BaseOperationError.parentOperationCancelled)

            return try Data(hexString: hashString)
        }

        mapOperation.addDependency(compoundTransfer.targetOperation)

        return CompoundOperationWrapper(targetOperation: mapOperation,
                                        dependencies: compoundTransfer.allOperations)
    }

    func searchOperation(_ searchString: String) -> CompoundOperationWrapper<[SearchData]?> {
        return CompoundOperationWrapper<[SearchData]?>.createWithResult(nil)
    }

    func contactsOperation() -> CompoundOperationWrapper<[SearchData]?> {
        return CompoundOperationWrapper<[SearchData]?>.createWithResult(nil)
    }

    func withdrawalMetadataOperation(_ info: WithdrawMetadataInfo)
        -> CompoundOperationWrapper<WithdrawMetaData?> {
        return CompoundOperationWrapper<WithdrawMetaData?>.createWithResult(nil)
    }

    func withdrawOperation(_ info: WithdrawInfo) -> CompoundOperationWrapper<Data> {
        return CompoundOperationWrapper<Data>.createWithResult(Data())
    }
}
