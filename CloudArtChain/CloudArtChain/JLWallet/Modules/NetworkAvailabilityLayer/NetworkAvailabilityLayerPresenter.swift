import UIKit
import SoraFoundation

final class NetworkAvailabilityLayerPresenter {
    var view: ApplicationStatusPresentable!

    var unavailbleStyle: ApplicationStatusStyle {
        return ApplicationStatusStyle(backgroundColor: UIColor.systemPink,
                                      titleColor: UIColor.white,
                                      titleFont: UIFont.h6Title)
    }

    var availableStyle: ApplicationStatusStyle {
        return ApplicationStatusStyle(backgroundColor: UIColor.green,
                                      titleColor: UIColor.white,
                                      titleFont: UIFont.h6Title)
    }
}

extension NetworkAvailabilityLayerPresenter: NetworkAvailabilityLayerInteractorOutputProtocol {
    func didDecideUnreachableStatusPresentation() {
        view.presentStatus(title: "Connecting...",
                           style: unavailbleStyle,
                           animated: true)
    }

    func didDecideReachableStatusPresentation() {
        view.dismissStatus(title: "Connected",
                           style: availableStyle,
                           animated: true)
    }
}

extension NetworkAvailabilityLayerPresenter: Localizable {
    func applyLocalization() {}
}
