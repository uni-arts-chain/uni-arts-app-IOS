import Foundation
import SoraFoundation

final class ExportRestoreJsonViewFactory: ExportRestoreJsonViewFactoryProtocol {
    static func createView(with model: RestoreJson) -> ExportGenericViewProtocol? {
        let accessoryActionTitle = LocalizableResource { locale in
            "Change password"
        }

        let mainActionTitle = LocalizableResource { locale in
            "Export"
        }

        let uiFactory = UIFactory()
        let view = ExportGenericViewController(uiFactory: uiFactory,
                                               binder: ExportGenericViewModelBinder(uiFactory: uiFactory),
                                               mainTitle: mainActionTitle,
                                               accessoryTitle: accessoryActionTitle)

        let presenter = ExportRestoreJsonPresenter(model: model)
        presenter.wireframe = ExportRestoreJsonWireframe()
        presenter.view = view

        view.presenter = presenter

        view.localizationManager = LocalizationManager.shared

        return view
    }
}
