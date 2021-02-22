import Foundation
import IrohaCrypto
import SoraFoundation

final class ExportMnemonicConfirmViewFactory: ExportMnemonicConfirmViewFactoryProtocol {
    static func createViewForMnemonic(_ mnemonic: IRMnemonicProtocol) -> AccountConfirmViewProtocol? {
        let view = AccountConfirmViewController(nibName: "AccountConfirmViewController", bundle: Bundle.main)
        view.nextButtonTitle = LocalizableResource { locale in
            "Confirm"
        }

        let localizationManager = LocalizationManager.shared

        let presenter = AccountConfirmPresenter()

        let interactor = ExportMnemonicConfirmInteractor(mnemonic: mnemonic)
        let wireframe = ExportMnemonicConfirmWireframe(localizationManager: localizationManager)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        interactor.presenter = presenter

        view.localizationManager = localizationManager
        presenter.localizationManager = localizationManager

        return view
    }

}
