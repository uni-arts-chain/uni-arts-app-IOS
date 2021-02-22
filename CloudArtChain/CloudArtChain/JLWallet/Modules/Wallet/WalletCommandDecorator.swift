import Foundation
import CommonWallet
import SoraFoundation

final class StubCommandDecorator: WalletCommandDecoratorProtocol {
    var undelyingCommand: WalletCommandProtocol?

    func execute() throws {}
    
    func getModelsExecute(contactBlock: (ContactListViewModelProtocol, WalletAsset, ContactsPresenter) -> Void) throws {
        
    }
    
    func confirmTransaction() -> WalletNewFormViewController? {
        return nil
    }
}

final class WalletCommandDecoratorFactory: WalletCommandDecoratorFactoryProtocol {
    let localizationManager: LocalizationManagerProtocol

    init(localizationManager: LocalizationManagerProtocol) {
        self.localizationManager = localizationManager
    }

    func createTransferConfirmationDecorator(with commandFactory: WalletCommandFactoryProtocol,
                                             payload: ConfirmationPayload)
        -> WalletCommandDecoratorProtocol? {
        TransferConfirmCommand(payload: payload,
                               localizationManager: localizationManager,
                               commandFactory: commandFactory)
    }
}
