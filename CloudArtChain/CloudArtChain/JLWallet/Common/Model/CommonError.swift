import Foundation

enum CommonError: Error {
    case undefined
}

extension CommonError: ErrorContentConvertible {
    func toErrorContent(for locale: Locale?) -> ErrorContent {
        let title: String
        let message: String

        switch self {
        case .undefined:
            title = "Undefined error"
            message = "Please, try again with another input. If the error appears again, please, contact support."
        }

        return ErrorContent(title: title, message: message)
    }
}
