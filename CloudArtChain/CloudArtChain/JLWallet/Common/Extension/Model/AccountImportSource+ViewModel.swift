import Foundation

extension AccountImportSource {
    func titleForLocale(_ locale: Locale) -> String {
        switch self {
        case .mnemonic:
            return "助记词"
        case .seed:
            return "私钥"
        case .keystore:
            return "Keystore JSON"
        }
    }
}
