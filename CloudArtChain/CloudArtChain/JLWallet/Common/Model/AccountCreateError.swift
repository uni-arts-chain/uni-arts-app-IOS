import Foundation

enum AccountCreateError: Error {
    case invalidMnemonicSize
    case invalidMnemonicFormat
    case invalidSeed
    case invalidKeystore
    case unsupportedNetwork
    case duplicated
}

extension AccountCreateError: ErrorContentConvertible {
    func toErrorContent(for locale: Locale?) -> ErrorContent {
        let title = "Error"
        let message: String

        switch self {
        case .invalidMnemonicSize:
            message = "Mnemonic must contain 24 words at max"
        case .invalidMnemonicFormat:
            message = "Your mnemonic is invalid. Please, try another one."
        case .invalidSeed:
            message = "Seed is invalid. Please, make sure that your input contains 64 hex symbols."
        case .invalidKeystore:
            message = "Invalid restore json. Please, make sure that input contains valid json."
        case .unsupportedNetwork:
            message = "The network type is not supported yet. Please, choose another one."
        case .duplicated:
            message = "Account already exists. Please, try another one."
        }

        return ErrorContent(title: title, message: message)
    }
}
