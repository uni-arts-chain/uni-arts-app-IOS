import Foundation
import UIKit

extension TriangularedView {
    func applyDisabledStyle() {
        fillColor = UIColor.darkGray
        strokeColor = .clear
    }

    func applyEnabledStyle() {
        fillColor = .clear
        strokeColor = UIColor.gray
    }
}
