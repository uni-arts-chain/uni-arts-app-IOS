import UIKit
import CommonWallet

protocol RootPresenterProtocol: class {
    func loadOnLaunch(navigationController: UINavigationController)
    func getAccountBalance(balanceBlock: @escaping ([WalletViewModelProtocol]) -> Void)
    func hasSelectedAccount() -> Bool
}

protocol RootWireframeProtocol: class {
    func showLocalAuthentication(on view: UIWindow)
    func showOnboarding(on view: UIWindow)
    func showPincodeSetup(on view: UIWindow)
    func showBroken(on view: UIWindow)
    func showWallet(on view: UIWindow, navigationController: UINavigationController)
    func showAccountBalance(balanceBlock: @escaping ([WalletViewModelProtocol]) -> Void)
}

protocol RootInteractorInputProtocol: class {
    func setup()
    func decideModuleSynchroniously(navigationController: UINavigationController)
    func getAccountBalance(balanceBlock: @escaping ([WalletViewModelProtocol]) -> Void)
    func hasSelectedAccount() -> Bool
}

protocol RootInteractorOutputProtocol: class {
    func didDecideOnboarding()
    func didDecideLocalAuthentication()
    func didDecidePincodeSetup()
    func didDecideBroken()
    func didDecideWallet(navigationController: UINavigationController)
    func didDecideGetAccountBalance(balanceBlock: @escaping ([WalletViewModelProtocol]) -> Void)
}

protocol RootPresenterFactoryProtocol: class {
    static func createPresenter(with view: UIWindow) -> RootPresenterProtocol
}
