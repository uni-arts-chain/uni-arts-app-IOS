import Foundation
import SoraKeystore
import IrohaCrypto
import RobinHood
import CommonWallet

final class RootInteractor {
    weak var presenter: RootInteractorOutputProtocol?

    let settings: SettingsManagerProtocol
    let keystore: KeystoreProtocol
    let applicationConfig: ApplicationConfigProtocol
    let eventCenter: EventCenterProtocol

    init(settings: SettingsManagerProtocol,
         keystore: KeystoreProtocol,
         applicationConfig: ApplicationConfigProtocol,
         eventCenter: EventCenterProtocol) {
        self.settings = settings
        self.keystore = keystore
        self.applicationConfig = applicationConfig
        self.eventCenter = eventCenter
    }

    private func setupURLHandlingService() {
        let keystoreImportService = KeystoreImportService(logger: Logger.shared)

        let callbackUrl = applicationConfig.purchaseRedirect
        let purchaseHandler = PurchaseCompletionHandler(callbackUrl: callbackUrl,
                                                        eventCenter: eventCenter)

        URLHandlingService.shared.setup(children: [purchaseHandler, keystoreImportService])
    }
}

extension RootInteractor: RootInteractorInputProtocol {
    func decideModuleSynchroniously(navigationController: UINavigationController) {
        do {
            if !settings.hasSelectedAccount {
                try keystore.deleteKeyIfExists(for: KeystoreTag.pincode.rawValue)

                presenter?.didDecideOnboarding()
                return
            }

            let pincodeExists = try keystore.checkKey(for: KeystoreTag.pincode.rawValue)

            if pincodeExists {
//                presenter?.didDecideLocalAuthentication()
                presenter?.didDecideWallet(navigationController: navigationController)
            } else {
                presenter?.didDecidePincodeSetup()
            }
        } catch {
            presenter?.didDecideBroken()
        }
    }
    
    func getAccountBalance(balanceBlock: @escaping ([WalletViewModelProtocol]) -> Void) {
        if !settings.hasSelectedAccount {
            return
        }
        presenter?.didDecideGetAccountBalance(balanceBlock: balanceBlock)
    }

    func setup() {
        setupURLHandlingService()
    }
}
