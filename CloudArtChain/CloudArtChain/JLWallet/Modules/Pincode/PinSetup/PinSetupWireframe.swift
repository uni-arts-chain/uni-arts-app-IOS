import UIKit
import SoraFoundation
import SoraKeystore
import CommonWallet

class PinSetupWireframe: PinSetupWireframeProtocol, JLAccountListViewControllerProtocol {
    func addressQRCode(address: String, viewController: UIViewController) {
        let addressQRCodeView = JLChainQRCodeView.init(frame: CGRect(x: 0.0, y: 0.0, width: 225.0, height: 225.0), qrcodeString: address)
        addressQRCodeView.center = viewController.view.center
        let animation = LewPopupViewAnimationSpring()
        viewController.lew_presentPopupView(addressQRCodeView, animation: animation) {
            print("动画结束")
        }
    }
    
    lazy var rootAnimator: RootControllerAnimationCoordinatorProtocol = RootControllerAnimationCoordinator()
    var navigationController: UINavigationController?
    var interactor: MainTabBarInteractor?
    
    func importWallet(from viewController: UIViewController) {
//        let onboardingView = OnboardingMainViewFactory.createViewForOnboarding()
//        let onboardingController = onboardingView?.controller ?? OnboardingMainViewController()
//        (onboardingController as! OnboardingMainViewController).presenter.setup()
//
//        let walletBoardVC = JLWalletBoardViewController()
//
//        let navigationController = JLNavigationViewController()
//        navigationController.viewControllers = [walletBoardVC]
//        navigationController.modalPresentationStyle = .fullScreen
//
//        viewController.present(navigationController, animated: true, completion: nil)
//        guard let restorationController = AccountImportViewFactory
//            .createViewForOnboarding()?.controller else {
//            return
//        }
        guard let restorationController = AccountImportViewFactory.createViewForAdding()?.controller else {
            return
        }
        let navigationController = JLNavigationViewController()
        navigationController.viewControllers = [restorationController]
        navigationController.modalPresentationStyle = .fullScreen
        viewController.present(navigationController, animated: true, completion: nil)
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
        let navigationController = JLNavigationViewController(rootViewController: JLTabbarController());
        JLTool.resetRootViewControoler(navigationController)
    }

    func showMain(from view: PinSetupViewProtocol?, navigationController: UINavigationController?, userAvatar: String?) {
//        guard let mainViewController = MainTabBarViewFactory.createView()?.controller else {
//            return
//        }
//
//        rootAnimator.animateTransition(to: mainViewController)
        
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
        (walletController as! JLAccountListViewController).delegate = self
        (walletController as! JLAccountListViewController).userAvatar = userAvatar
        let walletNavigationController = JLNavigationViewController(rootViewController: walletController)
        self.navigationController = walletNavigationController
//        rootAnimator.animateTransition(to: walletNavigationController)
        self.interactor?.setup()
        
        // 直接返回
        backClick(viewController: walletController)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CreateOrImportWalletNotification"), object: nil)
    }

    public func showSignup(from view: PinSetupViewProtocol?) {
        guard let signupViewController = OnboardingMainViewFactory.createViewForOnboarding()?.controller else {
            return
        }

        rootAnimator.animateTransition(to: signupViewController)
    }
}
