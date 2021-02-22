import UIKit
import SafariServices

final class PurchaseViewController: SFSafariViewController {
    var presenter: PurchasePresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        presenter.setup()
    }

    private func configure() {
        preferredControlTintColor = UIColor.white
        preferredBarTintColor = UIColor(red: 0.096, green: 0.096, blue: 0.096, alpha: 1.0)
    }
}

extension PurchaseViewController: PurchaseViewProtocol {}
