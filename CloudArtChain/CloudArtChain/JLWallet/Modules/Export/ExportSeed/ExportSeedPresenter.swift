import Foundation
import SoraFoundation

final class ExportSeedPresenter {
    weak var view: ExportGenericViewProtocol?
    var wireframe: ExportSeedWireframeProtocol!
    var interactor: ExportSeedInteractorInputProtocol!

    let address: String
    let localizationManager: LocalizationManager

    private(set) var exportViewModel: ExportStringViewModel?

    init(address: String, localizationManager: LocalizationManager) {
        self.address = address
        self.localizationManager = localizationManager
    }

    private func share() {
        guard let viewModel = exportViewModel else {
            return
        }

        let text: String

        let locale = localizationManager.selectedLocale

        if let derivationPath = viewModel.derivationPath {
            text = String(format: "Network: %@ Seed: %@ Derivation path: %@", viewModel.networkType.titleForLocale(locale), viewModel.data, derivationPath)
        } else {
            text = String(format: "Network: %@ Seed: %@", viewModel.networkType.titleForLocale(locale), viewModel.data)
        }

        wireframe.share(source: TextSharingSource(message: text), from: view) { [weak self] (completed) in
            if completed {
                self?.wireframe.close(view: self?.view)
            }
        }
    }
}

extension ExportSeedPresenter: ExportGenericPresenterProtocol {
    func setup() {
        interactor.fetchExportDataForAddress(address)
    }

    func activateExport() {
        let title = "Be careful"
        let message = "Sharing or copying your secret is a high risk operation, don’t send it to anyone. Would you like to proceed with sharing/copying process?"

        let exportTitle = "Export"
        let exportAction = AlertPresentableAction(title: exportTitle) { [weak self] in
            self?.share()
        }

        let cancelTitle = "Cancel"
        let viewModel = AlertPresentableViewModel(title: title,
                                                  message: message,
                                                  actions: [exportAction],
                                                  closeAction: cancelTitle)

        wireframe.present(viewModel: viewModel, style: .alert, from: view)
    }
}

extension ExportSeedPresenter: ExportSeedInteractorOutputProtocol {
    func didReceive(exportData: ExportSeedData) {
        let viewModel = ExportStringViewModel(option: .seed,
                                              networkType: exportData.networkType,
                                              derivationPath: exportData.derivationPath,
                                              cryptoType: exportData.account.cryptoType,
                                              data: exportData.seed.toHex(includePrefix: true))

        exportViewModel = viewModel

        view?.set(viewModel: viewModel)
    }

    func didReceive(error: Error) {
        if !wireframe.present(error: error, from: view, locale: localizationManager.selectedLocale) {
            _ = wireframe.present(error: CommonError.undefined,
                                  from: view,
                                  locale: localizationManager.selectedLocale)
        }
    }
}
