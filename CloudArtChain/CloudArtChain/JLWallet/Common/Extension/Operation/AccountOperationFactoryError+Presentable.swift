import Foundation

extension AccountOperationFactoryError: ErrorContentConvertible {
    func toErrorContent(for locale: Locale?) -> ErrorContent {
        let title: String
        let message: String

        switch self {
        case .decryption:
            title = "Keystore decryption failed"
            message = "Please, check password correctness and try again."
        default:
            title = "Error"
            message = "Please, try again with another input. If the error appears again, please, contact support."
        }

        return ErrorContent(title: title, message: message)
    }
}
