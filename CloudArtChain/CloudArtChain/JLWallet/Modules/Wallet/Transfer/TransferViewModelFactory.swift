import Foundation
import CommonWallet
import IrohaCrypto
import FearlessUtils

final class TransferViewModelFactory: TransferViewModelFactoryOverriding {
    weak var commandFactory: WalletCommandFactoryProtocol?

    let assets: [WalletAsset]
    let amountFormatterFactory: NumberFormatterFactoryProtocol

    init(assets: [WalletAsset],
         amountFormatterFactory: NumberFormatterFactoryProtocol) {
        self.assets = assets
        self.amountFormatterFactory = amountFormatterFactory
    }

    func createFeeViewModel(_ inputState: TransferInputState,
                            fee: Fee,
                            payload: TransferPayload,
                            locale: Locale) throws -> FeeViewModelProtocol? {
        guard
            let asset = assets
                .first(where: { $0.identifier == fee.feeDescription.assetId }) else {
            return nil
        }

        let title = "Transfer fee"

        let formatter = amountFormatterFactory.createTokenFormatter(for: asset).value(for: locale)

        let amount = formatter
            .string(from: fee.feeDescription.parameters.first?.decimalValue ?? 0) ?? ""

        return FeeViewModel(title: title,
                            details: amount,
                            isLoading: false,
                            allowsEditing: false)
    }

    func createDescriptionViewModel(_ inputState: TransferInputState,
                                    details: String?,
                                    payload: TransferPayload,
                                    locale: Locale) throws
        -> WalletOverridingResult<DescriptionInputViewModelProtocol?>? {
        return WalletOverridingResult(item: nil)
    }

    func createSelectedAssetViewModel(_ inputState: TransferInputState,
                                      selectedAssetState: SelectedAssetState,
                                      payload: TransferPayload,
                                      locale: Locale) throws -> AssetSelectionViewModelProtocol? {
        guard
            let asset = assets
                .first(where: { $0.identifier == payload.receiveInfo.assetId }),
            let assetId = WalletAssetId(rawValue: asset.identifier) else {
            return nil
        }

        let formatter = amountFormatterFactory.createTokenFormatter(for: asset).value(for: locale)

        let balanceContext = BalanceContext(context: inputState.balance?.context ?? [:])
        let amount = formatter.string(from: balanceContext.available) ?? ""

        let subtitle = "Available balance"

        let detailsCommand: WalletCommandProtocol?

        let existentialDeposit = assetId.chain?.existentialDeposit ?? .zero

        if let context = inputState.balance?.context, let commandFactory = commandFactory {
            let balanceContext = BalanceContext(context: context)
            let transferring = inputState.amount ?? .zero
            let fee = inputState.metadata?.feeDescriptions.first?.parameters.first?.decimalValue ?? .zero
            let remaining = balanceContext.total - (transferring + fee)
            let transferState = TransferExistentialState(totalAmount: balanceContext.total,
                                                         availableAmount: balanceContext.available,
                                                         totalAfterTransfer: remaining,
                                                         existentialDeposit: existentialDeposit)

            let amountFormatter = amountFormatterFactory.createDisplayFormatter(for: asset)

            detailsCommand = ExistentialDepositInfoCommand(transferState: transferState,
                                                           amountFormatter: amountFormatter,
                                                           commandFactory: commandFactory)
        } else {
            detailsCommand = nil
        }

        let header = "Asset"

        let viewModel = WalletTokenViewModel(header: header,
                                             title: asset.name.value(for: locale),
                                             subtitle: subtitle,
                                             details: amount,
                                             icon: assetId.icon,
                                             state: selectedAssetState,
                                             detailsCommand: detailsCommand)

        return viewModel
    }

    func createAssetSelectionTitle(_ inputState: TransferInputState,
                                   payload: TransferPayload,
                                   locale: Locale) throws -> String? {
        guard let asset = assets
            .first(where: { $0.identifier == payload.receiveInfo.assetId }) else {
            return nil
        }

        return asset.name.value(for: locale)
    }

    func createReceiverViewModel(_ inputState: TransferInputState,
                                 payload: TransferPayload,
                                 locale: Locale) throws
        -> MultilineTitleIconViewModelProtocol? {

        guard
            let asset = assets
                .first(where: { $0.identifier == payload.receiveInfo.assetId }),
            let chain = WalletAssetId(rawValue: asset.identifier)?.chain,
            let commandFactory = commandFactory else {
            return nil
        }

        let header = "To"

        let iconGenerator = PolkadotIconGenerator()
        let icon = try? iconGenerator.generateFromAddress(payload.receiverName)
            .imageWithFillColor(UIColor.white,
                                size: UIConstants.smallAddressIconSize,
                                contentScale: UIScreen.main.scale)

        let command = WalletAccountOpenCommand(address: payload.receiverName,
                                               chain: chain,
                                               commandFactory: commandFactory,
                                               locale: locale)

        let viewModel = WalletCompoundDetailsViewModel(title: header,
                                                       details: payload.receiverName,
                                                       mainIcon: icon,
                                                       actionIcon: UIImage(named: "iconMore"),
                                                       command: command,
                                                       enabled: false)

        return viewModel
    }

    func createAccessoryViewModel(_ inputState: TransferInputState,
                                  payload: TransferPayload?,
                                  locale: Locale) throws -> AccessoryViewModelProtocol? {
        let action = "Continue"
        return AccessoryViewModel(title: "", action: action)
    }
}
