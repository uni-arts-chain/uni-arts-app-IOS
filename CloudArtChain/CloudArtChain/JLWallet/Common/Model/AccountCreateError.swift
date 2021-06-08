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
        let title = "错误"
        let message: String

        switch self {
        case .invalidMnemonicSize:
            message = "助记符最多必须包含24个单词"
        case .invalidMnemonicFormat:
            message = "你的助记符无效，请再试一个。"
        case .invalidSeed:
            message = "私钥无效,请确保您的输入包含64个十六进制符号。"
        case .invalidKeystore:
            message = "Keystore JSON无效。请确保输入包含有效的json。"
        case .unsupportedNetwork:
            message = "尚不支持网络类型,请选择另一个。"
        case .duplicated:
//            message = "Account already exists. Please, try another one."
            message = "钱包已经存在，请再试一个。"
        }

        return ErrorContent(title: title, message: message)
    }
}
