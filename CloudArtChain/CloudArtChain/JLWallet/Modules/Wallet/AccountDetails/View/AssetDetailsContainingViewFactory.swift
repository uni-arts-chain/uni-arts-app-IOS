import UIKit
import CommonWallet

struct AssetDetailsContainingViewFactory: AccountDetailsContainingViewFactoryProtocol {
    func createView() -> BaseAccountDetailsContainingView {
        AssetDetailsView()
    }
}
