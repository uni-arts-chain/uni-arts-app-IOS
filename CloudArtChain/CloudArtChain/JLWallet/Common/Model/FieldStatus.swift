import UIKit

enum FieldStatus {
    case none
    case valid
    case warning
    case invalid
}

extension FieldStatus {
    var icon: UIImage? {
        switch self {
        case .valid:
            return UIImage(named: "iconValid")
        case .invalid:
            return UIImage(named: "iconInvalid")
        case .warning:
            return UIImage(named: "iconAlert")
        case .none:
            return nil
        }
    }
}
