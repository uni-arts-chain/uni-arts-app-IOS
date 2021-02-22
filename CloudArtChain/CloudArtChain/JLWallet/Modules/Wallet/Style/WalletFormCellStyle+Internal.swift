import Foundation
import CommonWallet

extension WalletFormCellStyle {
    static var fearless: WalletFormCellStyle {
        let title = WalletTextStyle(font: UIFont.p1Paragraph,
                                    color: UIColor.lightGray)
        let details = WalletTextStyle(font: UIFont.p1Paragraph,
                                      color: UIColor.white)

        let link = WalletLinkStyle(normal: UIColor.white,
                                   highlighted: UIColor.blue)

        return WalletFormCellStyle(title: title,
                                   details: details,
                                   link: link,
                                   separator: UIColor.darkGray)
    }
}
