import UIKit
import CommonWallet

final class RootPresenter {
    var view: UIWindow!
    var wireframe: RootWireframeProtocol!
    var interactor: RootInteractorInputProtocol!
}

extension RootPresenter: RootPresenterProtocol {
    func defaultCreateWallet(navigationController: UINavigationController, userAvatar: String?) {
        interactor.setup()
        interactor.decideCreateWalletModuleSynchroniously(navigationController: navigationController, userAvatar: userAvatar)
    }
    
    func loadOnLaunch(navigationController: UINavigationController, userAvatar: String?) {
        interactor.setup()
        interactor.decideModuleSynchroniously(navigationController: navigationController, userAvatar: userAvatar)
    }
    
    func getAccountBalance(balanceBlock: @escaping ([WalletViewModelProtocol]) -> Void) {
        interactor.setup()
        interactor.getAccountBalance(balanceBlock: balanceBlock)
    }
    
    func hasSelectedAccount() -> Bool {
        return interactor.hasSelectedAccount()
    }
    
    func pincodeExists() -> Bool {
        return interactor.pincodeExists()
    }
}

extension RootPresenter: RootInteractorOutputProtocol {
    func didDecideOnboardingDefaultCreateWallet() {
        wireframe.showOnboardingDefaultCreateWallet(on: view)
    }
    
    func didDecideOnboarding() {
        wireframe.showOnboarding(on: view)
    }

    func didDecideLocalAuthentication() {
        wireframe.showLocalAuthentication(on: view)
    }

    func didDecidePincodeSetup() {
        wireframe.showPincodeSetup(on: view)
    }

    func didDecideBroken() {
        wireframe.showBroken(on: view)
    }
    
    func didDecideWallet(navigationController: UINavigationController, userAvatar: String?) {
        wireframe.showWallet(on: view, navigationController: navigationController, userAvatar: userAvatar)
    }
    
    func didDecideGetAccountBalance(balanceBlock: @escaping ([WalletViewModelProtocol]) -> Void) {
        wireframe.showAccountBalance(balanceBlock: balanceBlock)
    }
}
