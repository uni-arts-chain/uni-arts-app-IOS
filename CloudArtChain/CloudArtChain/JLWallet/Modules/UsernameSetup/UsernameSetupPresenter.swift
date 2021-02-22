import Foundation
import SoraFoundation

class UsernameSetupPresenter : NSObject {
    weak var view: UsernameSetupViewProtocol?
    var wireframe: UsernameSetupWireframeProtocol!

    private var viewModel: InputViewModelProtocol = {
        let inputHandling = InputHandler(predicate: NSPredicate.notEmpty,
                                         processor: ByteLengthProcessor.username)
        return InputViewModel(inputHandler: inputHandling)
    }()
}

extension UsernameSetupPresenter: UsernameSetupPresenterProtocol {
    func setup() {
        view?.set(viewModel: viewModel)
    }

    func proceed() {
        let value = viewModel.inputHandler.value

        let actionTitle = "OK"
        let action = AlertPresentableAction(title: actionTitle) { [weak self] in
            self?.wireframe.proceed(from: self?.view, username: value)
        }

        let title = "Do not take screenshots"
        let message = "Do not take screenshots, which may be collected by third-party malware"
        let viewModel = AlertPresentableViewModel(title: title,
                                                  message: message,
                                                  actions: [action],
                                                  closeAction: nil)

        wireframe.present(viewModel: viewModel, style: .alert, from: view)
    }
}

extension UsernameSetupPresenter: Localizable {
    func applyLocalization() {}
}
