import UIKit

extension WalletAssetId {
    var icon: UIImage? {
        switch self {
        case .uniarts:
            return UIImage(named: "iconPolkadotSmallBg")
        case .kusama:
            return UIImage(named: "iconKsmSmallBg")
        case .westend:
            return UIImage(named: "iconWestendSmallBg")
        case .usd:
            return nil
        }
    }

    var assetIcon: UIImage? {
        switch self {
        case .uniarts:
            return UIImage(named: "iconPolkadotAsset")
        case .kusama:
            return UIImage(named: "iconKsmAsset")
        case .westend:
            return UIImage(named: "iconWestendAsset")
        case .usd:
            return nil
        }
    }

    func titleForLocale(_ locale: Locale) -> String {
        switch self {
        case .uniarts:
            return "Uni-Arts"
        case .kusama:
            return "Kusama"
        case .westend:
            return "Westend"
        case .usd:
            return "Usd"
        }
    }
}
