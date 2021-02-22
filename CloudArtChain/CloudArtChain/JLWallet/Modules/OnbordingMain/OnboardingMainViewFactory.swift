import Foundation
import SoraKeystore
import SoraFoundation

final class OnboardingMainViewFactory: OnboardingMainViewFactoryProtocol {
    static func createViewForOnboarding() -> OnboardingMainViewProtocol? {
        guard let kestoreImportService: KeystoreImportServiceProtocol =
            URLHandlingService.shared.findService() else {
            Logger.shared.error("Can't find required keystore import service")
            return nil
        }

        let applicationConfig: ApplicationConfigProtocol = ApplicationConfig.shared

        let locale: Locale = LocalizationManager.shared.selectedLocale

        let legalData = LegalData(termsUrl: applicationConfig.termsURL,
                              privacyPolicyUrl: applicationConfig.privacyPolicyURL)

        let view = OnboardingMainViewController(nibName: "OnbordingMain", bundle: Bundle.main)

        let presenter = OnboardingMainPresenter(legalData: legalData, locale: locale)
        let wireframe = OnboardingMainWireframe()

        let interactor = OnboardingMainInteractor(keystoreImportService: kestoreImportService)

        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor

        interactor.presenter = presenter

        return view
    }

    static func createViewForAdding() -> OnboardingMainViewProtocol? {
        guard let kestoreImportService: KeystoreImportServiceProtocol =
            URLHandlingService.shared.findService() else {
            Logger.shared.error("Can't find required keystore import service")
            return nil
        }

        let applicationConfig: ApplicationConfigProtocol = ApplicationConfig.shared

        let locale: Locale = LocalizationManager.shared.selectedLocale

        let legalData = LegalData(termsUrl: applicationConfig.termsURL,
                              privacyPolicyUrl: applicationConfig.privacyPolicyURL)

        let view = OnboardingMainViewController(nibName: "OnbordingMain", bundle: Bundle.main)

        let presenter = OnboardingMainPresenter(legalData: legalData, locale: locale)
        let wireframe = AddMainWireframe()

        let interactor = OnboardingMainInteractor(keystoreImportService: kestoreImportService)

        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor

        interactor.presenter = presenter

        return view
    }

    static func createViewForConnection(item: ConnectionItem) -> OnboardingMainViewProtocol? {
        guard let kestoreImportService: KeystoreImportServiceProtocol =
            URLHandlingService.shared.findService() else {
            Logger.shared.error("Can't find required keystore import service")
            return nil
        }

        let applicationConfig: ApplicationConfigProtocol = ApplicationConfig.shared

        let locale: Locale = LocalizationManager.shared.selectedLocale

        let legalData = LegalData(termsUrl: applicationConfig.termsURL,
                              privacyPolicyUrl: applicationConfig.privacyPolicyURL)

        let view = OnboardingMainViewController(nibName: "OnbordingMain", bundle: Bundle.main)

        let presenter = OnboardingMainPresenter(legalData: legalData, locale: locale)
        let wireframe = ConnectionMainWireframe(connectionItem: item)

        let interactor = OnboardingMainInteractor(keystoreImportService: kestoreImportService)

        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor

        interactor.presenter = presenter

        return view
    }
}
