import Foundation
import SoraUI
import SoraFoundation
import IrohaCrypto
import FearlessUtils

struct ModalPickerFactory {
    static func createPickerForList(_ types: [CryptoType],
                                    selectedType: CryptoType?,
                                    delegate: ModalPickerViewControllerDelegate?,
                                    context: AnyObject?) -> UIViewController? {
        guard types.count > 0 else {
            return nil
        }

        let viewController: ModalPickerViewController<TitleWithSubtitleTableViewCell, TitleWithSubtitleViewModel>
            = ModalPickerViewController(nib: R.nib.modalPickerViewController)

        viewController.localizedTitle = LocalizableResource { locale in
            "Keypair crypto type"
        }

        viewController.cellNib = UINib(nibName: "TitleWithSubtitleTableViewCell", bundle: Bundle.main)
        viewController.delegate = delegate
        viewController.modalPresentationStyle = .custom
        viewController.context = context

        if let selectedType = selectedType {
            viewController.selectedIndex = types.firstIndex(of: selectedType) ?? 0
        } else {
            viewController.selectedIndex = 0
        }

        viewController.viewModels = types.map { type in
            LocalizableResource { locale in
                TitleWithSubtitleViewModel(title: type.titleForLocale(locale),
                                           subtitle: type.subtitleForLocale(locale))
            }
        }

        let factory = ModalSheetPresentationFactory(configuration: ModalSheetPresentationConfiguration.fearless)
        viewController.modalTransitioningFactory = factory

        let height = viewController.headerHeight + CGFloat(types.count) * viewController.cellHeight +
            viewController.footerHeight
        viewController.preferredContentSize = CGSize(width: 0.0, height: height)

        viewController.localizationManager = LocalizationManager.shared

        return viewController
    }

    static func createPickerForList(_ types: [Chain],
                                    selectedType: Chain?,
                                    delegate: ModalPickerViewControllerDelegate?,
                                    context: AnyObject?) -> UIViewController? {
        guard types.count > 0 else {
            return nil
        }

        let viewController: ModalPickerViewController<IconWithTitleTableViewCell, IconWithTitleViewModel>
            = ModalPickerViewController(nib: R.nib.modalPickerViewController)

        viewController.localizedTitle = LocalizableResource { locale in
            "Choose network"
        }

        viewController.cellNib = UINib(nibName: "IconWithTitleTableViewCell", bundle: Bundle.main)
        viewController.delegate = delegate
        viewController.modalPresentationStyle = .custom
        viewController.context = context

        if let selectedType = selectedType {
            viewController.selectedIndex = types.firstIndex(of: selectedType) ?? 0
        } else {
            viewController.selectedIndex = 0
        }

        viewController.viewModels = types.map { type in
            LocalizableResource { locale in
                IconWithTitleViewModel(icon: type.icon,
                                       title: type.titleForLocale(locale))
            }
        }

        let factory = ModalSheetPresentationFactory(configuration: ModalSheetPresentationConfiguration.fearless)
        viewController.modalTransitioningFactory = factory

        let height = viewController.headerHeight + CGFloat(types.count) * viewController.cellHeight +
            viewController.footerHeight
        viewController.preferredContentSize = CGSize(width: 0.0, height: height)

        viewController.localizationManager = LocalizationManager.shared

        return viewController
    }

    static func createPickerForList(_ types: [AccountImportSource],
                                    selectedType: AccountImportSource?,
                                    delegate: ModalPickerViewControllerDelegate?,
                                    context: AnyObject?) -> UIViewController? {
        guard types.count > 0 else {
            return nil
        }

        let viewController: ModalPickerViewController<TitleWithSubtitleTableViewCell, TitleWithSubtitleViewModel>
            = ModalPickerViewController(nib: R.nib.modalPickerViewController)

        viewController.localizedTitle = LocalizableResource { locale in
            "导入类型"
        }

        viewController.cellNib = UINib(nibName: "TitleWithSubtitleTableViewCell", bundle: Bundle.main)
        viewController.delegate = delegate
        viewController.modalPresentationStyle = .custom
        viewController.context = context

        if let selectedType = selectedType {
            viewController.selectedIndex = types.firstIndex(of: selectedType) ?? 0
        } else {
            viewController.selectedIndex = 0
        }

        viewController.viewModels = types.map { type in
            LocalizableResource { locale in
                TitleWithSubtitleViewModel(title: type.titleForLocale(locale),
                                           subtitle: "")
            }
        }

        let factory = ModalSheetPresentationFactory(configuration: ModalSheetPresentationConfiguration.fearless)
        viewController.modalTransitioningFactory = factory

        let height = viewController.headerHeight + CGFloat(types.count) * viewController.cellHeight +
            viewController.footerHeight
        viewController.preferredContentSize = CGSize(width: 0.0, height: height)

        viewController.localizationManager = LocalizationManager.shared

        return viewController
    }

    static func createPickerList(_ accounts: [AccountItem],
                                 selectedAccount: AccountItem?,
                                 addressType: SNAddressType,
                                 delegate: ModalPickerViewControllerDelegate?,
                                 context: AnyObject?) -> UIViewController? {

        let viewController: ModalPickerViewController<AccountPickerTableViewCell, AccountPickerViewModel>
            = ModalPickerViewController(nib: R.nib.modalPickerViewController)

        viewController.localizedTitle = LocalizableResource { locale in
            "Accounts"
        }

        viewController.icon = addressType.icon
        viewController.actionType = .add

        viewController.cellNib = UINib(nibName: "AccountPickerTableViewCell", bundle: Bundle.main)
        viewController.delegate = delegate
        viewController.modalPresentationStyle = .custom
        viewController.context = context

        if let selectedAccount = selectedAccount {
            viewController.selectedIndex = accounts.firstIndex(of: selectedAccount) ?? NSNotFound
        } else {
            viewController.selectedIndex = NSNotFound
        }

        let iconGenerator = PolkadotIconGenerator()

        viewController.viewModels = accounts.compactMap { account in
            let viewModel: AccountPickerViewModel
            if let icon = try? iconGenerator.generateFromAddress(account.address) {
                viewModel = AccountPickerViewModel(title: account.username, icon: icon)
            } else {
                viewModel = AccountPickerViewModel(title: account.username, icon: EmptyAccountIcon())
            }

            return LocalizableResource { _ in viewModel }
        }

        let factory = ModalSheetPresentationFactory(configuration: ModalSheetPresentationConfiguration.fearless)
        viewController.modalTransitioningFactory = factory

        let height = viewController.headerHeight + CGFloat(accounts.count) * viewController.cellHeight +
            viewController.footerHeight
        viewController.preferredContentSize = CGSize(width: 0.0, height: height)

        viewController.localizationManager = LocalizationManager.shared

        return viewController
    }
}
