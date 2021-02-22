import Foundation
import SoraKeystore

enum SettingsKey: String {
    case selectedLocalization
    case selectedAccount
    case biometryEnabled
    case selectedConnection
}

extension SettingsManagerProtocol {
    var hasSelectedAccount: Bool {
        selectedAccount != nil
    }

    var selectedAccount: JLWalletAccountItem? {
        get {
            value(of: JLWalletAccountItem.self, for: SettingsKey.selectedAccount.rawValue)
        }

        set {
            if let newValue = newValue {
                set(value: newValue, for: SettingsKey.selectedAccount.rawValue)
            } else {
                removeValue(for: SettingsKey.selectedAccount.rawValue)
            }
        }
    }
}
