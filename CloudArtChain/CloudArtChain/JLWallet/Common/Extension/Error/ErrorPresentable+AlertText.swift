import Foundation
import RobinHood

struct ErrorContent {
    let title: String
    let message: String
}

protocol ErrorContentConvertible {
    func toErrorContent(for locale: Locale?) -> ErrorContent
}

extension ErrorPresentable where Self: AlertPresentable {
    func present(error: Error, from view: ControllerBackedProtocol?, locale: Locale?) -> Bool {
        var optionalContent: ErrorContent?

        if let contentConvertibleError = error as? ErrorContentConvertible {
            optionalContent = contentConvertibleError.toErrorContent(for: locale)
        }

        if error as? BaseOperationError != nil {
            let title = "Operation Failed"
            let message = "Please, try again later"

            optionalContent = ErrorContent(title: title, message: message)
        }

        if (error as NSError).domain == NSURLErrorDomain {
            let title = "Connection Failed"
            let message = "Please, check internet connection and try again later."

            optionalContent = ErrorContent(title: title, message: message)
        }

        guard let content = optionalContent else {
            return false
        }

        let closeAction = "Close"

        present(message: content.message, title: content.title, closeAction: closeAction, from: view)

        return true
    }
}
