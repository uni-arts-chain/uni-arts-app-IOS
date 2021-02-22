import Foundation
import SoraFoundation

final class ExportMnemonicPresenter {
    weak var view: ExportGenericViewProtocol?
    var wireframe: ExportMnemonicWireframeProtocol!
    var interactor: ExportMnemonicInteractorInputProtocol!

    let address: String
    let localizationManager: LocalizationManager

    private(set) var exportData: ExportMnemonicData?

    init(address: String, localizationManager: LocalizationManager) {
        self.address = address
        self.localizationManager = localizationManager
    }

    private func share() {
        guard let data = exportData else {
            return
        }

        let text: String

        let locale = localizationManager.selectedLocale

        if let derivationPath = exportData?.derivationPath {
            text = String(format:"Network: %@ Mnemonic: %@ Derivation path: %@", data.networkType.titleForLocale(locale), data.mnemonic.toString(), derivationPath)
        } else {
            text = String(format: "Network: %@ Mnemonic: %@", data.networkType.titleForLocale(locale), data.mnemonic.toString())
        }

        wireframe.share(source: TextSharingSource(message: text), from: view) { [weak self] (completed) in
            if completed {
                self?.wireframe.close(view: self?.view)
            }
        }
    }
}

extension ExportMnemonicPresenter: ExportGenericPresenterProtocol {
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

    func activateAccessoryOption() {
        guard let exportData = exportData else {
            return
        }

        wireframe.openConfirmationForMnemonic(exportData.mnemonic, from: view)
    }
}

extension ExportMnemonicPresenter: ExportMnemonicInteractorOutputProtocol {
    func didReceive(exportData: ExportMnemonicData) {
        self.exportData = exportData

        let viewModel = ExportMnemonicViewModel(option: .mnemonic,
                                                networkType: exportData.networkType,
                                                derivationPath: exportData.derivationPath,
                                                cryptoType: exportData.account.cryptoType,
                                                mnemonic: exportData.mnemonic.allWords())
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
