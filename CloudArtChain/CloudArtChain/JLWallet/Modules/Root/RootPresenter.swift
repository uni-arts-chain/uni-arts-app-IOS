import UIKit
import CommonWallet

final class RootPresenter {
    var view: UIWindow!
    var wireframe: RootWireframeProtocol!
    var interactor: RootInteractorInputProtocol!
}

extension RootPresenter: RootPresenterProtocol {
    func loadOnLaunch(navigationController: UINavigationController) {
        interactor.setup()
        interactor.decideModuleSynchroniously(navigationController: navigationController)
    }
    
    func getAccountBalance(balanceBlock: @escaping ([WalletViewModelProtocol]) -> Void) {
        interactor.setup()
        interactor.getAccountBalance(balanceBlock: balanceBlock)
    }
}

extension RootPresenter: RootInteractorOutputProtocol {
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
    
    func didDecideWallet(navigationController: UINavigationController) {
        wireframe.showWallet(on: view, navigationController: navigationController)
    }
    
    func didDecideGetAccountBalance(balanceBlock: @escaping ([WalletViewModelProtocol]) -> Void) {
        wireframe.showAccountBalance(balanceBlock: balanceBlock)
    }
}
