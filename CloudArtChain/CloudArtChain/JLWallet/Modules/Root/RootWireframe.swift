import UIKit
import SoraFoundation
import SoraKeystore
import CommonWallet

final class RootWireframe: RootWireframeProtocol, JLAccountListViewControllerProtocol {
    var navigationController: UINavigationController?
    var interactor: MainTabBarInteractor?
    
    func pointDesc() {
        
    }
    
    func accountInfo() {
        let editWalletVC = JLEditWalletViewController();
        self.navigationController?.pushViewController(editWalletVC, animated: true)
    }
    
    func pointDetail() {
        let integralListVC = JLIntegralListViewController();
        self.navigationController?.pushViewController(integralListVC, animated: true)
    }
    
    func backClick(viewController: UIViewController) {
        self.interactor = nil
        viewController.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    lazy var rootAnimator: RootControllerAnimationCoordinatorProtocol = RootControllerAnimationCoordinator()
    
    func showOnboarding(on view: UIWindow) {
        let onboardingView = OnboardingMainViewFactory.createViewForOnboarding()
        let onboardingController = onboardingView?.controller ?? OnboardingMainViewController()
        (onboardingController as! OnboardingMainViewController).presenter.setup()
        
        let walletBoardVC = JLWalletBoardViewController()

//        let navigationController = FearlessNavigationController()
        let navigationController = JLNavigationViewController()
        navigationController.viewControllers = [walletBoardVC]
        navigationController.modalPresentationStyle = .fullScreen

        view.rootViewController?.present(navigationController, animated: true, completion: nil)
    }

    func showLocalAuthentication(on view: UIWindow) {
        let pincodeView = PinViewFactory.createSecuredPinView()
        let pincodeController = pincodeView?.controller ?? UIViewController()

        view.rootViewController = pincodeController
    }

    func showPincodeSetup(on view: UIWindow) {
        guard let controller = PinViewFactory.createPinSetupView(navigationController: nil)?.controller else {
            return
        }

        view.rootViewController = controller
    }

    func showBroken(on view: UIWindow) {
        // normally user must not see this but on malicious devices it is possible
        view.backgroundColor = .red
    }
    
    func showWallet(on view: UIWindow, navigationController: UINavigationController) {
        guard let keystoreImportService: KeystoreImportServiceProtocol = URLHandlingService.shared
                .findService() else {
            Logger.shared.error("Can't find required keystore import service")
            return
        }
        let localizationManager = LocalizationManager.shared
        let webSocketService = WebSocketService.shared
        webSocketService.networkStatusPresenter = MainTabBarViewFactory.createNetworkStatusPresenter(localizationManager: localizationManager)
        self.interactor = MainTabBarInteractor(eventCenter: EventCenter.shared,
                                              settings: SettingsManager.shared,
                                              webSocketService: webSocketService,
                                              keystoreImportService: keystoreImportService)
        
        let walletContext = try? WalletContextFactory().createContext()
        guard let walletController = MainTabBarViewFactory.createWalletController(walletContext: walletContext!, localizationManager: localizationManager) else { return }
        
//        let jlwalletController = JLWalletViewController()
        (walletController as! JLAccountListViewController).delegate = self
        
        let walletNavigationController = JLNavigationViewController(rootViewController: walletController)
        self.navigationController = walletNavigationController
        walletNavigationController.modalPresentationStyle = .overCurrentContext
        view.rootViewController?.definesPresentationContext = true
        view.rootViewController?.present(walletNavigationController, animated: true, completion: nil)
        self.interactor?.setup()
    }
    
    func showAccountBalance(balanceBlock: @escaping ([WalletViewModelProtocol]) -> Void) {
        guard let keystoreImportService: KeystoreImportServiceProtocol = URLHandlingService.shared
                .findService() else {
            Logger.shared.error("Can't find required keystore import service")
            return
        }
        let localizationManager = LocalizationManager.shared
        let webSocketService = WebSocketService.shared
        webSocketService.networkStatusPresenter = MainTabBarViewFactory.createNetworkStatusPresenter(localizationManager: localizationManager)
        self.interactor = MainTabBarInteractor(eventCenter: EventCenter.shared,
                                              settings: SettingsManager.shared,
                                              webSocketService: webSocketService,
                                              keystoreImportService: keystoreImportService)
        
        let walletContext = try? WalletContextFactory().createContext()
        guard let walletController = MainTabBarViewFactory.getAccountBalanceCreateWalletController(walletContext: walletContext!, localizationManager: localizationManager, balanceBlock: balanceBlock) else { return }
        
        (walletController as! JLAccountListViewController).delegate = self
        (walletController as! JLAccountListViewController).getBanlanceSetup()
        let walletNavigationController = JLNavigationViewController(rootViewController: walletController)
        self.navigationController = walletNavigationController
        walletNavigationController.modalPresentationStyle = .overCurrentContext
        self.interactor?.setup()
    }
}
