import UIKit

extension UIAlertController {
    static func presentAccountOptions(_ address: String,
                                      chain: Chain,
                                      locale: Locale,
                                      copyClosure: @escaping () -> Void,
                                      urlClosure: @escaping  (URL) -> Void) -> UIAlertController {
        let title = "Account"
        let alertController = UIAlertController(title: title,
                                                message: nil,
                                                preferredStyle: .actionSheet)

        let copyTitle = "Copy address"

        let copy = UIAlertAction(title: copyTitle, style: .default) { _ in
            copyClosure()
        }

        alertController.addAction(copy)

        if let url = chain.polkascanAddressURL(address) {
            let polkascanTitle = "View in Polkascan"
            let viewPolkascan = UIAlertAction(title: polkascanTitle, style: .default) { _ in
                urlClosure(url)
            }

            alertController.addAction(viewPolkascan)
        }

        if let url = chain.subscanAddressURL(address) {
            let subscanTitle = "View in Subscan"
            let viewSubscan = UIAlertAction(title: subscanTitle, style: .default) { _ in
                urlClosure(url)
            }

            alertController.addAction(viewSubscan)
        }

        let cancelTitle = "Cancel"
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)

        alertController.addAction(cancel)

        return alertController
    }
}
