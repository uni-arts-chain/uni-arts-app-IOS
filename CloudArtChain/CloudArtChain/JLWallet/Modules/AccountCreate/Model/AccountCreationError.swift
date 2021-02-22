import Foundation

enum AccountCreationError: Error {
    case unsupportedNetwork
    case invalidDerivationHardSoftPassword
    case invalidDerivationHardPassword
    case invalidDerivationHardSoft
    case invalidDerivationHard
}

extension AccountCreationError: ErrorContentConvertible {
    func toErrorContent(for locale: Locale?) -> ErrorContent {
        let title: String
        let message: String

        switch self {
        case .unsupportedNetwork:
            title = "Error"
            message = "The network type is not supported yet. Please, choose another one."
        case .invalidDerivationHardSoftPassword:
            title = "Invalid format"
            message = "Please, check that input is a mix of //'hard' and /'soft' where 'hard' and 'soft' can be any sequence of characters not including /. The path can end up with ///'password'. For example, //1/soramitsu///mypass."
        case .invalidDerivationHardPassword:
            title = "Invalid format"
            message = "Please, check that input is a mix of //'hard' where 'hard' can be any sequence of characters not including /. The path can end up with ///'password'. For example, //1//soramitsu///mypass."
        case .invalidDerivationHardSoft:
            title = "Invalid format"
            message = "Please, check that input is a mix of //'hard' and /'soft' where 'hard' and 'soft' can be any sequence of characters not including /."
        case .invalidDerivationHard:
            title = "Invalid format"
            message = "Please, check that input is a mix of //'hard' where 'hard' can be any sequence of characters not including /."
        }

        return ErrorContent(title: title, message: message)
    }
}
