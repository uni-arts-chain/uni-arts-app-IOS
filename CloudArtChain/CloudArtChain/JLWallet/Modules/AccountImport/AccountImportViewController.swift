import UIKit
import SoraKeystore
import SoraFoundation
import SoraUI

final class AccountImportViewController: JLBaseViewController {
    private struct Constants {
        static let advancedFullHeight: CGFloat = 220.0
        static let advancedTruncHeight: CGFloat = 152.0
    }

    var presenter: AccountImportPresenterProtocol!

    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var sourceTypeView: JLActionControl!
    @IBOutlet private var usernameView: UIView!
    @IBOutlet private var usernameTextFieldView: JLTextFieldControl!
    @IBOutlet private var usernameFooterLabel: UILabel!
    @IBOutlet weak var usernameSeparatorView: UIView!
    @IBOutlet private var passwordView: JLTextFieldControl!
    @IBOutlet private var passwordSeparatorView: UIView!
    @IBOutlet private var textPlaceholderLabel: UILabel!
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var nextButton: UIButton!

    @IBOutlet private var textContainerView: UIView!
    @IBOutlet private var textContainerSeparatorView: UIView!

    @IBOutlet private var uploadView: JLSelectControl!

    @IBOutlet private var warningView: UIView!
    @IBOutlet private var warningLabel: UILabel!

    @IBOutlet var networkTypeView: BorderedSubtitleActionView!
    @IBOutlet var cryptoTypeView: BorderedSubtitleActionView!

    @IBOutlet var derivationPathView: TriangularedView!
    @IBOutlet var derivationPathLabel: UILabel!
    @IBOutlet var derivationPathField: UITextField!
    @IBOutlet var derivationPathImageView: UIImageView!

    @IBOutlet var advancedContainerView: UIView!
    @IBOutlet var advancedView: UIView!
    @IBOutlet var advancedControl: ExpandableActionControl!

    @IBOutlet var advancedContainerHeight: NSLayoutConstraint!

    private var derivationPathModel: InputViewModelProtocol?
    private var usernameViewModel: InputViewModelProtocol?
    private var passwordViewModel: InputViewModelProtocol?
    private var sourceViewModel: InputViewModelProtocol?

    var keyboardHandler: KeyboardHandler?
    
    var advancedAppearanceAnimator = TransitionAnimator(type: CATransitionType.push,
                                                        duration: 0.35,
                                                        subtype: CATransitionSubtype.fromBottom,
                                                        curve: CAMediaTimingFunctionName.easeOut)

    var advancedDismissalAnimator = TransitionAnimator(type: CATransitionType.push,
                                                       duration: 0.35,
                                                       subtype: CATransitionSubtype.fromTop,
                                                       curve: CAMediaTimingFunctionName.easeIn)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackItem()
        view.backgroundColor = .white
        
        configure()
        setupLocalization()
        updateTextViewPlaceholder()

        presenter.setup()
    }
    
    override func backClick() {
        let controllerArray = self.navigationController!.viewControllers
        if controllerArray.count > 1 {
            if controllerArray[controllerArray.count - 1] == self {
                // push 方式
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func configNavigationItem() {
        let infoItem = UIBarButtonItem(image: UIImage(named: "icon_wallet_qrscan"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(scanQRCode))
        navigationItem.rightBarButtonItem = infoItem
    }
    
    @objc func scanQRCode() {
        let scanVC = JLScanViewController();
        scanVC.scanType = JLScanType.importWallet;
        scanVC.qrCode = true;
        scanVC.resultBlock = { [weak self] scanResult in
            self?.presenter.qrcodeActiceUpload(json: scanResult)
        }
        scanVC.modalPresentationStyle = .fullScreen;
        self.present(scanVC, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if keyboardHandler == nil {
            setupKeyboardHandler()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        clearKeyboardHandler()
    }

    private func configure() {
        stackView.arrangedSubviews.forEach { $0.backgroundColor = UIColor.white }

        advancedContainerView.isHidden = !advancedControl.isActivated

        if let placeholder = derivationPathField.placeholder {
            let color = UIColor.gray
            let attributedPlaceholder = NSAttributedString(string: placeholder,
                                                           attributes: [.foregroundColor: color])
            derivationPathField.attributedPlaceholder = attributedPlaceholder
        }
        
        textContainerView.layer.cornerRadius = 5.0
        textContainerView.layer.masksToBounds = true
        textContainerView.layer.borderWidth = 1.0
        textContainerView.layer.borderColor = UIColor(hex: "818181").cgColor
        
        textView.tintColor = UIColor(hex: "212121")

        sourceTypeView.actionControl.addTarget(self,
                                 action: #selector(actionOpenSourceType),
                                 for: .valueChanged)

        cryptoTypeView.actionControl.addTarget(self,
                                               action: #selector(actionOpenCryptoType),
                                               for: .valueChanged)

        networkTypeView.actionControl.addTarget(self,
                                                action: #selector(actionOpenAddressType),
                                                for: .valueChanged)
        
        usernameTextFieldView.setPlaceHolder(placeHolder: "请输入钱包名")
        usernameTextFieldView.textField.addTarget(self, action: #selector(actionNameTextFieldChanged), for: .editingChanged)
        usernameTextFieldView.textField.returnKeyType = .done
        usernameTextFieldView.textField.textContentType = .nickname
        usernameTextFieldView.textField.autocapitalizationType = .none
        usernameTextFieldView.textField.autocorrectionType = .no
        usernameTextFieldView.textField.spellCheckingType = .no
        
        passwordView.setPlaceHolder(placeHolder: "设置JSON密码")
        passwordView.textField.addTarget(self, action: #selector(actionPasswordTextFieldChanged), for: .editingChanged)
        passwordView.textField.returnKeyType = .done
        passwordView.textField.textContentType = .password
        passwordView.textField.autocapitalizationType = .none
        passwordView.textField.autocorrectionType = .no
        passwordView.textField.spellCheckingType = .no
        passwordView.textField.isSecureTextEntry = true

        usernameTextFieldView.textField.delegate = self
        passwordView.textField.delegate = self

        uploadView.addTarget(self, action: #selector(actionUpload), for: .touchUpInside)
        
        nextButton.layer.cornerRadius = 23.0
        nextButton.layer.masksToBounds = true
    }

    private func setupLocalization() {
        let locale = localizationManager?.selectedLocale ?? Locale.current

        title = "导入钱包"
        sourceTypeView.titleLabel.text = "导入类型"

        setupUsernamePlaceholder(for: locale)

        usernameFooterLabel.text = "此帐户的名称将会在您的地址下显示。"

        setupPasswordPlaceholder(for: locale)

        advancedControl.titleLabel.text = "Advanced"
        advancedControl.invalidateLayout()

        cryptoTypeView.actionControl.contentView.titleLabel.text = "Keypair crypto type"
        cryptoTypeView.actionControl.invalidateLayout()

        derivationPathLabel.text = "Secret derivation path"

        networkTypeView.actionControl.contentView.titleLabel.text = "Choose network"
        networkTypeView.invalidateLayout()

        uploadView.titleLabel.text = "JSON文件"

        if !uploadView.isHidden {
            updateUploadView()
        }
    }

    private func setupUsernamePlaceholder(for locale: Locale) {
        usernameTextFieldView.titleLabel.text = "钱包名称"
    }

    private func setupPasswordPlaceholder(for locale: Locale) {
        passwordView.titleLabel.text = "JSON密码"
    }

    private func updateNextButton() {
        var isEnabled: Bool = true

        if let viewModel = sourceViewModel, viewModel.inputHandler.required {
            let uploadViewActive = !uploadView.isHidden && !(uploadView.subTitleLabel.text?.isEmpty ?? false)
            let textViewActive = !textContainerView.isHidden && !textView.text.isEmpty
            isEnabled = isEnabled && (uploadViewActive || textViewActive)
        }

        if let viewModel = usernameViewModel, viewModel.inputHandler.required {
            isEnabled = isEnabled && !(usernameTextFieldView.textField.text?.isEmpty ?? true)
            viewModel.inputHandler.changeValue(to: usernameTextFieldView.textField.text ?? "")
        }

        if let viewModel = passwordViewModel, viewModel.inputHandler.required {
            isEnabled = isEnabled && !(passwordView.textField.text?.isEmpty ?? true)
        }
        passwordViewModel?.inputHandler.changeValue(to: passwordView.textField.text ?? "")

        if let viewModel = derivationPathModel, viewModel.inputHandler.required {
            isEnabled = isEnabled && !(derivationPathField.text?.isEmpty ?? true)
        }

        nextButton?.isEnabled = isEnabled
        nextButton.backgroundColor = isEnabled ? UIColor(hex: "EF4136") : UIColor(hex: "EF4136").withAlphaComponent(0.5)
    }

    private func updateTextViewPlaceholder() {
        textPlaceholderLabel.isHidden = !textView.text.isEmpty
    }

    private func updateUploadView() {
        if let viewModel = sourceViewModel, !viewModel.inputHandler.normalizedValue.isEmpty {
            uploadView.subTitleLabel.textColor = UIColor(hex: "212121")
            uploadView.subTitleLabel.text = viewModel.inputHandler.normalizedValue
        } else {
            uploadView.subTitleLabel.textColor = UIColor(hex: "BBBBBB")
            uploadView.subTitleLabel.text = "粘贴或输入JSON"
        }
    }

    @IBAction private func actionExpand() {
        stackView.sendSubviewToBack(advancedContainerView)

        advancedContainerView.isHidden = !advancedControl.isActivated

        if advancedControl.isActivated {
            advancedAppearanceAnimator.animate(view: advancedContainerView, completionBlock: nil)
        } else {
            derivationPathField.resignFirstResponder()

            advancedDismissalAnimator.animate(view: advancedContainerView, completionBlock: nil)
        }
    }

    @objc private func actionNameTextFieldChanged() {
//        if usernameViewModel?.inputHandler.value != usernameTextFieldView.textField.text {
//            usernameTextFieldView.textField.text = usernameViewModel?.inputHandler.value
//        }

        updateNextButton()
    }

    @objc private func actionPasswordTextFieldChanged() {
//        if passwordViewModel?.inputHandler.value != passwordView.textField.text {
//            passwordView.textField.text = passwordViewModel?.inputHandler.value
//        }

        updateNextButton()
    }

    @IBAction private func actionDerivationPathTextFieldChanged() {
        if derivationPathModel?.inputHandler.value != derivationPathField.text {
            derivationPathField.text = derivationPathModel?.inputHandler.value
        }

        updateNextButton()
    }

    @objc private func actionUpload() {
        presenter.activateUpload()
    }

    @objc private func actionOpenSourceType() {
//        if sourceTypeView.actionControl.isActivated {
//            presenter.selectSourceType()
//        }
        presenter.selectSourceType()
    }

    @objc private func actionOpenCryptoType() {
        if cryptoTypeView.actionControl.isActivated {
            presenter.selectCryptoType()
        }
    }

    @objc private func actionOpenAddressType() {
        if networkTypeView.actionControl.isActivated {
            presenter.selectNetworkType()
        }
    }

    @IBAction private func actionNext() {
        presenter.proceed()
    }
}

extension AccountImportViewController: AccountImportViewProtocol {
    func setSource(type: AccountImportSource) {
        switch type {
        case .mnemonic:
            usernameSeparatorView.isHidden = false
            passwordView.isHidden = true
            passwordSeparatorView.isHidden = true
            passwordView.textField.text = nil
            passwordViewModel = nil

            derivationPathView.isHidden = false
            advancedContainerHeight.constant = Constants.advancedFullHeight

            uploadView.isHidden = true

            textContainerView.isHidden = false
            textContainerSeparatorView.isHidden = false
            
            self.navigationItem.rightBarButtonItem = nil
        case .seed:
            usernameSeparatorView.isHidden = false
            passwordView.isHidden = true
            passwordSeparatorView.isHidden = true
            passwordView.textField.text = nil
            passwordViewModel = nil

            derivationPathView.isHidden = false
            advancedContainerHeight.constant = Constants.advancedFullHeight

            uploadView.isHidden = true

            textContainerView.isHidden = false
            textContainerSeparatorView.isHidden = false
            
            self.navigationItem.rightBarButtonItem = nil
        case .keystore:
            usernameSeparatorView.isHidden = true
            
            passwordView.isHidden = false
            passwordSeparatorView.isHidden = false

            derivationPathView.isHidden = true
            advancedContainerHeight.constant = Constants.advancedTruncHeight

            uploadView.isHidden = false

            textContainerView.isHidden = true
            textView.text = nil
            textContainerSeparatorView.isHidden = true
            
            configNavigationItem()
        }

        warningView.isHidden = true

        advancedControl.deactivate(animated: false)
        advancedContainerView.isHidden = true

        let locale = localizationManager?.selectedLocale ?? Locale.current

        sourceTypeView.subTitleLabel.text = type.titleForLocale(locale)

        cryptoTypeView.actionControl.contentView.invalidateLayout()
        cryptoTypeView.actionControl.invalidateLayout()
    }

    func setSource(viewModel: InputViewModelProtocol) {
        sourceViewModel = viewModel

        if !uploadView.isHidden {
            updateUploadView()
        } else {
            textPlaceholderLabel.text = viewModel.placeholder
            textView.text = viewModel.inputHandler.value
        }

        updateTextViewPlaceholder()
        updateNextButton()
    }

    func setName(viewModel: InputViewModelProtocol) {
        usernameViewModel = viewModel

        usernameTextFieldView.textField.text = viewModel.inputHandler.value

        updateNextButton()
    }

    func setPassword(viewModel: InputViewModelProtocol) {
        passwordViewModel = viewModel

        passwordView.textField.text = viewModel.inputHandler.value

        updateNextButton()
    }

    func setSelectedCrypto(model: SelectableViewModel<TitleWithSubtitleViewModel>) {
        let title = "\(model.underlyingViewModel.title) | \(model.underlyingViewModel.subtitle)"

        cryptoTypeView.actionControl.contentView.subtitleLabelView.text = title

        cryptoTypeView.actionControl.showsImageIndicator = model.selectable
        cryptoTypeView.isUserInteractionEnabled = model.selectable

        if model.selectable {
            cryptoTypeView.applyEnabledStyle()
        } else {
            cryptoTypeView.applyDisabledStyle()
        }

        cryptoTypeView.actionControl.contentView.invalidateLayout()
        cryptoTypeView.actionControl.invalidateLayout()
    }

    func setSelectedNetwork(model: SelectableViewModel<IconWithTitleViewModel>) {
        networkTypeView.actionControl.contentView.subtitleImageView.image = model.underlyingViewModel.icon
        networkTypeView.actionControl.contentView.subtitleLabelView.text = model.underlyingViewModel.title

        networkTypeView.actionControl.showsImageIndicator = model.selectable
        networkTypeView.isUserInteractionEnabled = model.selectable

        if model.selectable {
            networkTypeView.applyEnabledStyle()
        } else {
            networkTypeView.applyDisabledStyle()
        }

        networkTypeView.actionControl.contentView.invalidateLayout()
        networkTypeView.actionControl.invalidateLayout()

        warningView.isHidden = true
    }

    func setDerivationPath(viewModel: InputViewModelProtocol) {
        derivationPathModel = viewModel

        derivationPathField.placeholder = viewModel.placeholder
        derivationPathField.text = viewModel.inputHandler.value
        derivationPathImageView.image = nil
    }

    func setUploadWarning(message: String) {
        warningLabel.text = message
        warningView.isHidden = false
    }

    func didCompleteSourceTypeSelection() {
        sourceTypeView.actionControl.deactivate(animated: true)
    }

    func didCompleteCryptoTypeSelection() {
        cryptoTypeView.actionControl.deactivate(animated: true)
    }

    func didCompleteAddressTypeSelection() {
        networkTypeView.actionControl.deactivate(animated: true)
    }

    func didValidateDerivationPath(_ status: FieldStatus) {
        derivationPathImageView.image = status.icon
    }
}

extension AccountImportViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter.validateDerivationPath()
        textField.resignFirstResponder()

        return false
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
//        guard let currentViewModel = derivationPathModel else {
//            return true
//        }

//        let shouldApply = currentViewModel.inputHandler.didReceiveReplacement(string, for: range)
//
//        if !shouldApply, textField.text != currentViewModel.inputHandler.value {
//            textField.text = currentViewModel.inputHandler.value
//        }
        
//        return shouldApply
//        return true
        
        let viewModel: InputViewModelProtocol?

        if textField === usernameTextFieldView.textField {
            viewModel = usernameViewModel
        } else {
            viewModel = passwordViewModel
        }

        guard let currentViewModel = viewModel else {
            return true
        }
//        currentViewModel.inputHandler.didReceiveReplacement(string, for: range)
//        let shouldApply = currentViewModel.inputHandler.didReceiveReplacement(string, for: range)
        let shouldApply = true
        

        if !shouldApply, textField.text != currentViewModel.inputHandler.value {
            textField.text = currentViewModel.inputHandler.value
        }

        return shouldApply
    }
}

extension AccountImportViewController: AnimatedTextFieldDelegate {
    func animatedTextFieldShouldReturn(_ textField: AnimatedTextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func animatedTextField(_ textField: AnimatedTextField,
                           shouldChangeCharactersIn range: NSRange,
                           replacementString string: String) -> Bool {
        let viewModel: InputViewModelProtocol?

        if textField === usernameTextFieldView.textField {
            viewModel = usernameViewModel
        } else {
            viewModel = passwordViewModel
        }

        guard let currentViewModel = viewModel else {
            return true
        }

        let shouldApply = currentViewModel.inputHandler.didReceiveReplacement(string, for: range)

        if !shouldApply, textField.text != currentViewModel.inputHandler.value {
            textField.text = currentViewModel.inputHandler.value
        }

        return shouldApply
    }
}

extension AccountImportViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != sourceViewModel?.inputHandler.value {
            textView.text = sourceViewModel?.inputHandler.value
        }

        updateTextViewPlaceholder()
        updateNextButton()
    }

    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if text == String.returnKey {
            textView.resignFirstResponder()
            return false
        }

        guard let model = sourceViewModel else {
            return false
        }

        let shouldApply = model.inputHandler.didReceiveReplacement(text, for: range)

        if !shouldApply, textView.text != model.inputHandler.value {
            textView.text = model.inputHandler.value
        }

        return shouldApply
    }
}

extension AccountImportViewController: KeyboardAdoptable {
    func updateWhileKeyboardFrameChanging(_ frame: CGRect) {
        let localKeyboardFrame = view.convert(frame, from: nil)
        let bottomInset = view.bounds.height - localKeyboardFrame.minY
        let scrollViewOffset = view.bounds.height - scrollView.frame.maxY

        var contentInsets = scrollView.contentInset
        contentInsets.bottom = max(0.0, bottomInset - scrollViewOffset)
        scrollView.contentInset = contentInsets

        if contentInsets.bottom > 0.0 {
            let targetView: UIView?

            if textView.isFirstResponder {
                targetView = textView
            } else if usernameTextFieldView.textField.isFirstResponder {
                targetView = usernameView
            } else if passwordView.textField.isFirstResponder {
                targetView = passwordView
            } else if derivationPathField.isFirstResponder {
                targetView = derivationPathView
            } else {
                targetView = nil
            }

            if let firstResponderView = targetView {
                let fieldFrame = scrollView.convert(firstResponderView.frame,
                                                    from: firstResponderView.superview)

                scrollView.scrollRectToVisible(fieldFrame, animated: true)
            }
        }
    }
}

extension AccountImportViewController: Localizable {
    func applyLocalization() {
        if isViewLoaded {
            setupLocalization()
            view.setNeedsLayout()
        }
    }
}
