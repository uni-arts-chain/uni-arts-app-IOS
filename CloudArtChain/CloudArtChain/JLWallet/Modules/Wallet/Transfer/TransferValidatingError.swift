import Foundation
import CommonWallet

enum FearlessTransferValidatingError: Error {
    case receiverBalanceTooLow
}

extension FearlessTransferValidatingError: WalletErrorContentConvertible {
    public func toErrorContent(for locale: Locale?) -> WalletErrorContentProtocol {
        let title: String
        let message: String

        switch self {
        case .receiverBalanceTooLow:
            title = "Amount is too low"
            message = "Your transfer will fail since the final amount on the destination account will be less than the existential deposit. Please, try to increase the amount."
        }

        return ErrorContent(title: title, message: message)
    }
}
