import Foundation
import CommonWallet

public enum WalletPriceChangeViewModel {
    case goingUp(displayValue: String)
    case goingDown(displayValue: String)
}

public final class WalletAssetViewModel: AssetViewModelProtocol {
    public var itemHeight: CGFloat { WalletAccountListConstants.assetCellHeight }
    public var cellReuseIdentifier: String { WalletAccountListConstants.assetCellId }
    public let assetId: String
    public let amount: String
    public let symbol: String?
    public let details: String
    public let accessoryDetails: String?
    public let imageViewModel: WalletImageViewModelProtocol?
    public let style: AssetCellStyle
    public let command: WalletCommandProtocol?
    public let priceChangeViewModel: WalletPriceChangeViewModel

    public let platform: String

    public init(assetId: String,
         amount: String,
         symbol: String?,
         accessoryDetails: String?,
         imageViewModel: WalletImageViewModelProtocol?,
         style: AssetCellStyle,
         platform: String,
         details: String,
         priceChangeViewModel: WalletPriceChangeViewModel,
         command: WalletCommandProtocol?) {
        self.assetId = assetId
        self.amount = amount
        self.symbol = symbol
        self.accessoryDetails = accessoryDetails
        self.imageViewModel = imageViewModel
        self.style = style
        self.platform = platform
        self.details = details
        self.priceChangeViewModel = priceChangeViewModel
        self.command = command
    }
}
