import Foundation

extension ExportOption {
    func titleForLocale(_ locale: Locale) -> String {
        switch self {
        case .mnemonic:
            return "Mnemonic passphrase"
        case .keystore:
            return "Restore JSON"
        case .seed:
            return "Raw seed"
        }
    }
}
