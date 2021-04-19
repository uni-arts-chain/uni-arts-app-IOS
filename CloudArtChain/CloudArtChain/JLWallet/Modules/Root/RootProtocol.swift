import UIKit
import CommonWallet

protocol RootPresenterProtocol: class {
    func loadOnLaunch(navigationController: UINavigationController, userAvatar: String?)
    func defaultCreateWallet(navigationController: UINavigationController, userAvatar: String?)
    func getAccountBalance(balanceBlock: @escaping ([WalletViewModelProtocol]) -> Void)
    func hasSelectedAccount() -> Bool
    func pincodeExists() -> Bool
}

protocol RootWireframeProtocol: class {
    func showLocalAuthentication(on view: UIWindow)
    func showOnboarding(on view: UIWindow)
    func showOnboardingDefaultCreateWallet(on view: UIWindow)
    func showPincodeSetup(on view: UIWindow)
    func showBroken(on view: UIWindow)
    func showWallet(on view: UIWindow, navigationController: UINavigationController, userAvatar: String?)
    func showAccountBalance(balanceBlock: @escaping ([WalletViewModelProtocol]) -> Void)
}

protocol RootInteractorInputProtocol: class {
    func setup()
    func decideModuleSynchroniously(navigationController: UINavigationController, userAvatar: String?)
    func getAccountBalance(balanceBlock: @escaping ([WalletViewModelProtocol]) -> Void)
    func hasSelectedAccount() -> Bool
    func pincodeExists() -> Bool
    func decideCreateWalletModuleSynchroniously(navigationController: UINavigationController, userAvatar: String?)
}

protocol RootInteractorOutputProtocol: class {
    func didDecideOnboardingDefaultCreateWallet()
    func didDecideOnboarding()
    func didDecideLocalAuthentication()
    func didDecidePincodeSetup()
    func didDecideBroken()
    func didDecideWallet(navigationController: UINavigationController, userAvatar: String?)
    func didDecideGetAccountBalance(balanceBlock: @escaping ([WalletViewModelProtocol]) -> Void)
}

protocol RootPresenterFactoryProtocol: class {
    static func createPresenter(with view: UIWindow) -> RootPresenterProtocol
}
