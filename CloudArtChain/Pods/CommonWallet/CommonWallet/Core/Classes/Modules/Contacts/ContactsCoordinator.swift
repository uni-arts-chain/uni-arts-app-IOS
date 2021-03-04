/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import FearlessUtils

final class ContactsCoordinator: ContactsCoordinatorProtocol {
    
    private let resolver: ResolverProtocol
    
    init(resolver: ResolverProtocol) {
        self.resolver = resolver
    }
    
    func send(to payload: TransferPayload) {
        guard let amountView = TransferAssembly.assembleView(with: resolver,
                                                             payload: payload) else {
            return
        }
        
        resolver.navigation?.push(amountView.controller)
    }
    
    func send(to payload: TransferPayload, call: ScaleCodable, callIndex: UInt8) -> TransferViewController? {
        guard let amountView = TransferAssembly.assembleView(with: resolver,
                                                             payload: payload,
                                                             call: call,
                                                             callIndex: callIndex) else {
            return nil
        }
        (amountView as! TransferViewController).loadView()
        (amountView as! TransferViewController).presenter.setup()
        return (amountView as! TransferViewController)
    }

    func scanInvoice() {
        guard let scanView = InvoiceScanAssembly.assembleView(with: resolver) else {
            return
        }

        resolver.navigation?.push(scanView.controller)
    }
}
