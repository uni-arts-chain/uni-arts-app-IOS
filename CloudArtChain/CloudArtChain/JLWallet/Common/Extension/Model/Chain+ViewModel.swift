import UIKit

extension Chain {
    func titleForLocale(_ locale: Locale) -> String {
        switch self {
        case .uniarts:
            return "UniArts"
        case .kusama:
            return "Kusama"
        case .westend:
            return "Westend"
        }
    }

    var icon: UIImage? {
        switch self {
        case .uniarts:
            return UIImage(named: "iconPolkadotSmallBg")
        case .kusama:
            return UIImage(named: "iconKsmSmallBg")
        case .westend:
            return UIImage(named: "iconWestendSmallBg")
        }
    }
}
