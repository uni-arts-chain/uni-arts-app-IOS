import UIKit
import SoraFoundation
import SoraKeystore
import CommonWallet

final class RootWireframe: RootWireframeProtocol, JLAccountListViewControllerProtocol {
    func addressQRCode(address: String, viewController: UIViewController) {
        let addressQRCodeView = JLChainQRCodeView.init(frame: CGRect(x: 0.0, y: 0.0, width: 225.0, height: 225.0), qrcodeString: address)
        addressQRCodeView.center = viewController.view.center
        let animation = LewPopupViewAnimationSpring()
        viewController.lew_presentPopupView(addressQRCodeView, animation: animation) {
            print("动画结束")
        }
    }
    
    var navigationController: UINavigationController?
    var interactor: MainTabBarInteractor?
    
    func pointDesc() {
        
    }
    
    func accountInfo() {
        let editWalletVC = JLEditWalletViewController();
        self.navigationController?.pushViewController(editWalletVC, animated: true)
    }
    
    func pointDetail() {
//        let integralListVC = JLIntegralListViewController();
//        self.navigationController?.pushViewController(integralListVC, animated: true)
    }
    
    func addressCopySuccess() {
        JLLoading.shared().showMBSuccessTipMessage("复制成功", hideTime: 2.0)
    }
    
    func backClick(viewController: UIViewController) {
        self.interactor = nil
        viewController.navigationController?.dismiss(animated: true, completion: nil)
        self.navigationController = nil;
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
    
    func showOnboardingDefaultCreateWallet(on view: UIWindow) {
        let onboardingView = OnboardingMainViewFactory.createViewForOnboarding()
        let onboardingController = onboardingView?.controller ?? OnboardingMainViewController()
        (onboardingController as! OnboardingMainViewController).presenter.setup()
        
        let walletBoardVC = JLWalletBoardViewController()
        let navigationController = JLNavigationViewController()
        navigationController.viewControllers = [walletBoardVC]
        navigationController.modalPresentationStyle = .fullScreen

        view.rootViewController?.present(navigationController, animated: false, completion: nil)
        
        walletBoardVC.createDefaultWallet()
    }

    func showLocalAuthentication(on view: UIWindow) {
        let pincodeView = PinViewFactory.createSecuredPinView()
        let pincodeController = pincodeView?.controller ?? UIViewController()

        view.rootViewController = pincodeController
    }

    func showPincodeSetup(on view: UIWindow) {
        guard let controller = PinViewFactory.createPinSetupView(navigationController: nil, userAvatar: nil)?.controller else {
            return
        }

        view.rootViewController = controller
    }

    func showBroken(on view: UIWindow) {
        // normally user must not see this but on malicious devices it is possible
        view.backgroundColor = .red
    }
    
    func showWallet(on view: UIWindow, navigationController: UINavigationController, userAvatar: String?) {
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
        (walletController as! JLAccountListViewController).userAvatar = userAvatar
        
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
