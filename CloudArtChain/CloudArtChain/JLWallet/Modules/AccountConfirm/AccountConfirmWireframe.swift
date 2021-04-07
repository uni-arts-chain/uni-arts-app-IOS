import Foundation

final class AccountConfirmWireframe: AccountConfirmWireframeProtocol {
    lazy var rootAnimator: RootControllerAnimationCoordinatorProtocol = RootControllerAnimationCoordinator()

    func proceed(from view: AccountConfirmViewProtocol?) {
        guard let pincodeViewController = PinViewFactory.createPinSetupView(navigationController: view?.controller.navigationController, userAvatar: nil)?.controller else {
            return
        }

        rootAnimator.animateTransition(to: pincodeViewController)
    }
}
