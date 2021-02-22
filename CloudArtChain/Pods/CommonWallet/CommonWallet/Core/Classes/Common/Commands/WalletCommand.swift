/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: GPL-3.0
 */

import Foundation

public protocol WalletCommandProtocol: class {
    func execute() throws
    func getModelsExecute(contactBlock: @escaping (ContactListViewModelProtocol, WalletAsset, ContactsPresenter) -> Void) throws
    func confirmTransaction() -> WalletNewFormViewController?
}
