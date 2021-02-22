import Foundation
import CommonWallet
import SoraFoundation

final class TransferConfirmCommand: WalletCommandDecoratorProtocol {
    var undelyingCommand: WalletCommandProtocol?

    let payload: ConfirmationPayload

    let localizationManager: LocalizationManagerProtocol

    weak var commandFactory: WalletCommandFactoryProtocol?

    init(payload: ConfirmationPayload,
         localizationManager: LocalizationManagerProtocol,
         commandFactory: WalletCommandFactoryProtocol) {
        self.commandFactory = commandFactory
        self.localizationManager = localizationManager
        self.payload = payload
    }

    func execute() throws {
        guard let context = payload.transferInfo.context,
            let chain = WalletAssetId(rawValue: payload.transferInfo.asset)?.chain else {
            try undelyingCommand?.execute()
            return
        }

        let balanceContext = BalanceContext(context: context)

        let transferAmount = payload.transferInfo.amount.decimalValue
        let totalFee = payload.transferInfo.fees.reduce(Decimal(0.0)) { $0 + $1.value.decimalValue }
        let totalAfterTransfer = balanceContext.total - (transferAmount + totalFee)

        guard totalAfterTransfer < chain.existentialDeposit else {
            try undelyingCommand?.execute()
            return
        }
        
        let title = "Warning"
        let message = "Your transfer will remove account from blockstore since it will make total balance lower than existential deposit"

        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)

        let continueTitle = "Continue"

        let continueAction = UIAlertAction(title: continueTitle, style: .default) { _ in
            try? self.undelyingCommand?.execute()
        }

        alertController.addAction(continueAction)

        let cancelTitle = "Cancel"
        let closeAction = UIAlertAction(title: cancelTitle,
                                        style: .cancel,
                                        handler: nil)
        alertController.addAction(closeAction)

        let presentationCommand = commandFactory?.preparePresentationCommand(for: alertController)
        presentationCommand?.presentationStyle = .modal(inNavigation: false)

        try? presentationCommand?.execute()
    }
    
    func getModelsExecute(contactBlock: (ContactListViewModelProtocol, WalletAsset, ContactsPresenter) -> Void) throws {
        
    }
    
    func confirmTransaction() -> WalletNewFormViewController? {
        return nil
    }
}
