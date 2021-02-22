import Foundation
import IrohaCrypto
import SoraFoundation
import SoraKeystore

final class AccountCreateViewFactory: AccountCreateViewFactoryProtocol {
    static func createViewForOnboarding(username: String) -> AccountCreateViewProtocol? {
        let view = AccountCreateViewController(nibName: "AccountCreateViewController", bundle: Bundle.main)
        let presenter = AccountCreatePresenter(username: username)

        let interactor = AccountCreateInteractor(mnemonicCreator: IRMnemonicCreator(),
                                                 supportedNetworkTypes: Chain.allCases,
                                                 defaultNetwork: ConnectionItem.defaultConnection.type.chain)
        let wireframe = AccountCreateWireframe()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        interactor.presenter = presenter

        let localizationManager = LocalizationManager.shared
        view.localizationManager = localizationManager
        presenter.localizationManager = localizationManager

        return view
    }

    static func createViewForAdding(username: String) -> AccountCreateViewProtocol? {
        let view = AccountCreateViewController(nibName: "AccountCreateViewController", bundle: Bundle.main)
        let presenter = AccountCreatePresenter(username: username)

        let defaultAddressType = SettingsManager.shared.selectedConnection.type

        let interactor = AccountCreateInteractor(mnemonicCreator: IRMnemonicCreator(),
                                                 supportedNetworkTypes: Chain.allCases,
                                                 defaultNetwork: defaultAddressType.chain)
        let wireframe = AddCreationWireframe()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        interactor.presenter = presenter

        let localizationManager = LocalizationManager.shared
        view.localizationManager = localizationManager
        presenter.localizationManager = localizationManager

        return view
    }

    static func createViewForConnection(item: ConnectionItem,
                                        username: String) -> AccountCreateViewProtocol? {
        let view = AccountCreateViewController(nibName: "AccountCreateViewController", bundle: Bundle.main)
        let presenter = AccountCreatePresenter(username: username)

        let interactor = AccountCreateInteractor(mnemonicCreator: IRMnemonicCreator(),
                                                 supportedNetworkTypes: [item.type.chain],
                                                 defaultNetwork: item.type.chain)

        let wireframe = ConnectionAccountCreateWireframe(connectionItem: item)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        interactor.presenter = presenter

        let localizationManager = LocalizationManager.shared
        view.localizationManager = localizationManager
        presenter.localizationManager = localizationManager

        return view
    }
}
