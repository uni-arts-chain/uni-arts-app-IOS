import Foundation
import CommonWallet

struct WalletCommonStyleConfigurator {
    let navigationBarStyle: WalletNavigationBarStyleProtocol = {
        var navigationBarStyle = WalletNavigationBarStyle(barColor: .clear,
                                                          shadowColor: .clear,
                                                          itemTintColor: UIColor.white,
                                                          titleColor: UIColor.white,
                                                          titleFont: UIFont.h3Title)
        return navigationBarStyle
    }()

    let accessoryStyle: WalletAccessoryStyleProtocol = {
        let title = WalletTextStyle(font: UIFont.p1Paragraph,
                                    color: UIColor.white)

        let buttonTitle = WalletTextStyle(font: UIFont.h5Title,
                                          color: UIColor.white)

        let buttonStyle = WalletRoundedButtonStyle(background: UIColor.blue,
                                                   title: buttonTitle)

        let separator = WalletStrokeStyle(color: .clear, lineWidth: 0.0)

        return WalletAccessoryStyle(title: title,
                                    action: buttonStyle,
                                    separator: separator,
                                    background: UIColor.black)
    }()
}

extension WalletCommonStyleConfigurator {
    func configure(builder: WalletStyleBuilderProtocol) {
        builder
            .with(background: UIColor.black)
            .with(navigationBarStyle: navigationBarStyle)
            .with(header1: UIFont.h1Title)
            .with(header2: UIFont.h2Title)
            .with(header3: UIFont.h3Title)
            .with(header4: UIFont.h4Title)
            .with(bodyBold: UIFont.h5Title)
            .with(bodyRegular: UIFont.p1Paragraph)
            .with(small: UIFont.p2Paragraph)
            .with(keyboardIcon: UIImage(named: "iconKeyboardOff"))
            .with(caretColor: UIColor.white)
            .with(closeIcon: UIImage(named: "iconClose"))
            .with(shareIcon: UIImage(named: "iconShare"))
            .with(accessoryStyle: accessoryStyle)
            .with(formCellStyle: WalletFormCellStyle.fearless)
    }
}
