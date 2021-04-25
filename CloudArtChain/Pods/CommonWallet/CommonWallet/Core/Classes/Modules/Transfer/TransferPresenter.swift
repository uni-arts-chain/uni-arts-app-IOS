/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import RobinHood
import SoraFoundation
import FearlessUtils

struct TransferCheckingState: OptionSet {
    typealias RawValue = UInt8

    static let waiting: TransferCheckingState = []
    static let requestedAmount = TransferCheckingState(rawValue: 1)
    static let requestedFee = TransferCheckingState(rawValue: 2)
    static let completed = TransferCheckingState.requestedAmount.union(.requestedFee)

    var rawValue: TransferCheckingState.RawValue

    init(rawValue: TransferCheckingState.RawValue) {
        self.rawValue = rawValue
    }
}

final class TransferPresenter {

    weak var view: TransferViewProtocol?
    var coordinator: TransferCoordinatorProtocol
    var logger: WalletLoggerProtocol?
    
    var amountInputViewModel: AmountInputViewModelProtocol
    var descriptionInputViewModel: DescriptionInputViewModelProtocol?
    var metadataProvider: SingleValueProvider<TransferMetaData>
    var balances: [BalanceData]?
    var metadata: TransferMetaData?
    var selectedAsset: WalletAsset
    var confirmationState: TransferCheckingState?

    let feeCalculationFactory: FeeCalculationFactoryProtocol
    let viewModelFactory: TransferViewModelFactoryProtocol
    let headerFactory: OperationDefinitionHeaderModelFactoryProtocol
    let resultValidator: TransferValidating
    let changeHandler: OperationDefinitionChangeHandling
    let errorHandler: OperationDefinitionErrorHandling?
    let feeEditing: FeeEditing?

    let dataProviderFactory: DataProviderFactoryProtocol
    let balanceDataProvider: SingleValueProvider<[BalanceData]>

    let assets: [WalletAsset]
    let accountId: String
    let payload: TransferPayload
    let call: ScaleCodable?
    let callIndex: UInt8
    let moduleIndex: UInt8
    let receiverPosition: TransferReceiverPosition
    let signMessageBlock: ((String?) -> Void)?

    var selectedBalance: BalanceData? {
        balances?.first { $0.identifier == selectedAsset.identifier }
    }

    var inputState: TransferInputState {
        TransferInputState(selectedAsset: selectedAsset,
                           balance: selectedBalance,
                           amount: amountInputViewModel.decimalAmount,
                           metadata: metadata)
    }
    var callbackBlock: ((WalletNewFormViewController?) -> Void)?

    init(view: TransferViewProtocol,
         coordinator: TransferCoordinatorProtocol,
         assets: [WalletAsset],
         accountId: String,
         payload: TransferPayload,
         dataProviderFactory: DataProviderFactoryProtocol,
         feeCalculationFactory: FeeCalculationFactoryProtocol,
         resultValidator: TransferValidating,
         changeHandler: OperationDefinitionChangeHandling,
         viewModelFactory: TransferViewModelFactoryProtocol,
         headerFactory: OperationDefinitionHeaderModelFactoryProtocol,
         receiverPosition: TransferReceiverPosition,
         localizationManager: LocalizationManagerProtocol?,
         errorHandler: OperationDefinitionErrorHandling?,
         feeEditing: FeeEditing?,
         call: ScaleCodable?,
         moduleIndex: UInt8,
         callIndex: UInt8,
         signMessageBlock: ((String?) -> Void)?) throws {

        if let assetId = payload.receiveInfo.assetId,
            let asset = assets.first(where: { $0.identifier == assetId }) {
            selectedAsset = asset
        } else {
            selectedAsset = assets[0]
        }

        self.view = view
        self.coordinator = coordinator
        self.assets = assets
        self.accountId = accountId
        self.payload = payload
        self.call = call
        self.moduleIndex = moduleIndex
        self.callIndex = callIndex
        self.receiverPosition = receiverPosition
        self.signMessageBlock = signMessageBlock

        self.dataProviderFactory = dataProviderFactory
        self.balanceDataProvider = try dataProviderFactory.createBalanceDataProvider()
        if let tempBlock = signMessageBlock {
            self.metadataProvider = try dataProviderFactory.createSignMessageMetadataProvider(for: selectedAsset.identifier, receiver: payload.receiveInfo.accountId, call: call, moduleIndex: moduleIndex, callIndex: callIndex, signMessageBlock: tempBlock)
        } else {
            self.metadataProvider = try dataProviderFactory
                .createTransferMetadataProvider(for: selectedAsset.identifier,
                                                receiver: payload.receiveInfo.accountId,
                                                call: call,
                                                moduleIndex: moduleIndex,
                                                callIndex: callIndex)
        }
        self.resultValidator = resultValidator
        self.feeCalculationFactory = feeCalculationFactory
        self.viewModelFactory = viewModelFactory
        self.headerFactory = headerFactory
        self.errorHandler = errorHandler
        self.changeHandler = changeHandler
        self.feeEditing = feeEditing

        let locale = localizationManager?.selectedLocale ?? Locale.current

        let state = TransferInputState(selectedAsset: selectedAsset,
                                       balance: nil,
                                       amount: payload.receiveInfo.amount?.decimalValue,
                                       metadata: nil)

        descriptionInputViewModel = try viewModelFactory
            .createDescriptionViewModel(state,
                                        details: payload.receiveInfo.details,
                                        payload: payload,
                                        locale: locale)

        amountInputViewModel = try viewModelFactory.createAmountViewModel(state,
                                                                          payload: payload,
                                                                          locale: locale)

        self.localizationManager = localizationManager
    }
}
