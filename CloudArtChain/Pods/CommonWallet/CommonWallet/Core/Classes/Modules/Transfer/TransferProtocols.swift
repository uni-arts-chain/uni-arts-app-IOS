/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import FearlessUtils

protocol TransferViewProtocol: OperationDefinitionViewProtocol, ControllerBackedProtocol,
LoadableViewProtocol, AlertPresentable {}

protocol TransferCoordinatorProtocol: CoordinatorProtocol, PickerPresentable {
    func confirm(with payload: ConfirmationPayload)
    func jlConfirm(with payload: ConfirmationPayload, call: ScaleCodable?, moduleIndex: UInt8, callIndex: UInt8) -> WalletNewFormViewController?
}

protocol TransferAssemblyProtocol: class {
    static func assembleView(with resolver: ResolverProtocol,
                             payload: TransferPayload) -> TransferViewProtocol?
    
    static func assembleView(with resolver: ResolverProtocol,
                             payload: TransferPayload,
                             call: ScaleCodable,
                             moduleIndex: UInt8,
                             callIndex: UInt8) -> TransferViewProtocol?
    
    static func assembleViewToGetSignMessage(with resolver: ResolverProtocol,
                             payload: TransferPayload,
                             call: ScaleCodable,
                             moduleIndex: UInt8,
                             callIndex: UInt8,
                             signMessageBlock: @escaping (String?) -> Void) -> TransferViewProtocol?
}
