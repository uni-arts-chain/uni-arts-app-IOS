import Foundation
import CommonWallet

final class TransferConfirmBinder: WalletFormViewModelBinderOverriding {
    lazy private var headerStyle: WalletFormTitleIconViewStyle = {
        let title = WalletTextStyle(font: UIFont.p1Paragraph,
                                    color: UIColor.white)
        let contentInsets = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 16.0, right: 0.0)
        let separator = WalletStrokeStyle(color: UIColor.darkGray,
                                          lineWidth: 1.0)

        return WalletFormTitleIconViewStyle(title: title,
                                            separatorStyle: separator,
                                            contentInsets: contentInsets,
                                            horizontalSpacing: 6.0)
    }()

    lazy private var detailsStyle: WalletFormDetailsViewStyle = {
        let title = WalletTextStyle(font: UIFont.p1Paragraph,
                                    color: UIColor.lightGray)
        let details = WalletTextStyle(font: UIFont.p1Paragraph,
                                      color: UIColor.white)
        let separator = WalletStrokeStyle(color: UIColor.darkGray,
                                          lineWidth: 1.0)
        let contentInsets = UIEdgeInsets(top: 14.0, left: 0.0, bottom: 14.0, right: 0.0)

        return WalletFormDetailsViewStyle(title: title,
                                          separatorStyle: separator,
                                          contentInsets: contentInsets,
                                          details: details)
    }()

    func bind(viewModel: WalletFormDetailsHeaderModel,
              to view: WalletFormTitleIconViewProtocol) -> Bool {
        view.style = headerStyle
        let mappedViewMode = MultilineTitleIconViewModel(text: viewModel.title,
                                                         icon: viewModel.icon)

        view.bind(viewModel: mappedViewMode)

        return true
    }

    func bind(viewModel: WalletNewFormDetailsViewModel, to view: WalletFormDetailsViewProtocol) -> Bool {
        view.style = detailsStyle
        view.bind(viewModel: viewModel)
        return true
    }
}
