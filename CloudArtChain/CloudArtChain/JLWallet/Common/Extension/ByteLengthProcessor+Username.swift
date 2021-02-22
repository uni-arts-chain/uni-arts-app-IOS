import Foundation

extension ByteLengthProcessor {
    static var username: ByteLengthProcessor {
        ByteLengthProcessor(maxLength: 20, encoding: .utf8)
    }
}
