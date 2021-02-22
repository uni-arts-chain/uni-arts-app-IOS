import Foundation
import UIKit

extension UIBarButtonItem {
    func setupDefaultTitleStyle() {
        var normalTextAttributes = [NSAttributedString.Key: Any]()
        normalTextAttributes[.foregroundColor] = UIColor.white
        normalTextAttributes[.font] = UIFont.h5Title

        setTitleTextAttributes(normalTextAttributes, for: .normal)

        var highlightedTextAttributes = [NSAttributedString.Key: Any]()
        highlightedTextAttributes[.foregroundColor] = UIColor.gray
        highlightedTextAttributes[.font] = UIFont.h5Title

        setTitleTextAttributes(highlightedTextAttributes, for: .highlighted)

        var disabledTextAttributes = [NSAttributedString.Key: Any]()
        disabledTextAttributes[.foregroundColor] = UIColor.darkGray
        disabledTextAttributes[.font] = UIFont.h5Title

        setTitleTextAttributes(disabledTextAttributes, for: .disabled)
    }
}
