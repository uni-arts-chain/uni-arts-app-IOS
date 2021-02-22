import Foundation
import IrohaCrypto

enum AddConnectionError: Error {
    case alreadyExists
    case invalidConnection
    case unsupportedChain(_ supported: [SNAddressType])
}

extension AddConnectionError: ErrorContentConvertible {
    func toErrorContent(for locale: Locale?) -> ErrorContent {
        let message: String

        switch self {
        case .alreadyExists:
            message = "The node has already been added previously. Please, try another node."
        case .invalidConnection:
            message = "Can't establish connection with node. Please, try another one."
        case .unsupportedChain(let supported):
            let supported: String = supported
                .map { $0.titleForLocale(locale ?? Locale.current) }
                .joined(separator: ", ")
            message = String(format: "Unfortunately, the network is unsupported. Please, try one of the following: %@.", supported)
        }

        let title = "Error"

        return ErrorContent(title: title, message: message)
    }
}
