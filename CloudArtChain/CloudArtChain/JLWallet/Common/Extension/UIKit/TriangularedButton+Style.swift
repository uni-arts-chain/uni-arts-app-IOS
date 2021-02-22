import Foundation
import SoraUI

extension TriangularedButton {
    func applyDefaultStyle() {
        triangularedView?.shadowOpacity = 0.0
        triangularedView?.fillColor = UIColor.blue
        triangularedView?.highlightedFillColor = UIColor.blue
        triangularedView?.strokeColor = .clear
        triangularedView?.highlightedStrokeColor = .clear

        imageWithTitleView?.titleColor = UIColor.white
        imageWithTitleView?.titleFont = UIFont.h5Title

        changesContentOpacityWhenHighlighted = true
    }

    func applyAccessoryStyle() {
        triangularedView?.shadowOpacity = 0.0
        triangularedView?.fillColor = .clear
        triangularedView?.highlightedFillColor = .clear
        triangularedView?.strokeColor = UIColor.darkGray
        triangularedView?.highlightedStrokeColor = UIColor.darkGray
        triangularedView?.strokeWidth = 2.0

        imageWithTitleView?.titleColor = UIColor.white
        imageWithTitleView?.titleFont = UIFont.h5Title

        changesContentOpacityWhenHighlighted = true
    }
}
