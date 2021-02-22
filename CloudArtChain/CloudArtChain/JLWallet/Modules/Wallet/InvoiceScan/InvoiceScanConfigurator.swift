import Foundation
import CommonWallet
import IrohaCrypto

final class InvoiceScanConfigurator {
    let searchEngine: InvoiceLocalSearchEngineProtocol

    init(networkType: SNAddressType) {
        searchEngine = InvoiceScanLocalSearchEngine(networkType: networkType)
    }

    let style: InvoiceScanViewStyleProtocol = {
        let title = WalletTextStyle(font: UIFont.h3Title, color: UIColor.white)
        let message = WalletTextStyle(font: UIFont.h3Title, color: UIColor.white)

        let uploadTitle = WalletTextStyle(font: UIFont.h5Title, color: UIColor.white)
        let upload = WalletRoundedButtonStyle(background: UIColor.blue, title: uploadTitle)

        return InvoiceScanViewStyle(background: UIColor.black,
                                    title: title,
                                    message: message,
                                    maskBackground: UIColor.black.withAlphaComponent(0.8),
                                    upload: upload)
    }()

    func configure(builder: InvoiceScanModuleBuilderProtocol) {
        builder
            .with(viewStyle: style)
            .with(localSearchEngine: searchEngine)
    }
}
