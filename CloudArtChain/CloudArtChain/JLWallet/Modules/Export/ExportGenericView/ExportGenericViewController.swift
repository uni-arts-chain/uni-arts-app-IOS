import UIKit
import SoraFoundation
import SoraUI

final class ExportGenericViewController: JLBaseViewController {
    private struct Constants {
        static let verticalSpacing: CGFloat = 16.0
        static let topInset: CGFloat = 12.0
    }

    var presenter: ExportGenericPresenterProtocol!

    let accessoryOptionTitle: LocalizableResource<String>?
    let mainOptionTitle: LocalizableResource<String>?
    let binder: ExportGenericViewModelBinding
    let uiFactory: UIFactoryProtocol

    private var mainActionButton: TriangularedButton?
    private var accessoryActionButton: UIButton?
    private var containerView: ScrollableContainerView!
    private var titleView: UIView!
    private var expandableControl: ExpandableActionControl!
    private var advancedContainerView: UIView?
    private var optionView: UIView?

    private var viewModel: ExportGenericViewModelProtocol?
    var snapshotNotice: Bool = false

    var advancedAppearanceAnimator = TransitionAnimator(type: .push,
                                                        duration: 0.35,
                                                        subtype: .fromBottom,
                                                        curve: .easeOut)

    var advancedDismissalAnimator = TransitionAnimator(type: .push,
                                                       duration: 0.35,
                                                       subtype: .fromTop,
                                                       curve: .easeIn)

    init(uiFactory: UIFactoryProtocol,
         binder: ExportGenericViewModelBinding,
         mainTitle: LocalizableResource<String>?,
         accessoryTitle: LocalizableResource<String>?) {
        self.uiFactory = uiFactory
        self.binder = binder
        self.mainOptionTitle = mainTitle
        self.accessoryOptionTitle = accessoryTitle

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white

        if mainOptionTitle != nil {
            setupMainActionButton()
        }

        if accessoryOptionTitle != nil {
            setupAccessoryButton()
        }

        setupContainerView()

        setupSourceTypeView()
        setupExpandableActionView()
        setupAnimatingView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.snapshotNotice {
            let snapshotView = JLExportKeystoreSnapshotView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width - 40.0 * 2, height: 280.0), understoodBlock: { [weak self] in
                self?.snapshotNotice = true
            })
            snapshotView.layer.cornerRadius = 5.0
            snapshotView.layer.masksToBounds = true
            JLAlert.alertCustomView(snapshotView, maxWidth: UIScreen.main.bounds.size.width - 40.0 * 2)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackItem()
        view.backgroundColor = .white;
        
        setupLocalization()

        presenter.setup()
    }

    private func setupLocalization() {
        guard let locale = localizationManager?.selectedLocale else {
            return
        }

        title = "备份助记词"
        expandableControl.titleLabel.text = "Advanced"

        mainActionButton?.imageWithTitleView?.title = mainOptionTitle?.value(for: locale)
        updateFromViewModel(locale)
    }

    private func updateFromViewModel(_ locale: Locale) {
        guard let viewModel = viewModel else {
            return
        }

        if let optionView = optionView {
            containerView.stackView.removeArrangedSubview(optionView)
            optionView.removeFromSuperview()
        }

        let newOptionView = viewModel.accept(binder: binder, locale: locale)
        (newOptionView as? TitledMnemonicView)?.contentView.wordTitleColorInColumn = .black
        newOptionView.backgroundColor = .white
        newOptionView.translatesAutoresizingMaskIntoConstraints = false

        insert(subview: newOptionView, after: titleView)

        newOptionView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                             constant: -2.0 * UIConstants.horizontalInset).isActive = true

        self.optionView = newOptionView

        if let advancedContainerView = advancedContainerView {
            containerView.stackView.removeArrangedSubview(advancedContainerView)
            advancedContainerView.removeFromSuperview()
        }

        setupAdvancedContainerView(with: viewModel, locale: locale)

        advancedContainerView?.isHidden = !expandableControl.isActivated
    }

    @objc private func actionMain() {
        presenter.activateExport()
    }

    @objc private func actionAccessory() {
        presenter.activateAccessoryOption()
    }

    @objc private func actionToggleExpandableControl() {
        guard let advancedContainerView = advancedContainerView else {
            return
        }

        containerView.stackView.sendSubviewToBack(advancedContainerView)

        advancedContainerView.isHidden = !self.expandableControl.isActivated

        if expandableControl.isActivated {
            advancedAppearanceAnimator.animate(view: advancedContainerView, completionBlock: nil)
        } else {
            advancedDismissalAnimator.animate(view: advancedContainerView, completionBlock: nil)
        }
    }
}

extension ExportGenericViewController {
    private func setupMainActionButton() {
        let button = uiFactory.createMainActionButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                        constant: UIConstants.horizontalInset).isActive = true

        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                         constant: -UIConstants.horizontalInset).isActive = true

        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                       constant: -UIConstants.actionBottomInset).isActive = true

        button.heightAnchor.constraint(equalToConstant: UIConstants.actionHeight).isActive = true

        button.addTarget(self,
                         action: #selector(actionMain),
                         for: .touchUpInside)

        self.mainActionButton = button
    }

    private func setupAnimatingView() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        containerView.stackView.insertSubview(view, at: 0)

        view.leadingAnchor.constraint(equalTo: containerView.stackView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: containerView.stackView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: expandableControl.bottomAnchor).isActive = true
    }

    private func setupAccessoryButton() {
        let button = UIButton(type: .custom)
        button.setTitle("下一步", for: .normal)
        button.backgroundColor = UIColor(hex: "EF4136")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 23.0
        button.layer.masksToBounds = true
        view.addSubview(button)

        button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                        constant: UIConstants.horizontalInset).isActive = true

        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                         constant: -UIConstants.horizontalInset).isActive = true

        if let mainButton = mainActionButton {
            button.bottomAnchor.constraint(equalTo: mainButton.topAnchor,
                                           constant: -UIConstants.mainAccessoryActionsSpacing).isActive = true
        } else {
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                           constant: -UIConstants.actionBottomInset).isActive = true
        }

        button.heightAnchor.constraint(equalToConstant: UIConstants.jlActionHeight).isActive = true

        button.addTarget(self,
                         action: #selector(actionAccessory),
                         for: .touchUpInside)

        self.accessoryActionButton = button
    }

    private func setupContainerView() {
        containerView = ScrollableContainerView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        containerView.stackView.spacing = Constants.verticalSpacing

        containerView.topAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

        containerView.leadingAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true

        containerView.trailingAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        var inset = containerView.scrollView.contentInset
        inset.top = Constants.topInset
        containerView.scrollView.contentInset = inset

        if let accessoryButton = accessoryActionButton {
            containerView.bottomAnchor
                .constraint(equalTo: accessoryButton.topAnchor,
                            constant: -UIConstants.mainAccessoryActionsSpacing).isActive = true
        } else if let mainButton = mainActionButton {
            containerView.bottomAnchor
                .constraint(equalTo: mainButton.topAnchor,
                            constant: -UIConstants.mainAccessoryActionsSpacing).isActive = true
        } else {
            containerView.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }

    private func setupSourceTypeView() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.stackView.addArrangedSubview(view)
        containerView.stackView.setCustomSpacing(Constants.verticalSpacing, after: view)

        view.widthAnchor.constraint(equalTo: self.view.widthAnchor,
                                    constant: -2.0 * UIConstants.horizontalInset).isActive = true

        view.heightAnchor.constraint(equalToConstant: UIConstants.triangularedTitleViewHeight).isActive = true

        self.titleView = view
        
        let titleLabel = UILabel()
        titleLabel.text = "抄写下你的钱包助记词"
        titleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        titleLabel.textColor = UIColor(hex: "34394C")
        titleLabel.textAlignment = .center
        self.titleView.addSubview(titleLabel)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "助记词用于恢复钱包或重置钱包密码，将它准确的抄写到纸上，并存放在只有你知道的安全的地方。"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        subtitleLabel.textColor = UIColor(hex: "909090")
        subtitleLabel.textAlignment = .left
        subtitleLabel.numberOfLines = 0
        self.titleView.addSubview(subtitleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.titleView)
            make.top.equalTo(20.0)
        }
        subtitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10.0)
            make.bottom.equalTo(self.titleView)
            make.right.equalTo(-10.0)
        }
    }

    private func setupExpandableActionView() {
        let view = uiFactory.createExpandableActionControl()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.stackView.addArrangedSubview(view)

        containerView.stackView.setCustomSpacing(0.0, after: view)

        view.widthAnchor.constraint(equalTo: self.view.widthAnchor,
                                    constant: -2.0 * UIConstants.horizontalInset).isActive = true

        view.heightAnchor.constraint(equalToConstant: UIConstants.expandableViewHeight).isActive = true

        view.addTarget(self,
                       action: #selector(actionToggleExpandableControl),
                       for: .touchUpInside)

        self.expandableControl = view
        self.expandableControl.isHidden = true

        let bottomSeparator = uiFactory.createSeparatorView()
        bottomSeparator.backgroundColor = .white
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        containerView.stackView.addArrangedSubview(bottomSeparator)

        bottomSeparator.widthAnchor.constraint(equalTo: self.view.widthAnchor,
                                               constant: -2.0 * UIConstants.horizontalInset).isActive = true
        bottomSeparator.heightAnchor.constraint(equalToConstant: UIConstants.formSeparatorWidth).isActive = true
    }

    private func setupAdvancedContainerView(with viewModel: ExportGenericViewModelProtocol, locale: Locale) {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        self.containerView.stackView.addArrangedSubview(containerView)

        containerView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                            constant: -2.0 * UIConstants.horizontalInset).isActive = true

        let cryptoTypeView = setupCryptoTypeView(viewModel.cryptoType,
                                                 advancedContainerView: containerView,
                                                 locale: locale)

        var subviews = [cryptoTypeView]

        if let derivationPath = viewModel.derivationPath {
            let derivationPathView = setupDerivationView(derivationPath,
                                                         advancedContainerView: containerView,
                                                         locale: locale)
            subviews.append(derivationPathView)
        }

        let networkTypeView = setupNetworkView(chain: viewModel.networkType,
                                               advancedContainerView: containerView,
                                               locale: locale)

        subviews.append(networkTypeView)

        self.advancedContainerView = containerView

        _ = subviews.reduce(nil) { (anchorView: UIView?, subview: UIView) in
            subview.leadingAnchor
                .constraint(equalTo: containerView.leadingAnchor, constant: 0.0).isActive = true
            subview.trailingAnchor
                .constraint(equalTo: containerView.trailingAnchor, constant: 0.0).isActive = true
            subview.heightAnchor
                .constraint(equalToConstant: UIConstants.triangularedViewHeight).isActive = true

            if let anchorView = anchorView {
                subview.topAnchor
                    .constraint(equalTo: anchorView.bottomAnchor,
                                constant: Constants.verticalSpacing).isActive = true
            } else {
                subview.topAnchor
                    .constraint(equalTo: containerView.topAnchor).isActive = true
            }

            return subview
        }

        containerView.bottomAnchor.constraint(equalTo: networkTypeView.bottomAnchor,
                                              constant: Constants.verticalSpacing).isActive = true
    }

    private func setupCryptoTypeView(_ cryptoType: CryptoType,
                                     advancedContainerView: UIView,
                                     locale: Locale) -> UIView {

        let cryptoView = uiFactory.createDetailsView(with: .largeIconTitleSubtitle, filled: true)
        cryptoView.translatesAutoresizingMaskIntoConstraints = false
        advancedContainerView.addSubview(cryptoView)

        cryptoView.title = "Keypair crypto type"

        cryptoView.subtitle = cryptoType.titleForLocale(locale) + " | " + cryptoType.subtitleForLocale(locale)

        return cryptoView
    }

    private func setupDerivationView(_ path: String,
                                     advancedContainerView: UIView,
                                     locale: Locale) -> UIView {
        let derivationPathView = uiFactory.createDetailsView(with: .largeIconTitleSubtitle, filled: true)
        derivationPathView.translatesAutoresizingMaskIntoConstraints = false
        advancedContainerView.addSubview(derivationPathView)

        derivationPathView.title = "Secret derivation path"
        derivationPathView.subtitle = path

        return derivationPathView
    }

    private func setupNetworkView(chain: Chain,
                                  advancedContainerView: UIView,
                                  locale: Locale) -> UIView {
        let networkView = uiFactory.createDetailsView(with: .smallIconTitleSubtitle, filled: true)
        networkView.translatesAutoresizingMaskIntoConstraints = false
        advancedContainerView.addSubview(networkView)

        networkView.title = "Network"
        networkView.subtitle = chain.titleForLocale(locale)
        networkView.iconImage = chain.icon

        return networkView
    }

    private func insert(subview: UIView, after view: UIView) {
        guard let index = containerView.stackView.arrangedSubviews
                .firstIndex(where: { $0 === view}) else {
            return
        }

        containerView.stackView.insertArrangedSubview(subview, at: index+1)
    }
}

extension ExportGenericViewController: Localizable {
    func applyLocalization() {
        if isViewLoaded {
            setupLocalization()
            view.setNeedsLayout()
        }
    }
}

extension ExportGenericViewController: ExportGenericViewProtocol {
    func set(viewModel: ExportGenericViewModelProtocol) {
        self.viewModel = viewModel

        guard let locale = localizationManager?.selectedLocale else {
            return
        }

        updateFromViewModel(locale)
    }
}
