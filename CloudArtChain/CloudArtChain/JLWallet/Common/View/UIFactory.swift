import UIKit
import SoraUI

struct UIConstants {
    static let actionBottomInset: CGFloat = 24.0
    static let actionHeight: CGFloat = 52.0
    static let jlActionHeight: CGFloat = 46.0
    static let mainAccessoryActionsSpacing: CGFloat = 16.0
    static let horizontalInset: CGFloat = 16.0
    static let triangularedViewHeight: CGFloat = 52.0
    static let triangularedTitleViewHeight: CGFloat = 110.0
    static let expandableViewHeight: CGFloat = 50.0
    static let formSeparatorWidth: CGFloat = 0.5
    static let triangularedIconLargeRadius: CGFloat = 12.0
    static let triangularedIconSmallRadius: CGFloat = 9.0
    static let smallAddressIconSize: CGSize = CGSize(width: 18.0, height: 18.0)
    static let normalAddressIconSize: CGSize = CGSize(width: 32.0, height: 32.0)
}

protocol UIFactoryProtocol {
    func createMainActionButton() -> TriangularedButton
    func createAccessoryButton() -> TriangularedButton
    func createDetailsView(with layout: DetailsTriangularedView.Layout,
                           filled: Bool) -> DetailsTriangularedView
    func createExpandableActionControl() -> ExpandableActionControl
    func createTitledMnemonicView(_ title: String?, icon: UIImage?) -> TitledMnemonicView
    func createMultilinedTriangularedView() -> MultilineTriangularedView
    func createSeparatorView() -> UIView
}

final class UIFactory: UIFactoryProtocol {
    func createMainActionButton() -> TriangularedButton {
        let button = TriangularedButton()
        button.applyDefaultStyle()
        return button
    }

    func createAccessoryButton() -> TriangularedButton {
        let button = TriangularedButton()
        button.applyAccessoryStyle()
        return button
    }

    func createDetailsView(with layout: DetailsTriangularedView.Layout,
                           filled: Bool) -> DetailsTriangularedView {
        let view = DetailsTriangularedView()
        view.layout = layout

        if !filled {
            view.fillColor = .clear
            view.highlightedFillColor = .clear
            view.strokeColor = UIColor.gray
            view.highlightedStrokeColor = UIColor.gray
            view.borderWidth = 1.0
        } else {
            view.fillColor = UIColor.darkGray
            view.highlightedFillColor = UIColor.darkGray
            view.strokeColor = .clear
            view.highlightedStrokeColor = .clear
            view.borderWidth = 0.0
        }

        switch layout {
        case .largeIconTitleSubtitle, .singleTitle:
            view.iconRadius = UIConstants.triangularedIconLargeRadius
        case .smallIconTitleSubtitle:
            view.iconRadius = UIConstants.triangularedIconSmallRadius
        }

        view.titleLabel.textColor = UIColor.lightGray
        view.titleLabel.font = UIFont.p2Paragraph
        view.subtitleLabel?.textColor = UIColor.white
        view.subtitleLabel?.font = UIFont.p1Paragraph
        view.contentInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)

        return view
    }

    func createExpandableActionControl() -> ExpandableActionControl {
        let view = ExpandableActionControl()
        view.layoutType = .flexible
        view.titleLabel.textColor = UIColor.white
        view.titleLabel.font = UIFont.p1Paragraph
        view.plusIndicator.strokeColor = UIColor.white

        return view
    }

    func createTitledMnemonicView(_ title: String?, icon: UIImage?) -> TitledMnemonicView {
        let view = TitledMnemonicView()

        if let icon = icon {
            view.iconView.image = icon
        }

        if let title = title {
            view.titleLabel.textColor = UIColor.lightGray
            view.titleLabel.font = UIFont.p1Paragraph
            view.titleLabel.text = title
        }

        view.contentView.indexTitleColorInColumn = UIColor.gray
        view.contentView.wordTitleColorInColumn = UIColor.white

        view.contentView.indexFontInColumn = .p0Digits
        view.contentView.wordFontInColumn = .p0Paragraph

        return view
    }

    func createMultilinedTriangularedView() -> MultilineTriangularedView {
        let view = MultilineTriangularedView()
        view.backgroundView.fillColor = UIColor.darkGray
        view.backgroundView.highlightedFillColor = UIColor.darkGray
        view.backgroundView.strokeColor = .clear
        view.backgroundView.highlightedStrokeColor = .clear
        view.backgroundView.strokeWidth = 0.0

        view.titleLabel.textColor = UIColor.lightGray
        view.titleLabel.font = UIFont.p2Paragraph
        view.subtitleLabel?.textColor = UIColor.white
        view.subtitleLabel?.font = UIFont.p1Paragraph
        view.contentInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)

        return view
    }

    func createSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        return view
    }
}
