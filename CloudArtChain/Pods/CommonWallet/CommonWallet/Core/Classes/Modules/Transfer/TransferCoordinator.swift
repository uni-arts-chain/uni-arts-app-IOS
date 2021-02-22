/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import FearlessUtils

final class TransferCoordinator: TransferCoordinatorProtocol {
    
    let resolver: ResolverProtocol
    
    init(resolver: ResolverProtocol) {
        self.resolver = resolver
    }
    
    func confirm(with payload: ConfirmationPayload) {
        let command = TransferConfirmationCommand(payload: payload,
                                                  resolver: resolver,
                                                  call: nil)

        if let decorator = resolver.commandDecoratorFactory?
            .createTransferConfirmationDecorator(with: resolver.commandFactory, payload: payload) {
            decorator.undelyingCommand = command

            try? decorator.execute()
        } else {
            try? command.execute()
        }
    }
    
    func jlConfirm(with payload: ConfirmationPayload, call: ScaleCodable?) -> WalletNewFormViewController? {
        let command = TransferConfirmationCommand(payload: payload,
                                                  resolver: resolver,
                                                  call: call)
        
        return command.confirmTransaction()

//        if let decorator = resolver.commandDecoratorFactory?
//            .createTransferConfirmationDecorator(with: resolver.commandFactory, payload: payload) {
//            decorator.undelyingCommand = command
//            if let navi = navigationController {
//                decorator.confirmTransaction(navigationController: navi)
//            }
//        } else {
//            try? command.execute()
//        }
    }
}
