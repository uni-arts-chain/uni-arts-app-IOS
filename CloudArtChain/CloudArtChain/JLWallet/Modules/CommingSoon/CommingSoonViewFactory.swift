import Foundation
import SoraFoundation

final class CommingSoonViewFactory: CommingSoonViewFactoryProtocol {
    static func createView() -> CommingSoonViewProtocol? {
        let view = CommingSoonViewController(nibName: "CommingSoonViewController", bundle: Bundle.main)
        let presenter = CommingSoonPresenter(applicationConfig: ApplicationConfig.shared)
        let interactor = CommingSoonInteractor()
        let wireframe = CommingSoonWireframe()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        interactor.presenter = presenter

        view.localizationManager = LocalizationManager.shared

        return view
    }
}
