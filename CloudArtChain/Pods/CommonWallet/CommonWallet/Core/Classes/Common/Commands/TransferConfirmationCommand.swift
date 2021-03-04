/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import FearlessUtils

final class TransferConfirmationCommand: WalletPresentationCommandProtocol {
    let payload: ConfirmationPayload
    let resolver: ResolverProtocol
    var call: ScaleCodable?
    var callIndex: UInt8

    var presentationStyle: WalletPresentationStyle = .push(hidesBottomBar: true)
    var animated: Bool = true

    init(payload: ConfirmationPayload, resolver: ResolverProtocol, call: ScaleCodable?, callIndex: UInt8) {
        self.payload = payload
        self.resolver = resolver
        self.call = call
        self.callIndex = callIndex
    }

    func execute() throws {
        guard let confirmationView = TransferConfirmationAssembly.assembleView(with: resolver,
                                                                               payload: payload),
            let navigation = resolver.navigation else {
            return
        }

        present(view: confirmationView.controller, in: navigation, animated: animated)
    }
    
    func getModelsExecute(contactBlock: (ContactListViewModelProtocol, WalletAsset, ContactsPresenter) -> Void) throws {
        
    }
    
    func confirmTransaction() -> WalletNewFormViewController? {
        guard let confirmationView = TransferConfirmationAssembly.assembleView(with: resolver,
                                                                               payload: payload,
                                                                               call: call,
                                                                               callIndex: callIndex) else {
            return nil
        }

        (confirmationView as! WalletNewFormViewController).loadView()
        (confirmationView as! WalletNewFormViewController).presenter.setup()
        return (confirmationView as! WalletNewFormViewController)
    }
}
