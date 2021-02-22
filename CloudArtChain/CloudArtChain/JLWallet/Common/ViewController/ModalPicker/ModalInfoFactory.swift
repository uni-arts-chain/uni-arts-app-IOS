import UIKit
import SoraFoundation
import SoraUI
import CommonWallet

struct ModalInfoFactory {
    static let rowHeight: CGFloat = 50.0
    static let headerHeight: CGFloat = 40.0
    static let footerHeight: CGFloat = 0.0

    static func createFromBalanceContext(_ balanceContext: BalanceContext,
                                         amountFormatter: LocalizableResource<NumberFormatter>)
        -> UIViewController {

        let viewController: ModalPickerViewController<DetailsDisplayTableViewCell, TitleWithSubtitleViewModel>
            = ModalPickerViewController(nib: R.nib.modalPickerViewController)
        viewController.cellHeight = Self.rowHeight
        viewController.headerHeight = Self.headerHeight
        viewController.footerHeight = Self.footerHeight
        viewController.allowsSelection = false
        viewController.hasCloseItem = true

        viewController.localizedTitle = LocalizableResource { locale in
            "Frozen"
        }

        viewController.cellNib = UINib(nibName: "DetailsDisplayTableViewCell", bundle: Bundle.main)
        viewController.modalPresentationStyle = .custom

        let viewModels = createViewModelsForContext(balanceContext,
                                                    amountFormatter: amountFormatter)
        viewController.viewModels = viewModels

        let factory = ModalSheetPresentationFactory(configuration: ModalSheetPresentationConfiguration.fearless)
        viewController.modalTransitioningFactory = factory

        let height = viewController.headerHeight + CGFloat(viewModels.count) * viewController.cellHeight +
            viewController.footerHeight
        viewController.preferredContentSize = CGSize(width: 0.0, height: height)

        viewController.localizationManager = LocalizationManager.shared

        return viewController
    }

    static func createTransferExistentialState(_ state: TransferExistentialState,
                                               amountFormatter: LocalizableResource<NumberFormatter>)
        -> UIViewController {
        let viewController: ModalPickerViewController<DetailsDisplayTableViewCell, TitleWithSubtitleViewModel>
            = ModalPickerViewController(nib: R.nib.modalPickerViewController)
        viewController.cellHeight = Self.rowHeight
        viewController.headerHeight = Self.headerHeight
        viewController.footerHeight = Self.footerHeight
        viewController.allowsSelection = false
        viewController.hasCloseItem = true

        viewController.localizedTitle = LocalizableResource { locale in
            "Balance details"
        }

        viewController.cellNib = UINib(nibName: "DetailsDisplayTableViewCell", bundle: Bundle.main)
        viewController.modalPresentationStyle = .custom

        let viewModels = createTransferStateViewModels(state,
                                                       amountFormatter: amountFormatter)
        viewController.viewModels = viewModels

        let factory = ModalSheetPresentationFactory(configuration: ModalSheetPresentationConfiguration.fearless)
        viewController.modalTransitioningFactory = factory

        let height = viewController.headerHeight + CGFloat(viewModels.count) * viewController.cellHeight +
            viewController.footerHeight
        viewController.preferredContentSize = CGSize(width: 0.0, height: height)

        viewController.localizationManager = LocalizationManager.shared

        return viewController
    }

    private static func createTransferStateViewModels(_ state: TransferExistentialState,
                                                      amountFormatter: LocalizableResource<NumberFormatter>)
        -> [LocalizableResource<TitleWithSubtitleViewModel>] {
        [
            LocalizableResource { locale in
                let title = "Available balance"
                let details = amountFormatter.value(for: locale)
                    .string(from: state.availableAmount as NSNumber) ?? ""

                return TitleWithSubtitleViewModel(title: title, subtitle: details)
            },

            LocalizableResource { locale in
                let title = "Total balance"
                let details = amountFormatter.value(for: locale)
                    .string(from: state.totalAmount as NSNumber) ?? ""

                return TitleWithSubtitleViewModel(title: title, subtitle: details)
            },

            LocalizableResource { locale in
                let title = "Total after transfer"
                let details = amountFormatter.value(for: locale)
                    .string(from: state.totalAfterTransfer as NSNumber) ?? ""

                return TitleWithSubtitleViewModel(title: title, subtitle: details)
            },

            LocalizableResource { locale in
                let title = "Existential deposit"
                let details = amountFormatter.value(for: locale)
                    .string(from: state.existentialDeposit as NSNumber) ?? ""

                return TitleWithSubtitleViewModel(title: title, subtitle: details)
            }
        ]
    }

    private static func createViewModelsForContext(_ balanceContext: BalanceContext,
                                                   amountFormatter: LocalizableResource<NumberFormatter>)
        -> [LocalizableResource<TitleWithSubtitleViewModel>] {
        [
            LocalizableResource { locale in
                let title = "Locked"
                let details = amountFormatter.value(for: locale)
                    .string(from: balanceContext.locked as NSNumber) ?? ""

                return TitleWithSubtitleViewModel(title: title, subtitle: details)
            },

            LocalizableResource { locale in
                let title = "Bonded"
                let details = amountFormatter.value(for: locale)
                    .string(from: balanceContext.bonded as NSNumber) ?? ""

                return TitleWithSubtitleViewModel(title: title, subtitle: details)
            },

            LocalizableResource { locale in
                let title = "Reserved"
                let details = amountFormatter.value(for: locale)
                    .string(from: balanceContext.reserved as NSNumber) ?? ""

                return TitleWithSubtitleViewModel(title: title, subtitle: details)
            },

            LocalizableResource { locale in
                let title = "Redeemable"
                let details = amountFormatter.value(for: locale)
                    .string(from: balanceContext.redeemable as NSNumber) ?? ""

                return TitleWithSubtitleViewModel(title: title, subtitle: details)
            },

            LocalizableResource { locale in
                let title = "Unbonding"
                let details = amountFormatter.value(for: locale)
                    .string(from: balanceContext.unbonding as NSNumber) ?? ""

                return TitleWithSubtitleViewModel(title: title, subtitle: details)
            }
        ]
    }
}
