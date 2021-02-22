/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation

final class LanguageSwitchCommand: WalletCommandProtocol {
    let resolver: ResolverProtocol
    let language: WalletLanguage

    init(resolver: ResolverProtocol, language: WalletLanguage) {
        self.resolver = resolver
        self.language = language
    }

    func execute() throws {
        L10n.sharedLanguage = language
        resolver.localizationManager?.selectedLocalization = language.rawValue
    }
    
    func getModelsExecute(contactBlock: (ContactListViewModelProtocol, WalletAsset, ContactsPresenter) -> Void) throws {
        
    }
    
    func confirmTransaction() -> WalletNewFormViewController? {
        return nil
    }
}
