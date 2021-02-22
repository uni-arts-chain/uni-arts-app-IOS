import UIKit
import SoraFoundation
import SoraUI
import AudioToolbox

final class AccountConfirmViewController: JLBaseViewController, AdaptiveDesignable {
    private struct Constants {
        static let externalMargin: CGFloat = 16.0
        static let itemsSpacing: CGFloat = 8.0
        static let internalMargin: CGFloat = 16.0
        static let itemContentInsets: UIEdgeInsets = UIEdgeInsets(top: 7.0,
                                                                  left: 11.0,
                                                                  bottom: 7.0,
                                                                  right: 11.0)
        static let cornerRadius: CGFloat = 4.0
    }

    private struct Position {
        let leading: NSLayoutConstraint
        let top: NSLayoutConstraint
    }

    var presenter: AccountConfirmPresenterProtocol!

    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var bottomPlaneView: UIView!
    @IBOutlet private var topPlaneView: UIView!

    @IBOutlet private var buttonsView: UIView!
    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var skipButton: UIButton!
    
    @IBOutlet private var topPlaneHeight: NSLayoutConstraint!
    @IBOutlet private var bottomPlaneHeight: NSLayoutConstraint!

    private var minHeight: CGFloat = 0.0

    var wordTransitionAnimation = BlockViewAnimator(duration: 0.25,
                                                    options: [.curveEaseOut])

    var retryAnimation = TransitionAnimator(type: CATransitionType.fade,
                                            duration: 0.25)

    var wrongSequenceAnimation = ShakeAnimator(duration: 0.5,
                                               options: [.curveEaseInOut])

    private var contentWidth: CGFloat = 0.0

    private var pendingButtons: [RoundedButton] = []
    private var submittedButtons: [RoundedButton] = []
    private var positions: [RoundedButton: Position] = [:]
    private var originalPositions: [RoundedButton: Position] = [:]

    lazy var nextButtonTitle: LocalizableResource<String> = LocalizableResource { locale in
        "Next"
    }

    var skipButtonTitle: LocalizableResource<String>?

    override func viewDidLoad() {
        super.viewDidLoad()

//        if skipButtonTitle != nil {
//            createSkipButton()
//        }
        self.addBackItem()
        setupNavigationItem()
        setupLocalization()
        configureLayout()
        updateNextButton()

        presenter.setup()
    }

    private func configureLayout() {
        skipButton.layer.cornerRadius = 23.0
        skipButton.layer.masksToBounds = true
        skipButton.layer.borderColor = UIColor(hex: "50C3FF").cgColor
        skipButton.layer.borderWidth = 1.0
        
        nextButton.layer.cornerRadius = 23.0
        nextButton.layer.masksToBounds = true
        
        contentWidth = baseDesignSize.width * designScaleRatio.width - 2.0 * Constants.externalMargin
    }

    private func setupLocalization() {
        title = "备份助记词"
    }

    private func createButton() -> RoundedButton {
        let button = RoundedButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.roundedBackgroundView?.shadowOpacity = 0.0
        button.contentInsets = Constants.itemContentInsets
        button.roundedBackgroundView?.fillColor = UIColor.blue
        button.roundedBackgroundView?.highlightedFillColor = UIColor(red: 0.0, green: 0.218, blue: 0.718, alpha: 0.5)
        button.roundedBackgroundView?.cornerRadius = Constants.cornerRadius
        button.imageWithTitleView?.titleColor = UIColor.white
        button.imageWithTitleView?.titleFont = UIFont.p1Paragraph
        button.changesContentOpacityWhenHighlighted = true

        button.addTarget(self,
                         action: #selector(actionItem),
                         for: .touchUpInside)

        return button
    }

    private func apply(words: [String]) {
        clearButtons()

        let newPendingButtons: [RoundedButton] = words.map { word in
            let button = createButton()
            button.imageWithTitleView?.title = word
            return button
        }

        newPendingButtons.forEach { contentView.addSubview($0) }

        pendingButtons = newPendingButtons

        let rows = createRowsFromButtons(pendingButtons)
        minHeight = layoutRows(rows, on: bottomPlaneView) + 2 * Constants.internalMargin
        
        layoutButtons()
        
        updateNextButton()
    }

    private func clearButtons() {
        pendingButtons.forEach { $0.removeFromSuperview() }
        submittedButtons.forEach { $0.removeFromSuperview() }

        pendingButtons = []
        submittedButtons = []
        positions = [:]
        originalPositions = [:]
    }

    private func setupNavigationItem() {
        let infoItem = UIBarButtonItem(image: UIImage(named: "iconRetry"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(actionRetry))
        navigationItem.rightBarButtonItem = infoItem
    }

    private func createSkipButton() {
        let skipButton = TriangularedButton()
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.applyAccessoryStyle()
        buttonsView.addSubview(skipButton)

        skipButton.addTarget(self,
                             action: #selector(actionSkip),
                             for: .touchUpInside)

        skipButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor).isActive = true
        skipButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor).isActive = true
        skipButton.bottomAnchor.constraint(equalTo: nextButton.topAnchor,
                                           constant: -UIConstants.mainAccessoryActionsSpacing).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: UIConstants.actionHeight).isActive = true

//        buttonsHeightConstraint.constant = 2.0 * UIConstants.actionHeight + UIConstants.mainAccessoryActionsSpacing
//
//        self.skipButton = skipButton
    }

    private func updateNextButton() {
        nextButton.isEnabled = pendingButtons.isEmpty && !submittedButtons.isEmpty
        if nextButton.isEnabled {
            nextButton.backgroundColor = UIColor(hex: "50C3FF")
        } else {
            nextButton.backgroundColor = UIColor(hex: "50C3FF", alpha: 0.5)
        }
    }

    @objc private func actionRetry() {
        presenter.requestWords()
    }

    @IBAction private func actionNext() {
        guard pendingButtons.isEmpty else {
            return
        }

        let words: [String] = submittedButtons.reduce(into: []) { (list, button) in
            if let title = button.imageWithTitleView?.title {
                list.append(title)
            }
        }

        presenter.confirm(words: words)
    }
    
    @IBAction private func actionSkip() {
        presenter.skip()
    }
}

extension AccountConfirmViewController {
    private func layoutButtons() {
        layoutPendingButtons()
        layoutSubmittedButtons()
    }

    private func layoutSubmittedButtons() {
        let rows = createRowsFromButtons(submittedButtons)
        let height = layoutRows(rows, on: topPlaneView)
        topPlaneHeight.constant = max(minHeight, height + 2.0 * Constants.internalMargin)
    }

    private func layoutPendingButtons() {
        let rows = createRowsFromButtons(pendingButtons)
        let height = layoutRows(rows, on: bottomPlaneView)
        bottomPlaneHeight.constant = max(minHeight, height + 2.0 * Constants.internalMargin)
    }

    private func createRowsFromButtons(_ buttons: [RoundedButton]) -> [[RoundedButton]] {
        let availableWidth = contentWidth - 2.0 * Constants.internalMargin

        var targetButtonIndex = 0

        var rows: [[RoundedButton]] = []

        var row: [RoundedButton] = []

        var remainedWidth = availableWidth

        while targetButtonIndex < buttons.count {
            let size = buttons[targetButtonIndex].intrinsicContentSize

            if size.width <= remainedWidth {
                row.append(buttons[targetButtonIndex])

                remainedWidth -= size.width + Constants.itemsSpacing

                targetButtonIndex += 1
            } else {
                if !row.isEmpty {
                    rows.append(row)
                    row = []
                } else {
                    break
                }

                remainedWidth = availableWidth
            }
        }

        if !row.isEmpty {
            rows.append(row)
        }

        return rows
    }

    private func layoutRows(_ rows: [[RoundedButton]], on plane: UIView) -> CGFloat {
        var currentY = Constants.internalMargin

        let availableWidth = contentWidth - 2.0 * Constants.internalMargin

        var totalHeight: CGFloat = 0.0

        for row in rows {
            var width = row.reduce(CGFloat(0.0)) { (result, item) in
                return result + item.intrinsicContentSize.width
            }

            width += CGFloat(row.count - 1) * Constants.itemsSpacing

            let height = row.reduce(CGFloat(0.0)) { (result, item) in
                return max(result, item.intrinsicContentSize.height)
            }

            var originX = Constants.internalMargin + availableWidth / 2.0 - width / 2.0

            for item in row {
                let size = item.intrinsicContentSize

                if let position = positions[item] {
                    position.leading.isActive = false
                    position.top.isActive = false
                }

                let leading = item.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                            constant: originX)

                let itemY = currentY + height / 2.0 - size.height / 2.0
                let top = item.topAnchor.constraint(equalTo: plane.topAnchor,
                                                    constant: itemY)

                leading.isActive = true
                top.isActive = true

                positions[item] = Position(leading: leading, top: top)

                originX += size.width + Constants.itemsSpacing
            }

            currentY += height + Constants.itemsSpacing

            totalHeight += height
        }

        return totalHeight + CGFloat(rows.count - 1) * Constants.itemsSpacing
    }

    @objc private func actionItem(_ sender: AnyObject) {
        guard let button = sender as? RoundedButton else {
            return
        }

        if let index = pendingButtons.firstIndex(of: button) {
            pendingButtons.remove(at: index)
            submittedButtons.append(button)

            originalPositions[button] = positions[button]

            let animationBlock = {
                button.roundedBackgroundView?.fillColor = UIColor(red: 0.0, green: 0.218, blue: 0.718, alpha: 0.5)
                button.roundedBackgroundView?.highlightedFillColor = UIColor(red: 0.0, green: 0.218, blue: 0.718, alpha: 0.5)
                button.changesContentOpacityWhenHighlighted = true
                self.layoutSubmittedButtons()
        
                self.contentView.layoutIfNeeded()
            }

            wordTransitionAnimation.animate(block: animationBlock,
                                            completionBlock: nil)
        } else if let index = submittedButtons.firstIndex(of: button) {
            submittedButtons.remove(at: index)
            pendingButtons.append(button)

            let currentPosition = positions[button]
            positions[button] = originalPositions[button]

            let animationBlock = {
                button.roundedBackgroundView?.fillColor = UIColor.blue
                button.roundedBackgroundView?.highlightedFillColor = UIColor(red: 0.0, green: 0.218, blue: 0.718, alpha: 0.5)
                button.changesContentOpacityWhenHighlighted = false

                currentPosition?.leading.isActive = false
                currentPosition?.top.isActive = false

                if let originalPosition = self.originalPositions[button] {
                    originalPosition.leading.isActive = true
                    originalPosition.top.isActive = true
                }
                self.layoutSubmittedButtons()
                self.contentView.layoutIfNeeded()
            }

            wordTransitionAnimation.animate(block: animationBlock,
                                            completionBlock: nil)
        }

        updateNextButton()
    }
}

extension AccountConfirmViewController: AccountConfirmViewProtocol {
    func didReceive(words: [String], afterConfirmationFail: Bool) {
        if afterConfirmationFail {
            wrongSequenceAnimation.animate(view: contentView) { _ in
                self.apply(words: words)
                self.retryAnimation.animate(view: self.contentView,
                                            completionBlock: nil)
            }

            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        } else {
            apply(words: words)

            self.retryAnimation.animate(view: self.contentView,
                                        completionBlock: nil)
        }
    }
}

extension AccountConfirmViewController: Localizable {
    func applyLocalization() {
        if isViewLoaded {
            setupLocalization()
            view.setNeedsLayout()
        }
    }
}
