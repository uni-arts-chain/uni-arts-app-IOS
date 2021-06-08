import Foundation

extension AccountOperationFactoryError: ErrorContentConvertible {
    func toErrorContent(for locale: Locale?) -> ErrorContent {
        let title: String
        let message: String

        switch self {
        case .decryption:
            title = "Keystore JSON解密失败"
            message = "请检查密码正确性，然后重试。"
        default:
            title = "错误"
            message = "请用其他输入再试一次。如果错误再次出现，请联系支持人员。"
        }

        return ErrorContent(title: title, message: message)
    }
}
