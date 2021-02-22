import Foundation
import SoraFoundation

final class AboutViewFactory: AboutViewFactoryProtocol {
    static func createView() -> AboutViewProtocol? {

        let locale = LocalizationManager.shared.selectedLocale

        let config: ApplicationConfigProtocol = ApplicationConfig.shared
        let legal = LegalData(termsUrl: config.termsURL, privacyPolicyUrl: config.privacyPolicyURL)

        let supportData = SupportData(title: "Fearless support",
                                      subject: "",
                                      details: "",
                                      email: ApplicationConfig.shared.supportEmail)

        let about = AboutData(version: config.version,
                              opensourceUrl: config.opensourceURL,
                              websiteUrl: config.websiteURL,
                              socialUrl: config.socialURL,
                              legal: legal,
                              writeUs: supportData)

        let view = AboutViewController(nibName: "AboutViewController", bundle: Bundle.main)
        let presenter = AboutPresenter(locale: locale, about: about)
        let wireframe = AboutWireframe()

        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe

        view.locale = locale

        return view
    }
}
