//
//  EthConfirmPaymentViewController.swift
//  CloudArtChain
//
//  Created by jielian on 2021/10/11.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import BigInt
import UIKit
import Result

enum AppStyle {
    case heading
    case headingSemiBold
    case paragraph
    case paragraphLight
    case paragraphSmall
    case largeAmount
    case error
    case formHeader
    case collactablesHeader

    var font: UIFont {
        switch self {
        case .heading:
            return UIFont.systemFont(ofSize: 18, weight: .regular)
        case .headingSemiBold:
            return UIFont.systemFont(ofSize: 18, weight: .semibold)
        case .paragraph:
            return UIFont.systemFont(ofSize: 15, weight: .regular)
        case .paragraphSmall:
            return UIFont.systemFont(ofSize: 14, weight: .regular)
        case .paragraphLight:
            return UIFont.systemFont(ofSize: 15, weight: .light)
        case .largeAmount:
            return UIFont.systemFont(ofSize: 20, weight: .medium)
        case .error:
            return UIFont.systemFont(ofSize: 13, weight: .light)
        case .formHeader:
            return UIFont.systemFont(ofSize: 14, weight: .regular)
        case .collactablesHeader:
            return UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.regular)
        }
    }

    var textColor: UIColor {
        switch self {
        case .heading, .headingSemiBold:
            return UIColor(hex: "313849")
        case .paragraph, .paragraphLight, .paragraphSmall:
            return UIColor(hex: "464646")
        case .largeAmount:
            return UIColor.black // Usually colors based on the amount
        case .error:
            return UIColor(hex: "E32146")
        case .formHeader:
            return UIColor(hex: "6e6e72")
        case .collactablesHeader:
            return UIColor(hex: "333333333333")
        }
    }
}

enum EthCoinTicketError: LocalizedError {
    case notFind
    
    var errorDescription: String? {
        switch self {
        case .notFind:
            return "未找到"
        }
    }
}

class EthConfirmPaymentViewController: JLBaseViewController {
    
    private let keystore: EthKeystore
    
    lazy var sendTransactionCoordinator = {
        return EthSendTransactionCoordinator(keystore: self.keystore, confirmType: self.confirmType, server: self.server)
    }()
    lazy var submitButton: UIButton = {
        let button = Button(size: .large, style: .solid)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("发送", for: .normal)
        button.addTarget(self, action: #selector(send), for: .touchUpInside)
        return button
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        stackView.axis = .vertical
        return stackView
    }()

    lazy var footerStack: UIStackView = {
        let footerStack = UIStackView(arrangedSubviews: [
            submitButton,
        ])
        footerStack.translatesAutoresizingMaskIntoConstraints = false
        return footerStack
    }()
    
    var configurator: EthTransactionConfigurator
    let confirmType: EthConfirmType
    let server: EthRPCServer
    var didCompleted: ((Result<EthConfirmResult, AnyError>) -> Void)?
    var ticketPrice: String?

    init(
        keystore: EthKeystore,
        configurator: EthTransactionConfigurator,
        confirmType: EthConfirmType,
        server: EthRPCServer
    ) {
        self.keystore = keystore
        self.configurator = configurator
        self.confirmType = confirmType
        self.server = server
        
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        
        view.addSubview(stackView)
        view.addSubview(footerStack)

        fetch()
    }
    
    func fetch() {
        JLLoading.shared().showRefreshLoading(on: view)
        configurator.load { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.reloadView()
                JLLoading.shared().hide()
            case .failure(_):
                JLLoading.shared().hide()
            }
        }
        configurator.configurationUpdate.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.reloadView()
        }
        
        refreshTicketPrice { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let ticket):
                self.ticketPrice = ticket.price.eth
                self.reloadView()
            case .failure(let error):
                print("ethereum prices error: ",error.prettyError)
            }
        }
    }
    
    private func refreshTicketPrice(_ completion: @escaping (Result<EthCoinTicker, Error>) -> Void) {
        guard let walletInfo = keystore.recentlyUsedWalletInfo else { return }
        let tokenPrice = EthTokenPrice(symbol: server.symbol)
        EthNetwork(provider: EthProviderFactory.makeProvider(), wallet: walletInfo).tickers(with: tokenPrice).done { [weak self] ticker in
//            guard let `self` = self else { return }
//            guard let ticket = tickers.filter({ $0.symbol.lowercased() == self.server.symbol.lowercased() }).first else { return
//                completion(.failure(EthCoinTicketError.notFind))
//            }
            print("ethereum ticket price: ", ticker.price.eth)
            completion(.success(ticker))
        }.catch { error in
            completion(.failure(error))
        }
    }
    
    private func reloadView() {
        if ticketPrice != nil {
            let viewModel = EthConfirmPaymentDetailsViewModel(
                transaction: configurator.previewTransaction(),
                keystore: keystore,
                server: server,
                ticketPrice: ticketPrice!
            )
            self.configure(for: viewModel)
        }else {
            refreshTicketPrice { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case .success(let ticket):
                    self.ticketPrice = ticket.price.eth
                    let viewModel = EthConfirmPaymentDetailsViewModel(
                        transaction: self.configurator.previewTransaction(),
                        keystore: self.keystore,
                        server: self.server,
                        ticketPrice: self.ticketPrice!
                    )
                    self.configure(for: viewModel)
                case .failure(let error):
                    print("ethereum prices error: ",error.prettyError)
                }
            }
        }
    }
    
    private func configure(for detailsViewModel: EthConfirmPaymentDetailsViewModel) {
        print("ethereum viewModel transaction gasPrice:\(detailsViewModel.transaction.gasPrice),,,gasLimit:\(detailsViewModel.transaction.gasLimit),,,nonce:\(detailsViewModel.transaction.nonce),,,ticketPrice:\(String(describing: ticketPrice))")
        submitButton.isHidden = false
        
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(view.layoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        footerStack.snp.makeConstraints { (make) in
            make.trailing.equalTo(view.snp.trailing).offset(-15)
            make.leading.equalTo(view.snp.leading).offset(15)
            make.bottom.equalTo(view.layoutGuide.snp.bottom).offset(-15)
        }
        submitButton.snp.makeConstraints { (make) in
            make.leading.equalTo(footerStack.snp.leading)
            make.trailing.equalTo(footerStack.snp.leading)
        }
        
        let header = EthTransactionHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.configure(for: detailsViewModel.transactionHeaderViewModel)
        
        let items: [UIView] = [
            .spacer(height: EthTransactionAppearance.spacing),
            header,
            .spacer(height: 10),
            EthTransactionAppearance.divider(color: UIColor.lightGray, alpha: 0.3),
            .spacer(height: EthTransactionAppearance.spacing),
            EthTransactionAppearance.item(
                title: detailsViewModel.paymentFromTitle,
                subTitle: detailsViewModel.currentWalletDescriptionString
            ),
            .spacer(height: EthTransactionAppearance.spacing),
            EthTransactionAppearance.divider(color: UIColor.lightGray, alpha: 0.3),
            .spacer(height: EthTransactionAppearance.spacing),
            EthTransactionAppearance.item(
                title: detailsViewModel.requesterTitle,
                subTitle: detailsViewModel.requesterText
            ),
            .spacer(height: EthTransactionAppearance.spacing),
            EthTransactionAppearance.divider(color: UIColor.lightGray, alpha: 0.3),
            .spacer(height: EthTransactionAppearance.spacing),
            EthTransactionAppearance.oneLine(
                title: detailsViewModel.estimatedFeeTitle,
                subTitle: detailsViewModel.estimatedFeeText
            ),
            .spacer(height: EthTransactionAppearance.spacing),
            EthTransactionAppearance.divider(color: UIColor.lightGray, alpha: 0.3),
            EthTransactionAppearance.oneLine(
                title: detailsViewModel.totalTitle,
                subTitle: detailsViewModel.totalText,
                titleStyle: .headingSemiBold,
                subTitleStyle: .paragraph,
                layoutMargins: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15),
                backgroundColor: UIColor(hex: "faf9f9")
            ),
            EthTransactionAppearance.divider(color: UIColor.lightGray, alpha: 0.3),
        ]

        for item in items {
            stackView.addArrangedSubview(item)
        }
        
        updateSubmitButton()
    }
    
    private func updateSubmitButton() {
        let status = configurator.balanceValidStatus()
        submitButton.isEnabled = status.sufficient
        submitButton.setTitle("发送", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func dismissVC() {
        self.didCompleted?(.failure(AnyError(EthDAppError.cancelled)))
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func send() {
        JLLoading.shared().showRefreshLoading(on: view)

        let transaction = configurator.signTransaction
        sendTransactionCoordinator.send(transaction: transaction) { [weak self] result in
            guard let `self` = self else { return }
            self.didCompleted?(result)
            JLLoading.shared().hide()
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - ViewModel
struct GasViewModel {
    let fee: BigInt
    let server: EthRPCServer
    let formatter: EthNumberFormatter
    let ticketPrice: String

    init(
        fee: BigInt,
        server: EthRPCServer,
        formatter: EthNumberFormatter = .full,
        ticketPrice: String
    ) {
        self.fee = fee
        self.server = server
        self.formatter = formatter
        self.ticketPrice = ticketPrice
    }

    var etherFee: String {
        let gasFee = formatter.string(from: fee)
        return "\(gasFee.description) \(server.symbol)"
    }

    var feeCurrency: Double? {
        return EthFeeCalculator.estimate(fee: formatter.string(from: fee), with: ticketPrice)
    }

    var monetaryFee: String? {
        guard let feeInCurrency = feeCurrency,
            let fee = EthFeeCalculator.format(fee: feeInCurrency) else {
            return .none
        }
        return fee
    }

    var feeText: String {
        var text = etherFee
        if let monetaryFee = monetaryFee {
            text += "(\(monetaryFee))"
        }
        return text
    }
}
struct EthConfirmPaymentDetailsViewModel {

    let transaction: EthPreviewTransaction
    let keystore: EthKeystore
    let config: EthConfig
    let server: EthRPCServer
    let ticketPrice: String
    private let fullFormatter = EthNumberFormatter.full
    private let balanceFormatter = EthNumberFormatter.balance
//    private var monetaryAmountViewModel: MonetaryAmountViewModel {
//        return MonetaryAmountViewModel(
//            amount: amount,
//            contract: transaction.transfer.type.address,
//            session: session
//        )
//    }
    init(
        transaction: EthPreviewTransaction,
        config: EthConfig = EthConfig(),
        keystore: EthKeystore,
        server: EthRPCServer,
        ticketPrice: String
    ) {
        self.transaction = transaction
        self.config = config
        self.keystore = keystore
        self.server = server
        self.ticketPrice = ticketPrice
    }

    private var gasViewModel: GasViewModel {
        return GasViewModel(fee: totalFee, server: server, formatter: fullFormatter, ticketPrice: ticketPrice)
    }

    private var totalViewModel: GasViewModel {

        var value: BigInt = totalFee

        if case TransferType.ether(_,_) = transaction.transfer.type {
            value += transaction.value
        }

        return GasViewModel(fee: value, server: server, formatter: fullFormatter, ticketPrice: ticketPrice)
    }

    private var totalFee: BigInt {
        return transaction.gasPrice * transaction.gasLimit
    }

    private var gasLimit: BigInt {
        return transaction.gasLimit
    }

    var currentWalletDescriptionString: String {
        let address = transaction.account.address.description
        return ("(\(address.prefix(10))...\(address.suffix(8)))")
    }

    var paymentFromTitle: String {
        return "From"
    }

    var requesterTitle: String {
        switch transaction.transfer.type {
        case .dapp:
            return "DApp"
        case .ether, .token:
            return "To"
        }
    }

    var requesterText: String {
        switch transaction.transfer.type {
        case .dapp(_, let request):
            return request.url?.absoluteString ?? ""
        case .ether, .token:
            return transaction.address?.description ?? ""
        }
    }

    var amountTitle: String {
        return "Amount"
    }

    var amountText: String {
        return String(
            format: "%@ %@",
            amountString,
            monetaryAmountString ?? ""
        )
    }

    var estimatedFeeTitle: String {
        return "网络费用"
    }

    var estimatedFeeText: String {
        let unit = UnitConfiguration.gasPriceUnit
        let amount = fullFormatter.string(from: transaction.gasPrice, units: UnitConfiguration.gasPriceUnit)
        return  String(
            format: "%@ %@ (%@)",
            amount,
            unit.name,
            gasViewModel.monetaryFee ?? ""
        )
    }

    var amountTextColor: UIColor {
        return UIColor(hex: "f7506c")
    }

    var totalTitle: String {
        return "最大总计"
    }

    var totalText: String {
        let feeDouble = gasViewModel.feeCurrency ?? 0
        let amountDouble = amountCurrency ?? 0

        guard let totalAmount = EthFeeCalculator.format(fee: feeDouble + amountDouble) else {
            return "--"
        }
        return totalAmount
    }
    
    var amountCurrency: Double? {
        return EthFeeCalculator.estimate(fee: amount, with: ticketPrice)
    }

    var amount: String {
        switch transaction.transfer.type {
        case .token(let token):
            return balanceFormatter.string(from: transaction.value, decimals: token.decimals)
        case .ether(let token, _), .dapp(let token, _):
            return balanceFormatter.string(from: transaction.value, decimals: token.decimals)
        }
    }

    var transactionHeaderViewModel: EthTransactionHeaderViewViewModel {
        return EthTransactionHeaderViewViewModel(
            amountString: amountString,
            amountTextColor: amountTextColor,
            monetaryAmountString: monetaryAmountString,
            statusImage: statusImage
        )
    }

    var amountString: String {
        return amountWithSign(for: amount) + " \(transaction.transfer.type.symbol(server: server))"
    }

    var monetaryAmountString: String? {
        guard let amountCurrency = amountCurrency,
            let result = EthFeeCalculator.format(fee: amountCurrency) else {
            return .none
        }
        return "(\(result))"
    }

    var statusImage: UIImage? {
        return UIImage(named: "icon_transaction_sent")
    }

    private func amountWithSign(for amount: String) -> String {
        guard amount != "0" else { return amount }
        return "-\(amount)"
    }
}


// MARK: - 头部视图
struct EthTransactionHeaderAppereance {
    static let amountFont = UIFont.systemFont(ofSize: 20, weight: .medium)
    static let monetaryFont = UIFont.systemFont(ofSize: 13, weight: .light)
    static let monetaryTextColor = UIColor.gray
}
struct EthTransactionHeaderViewViewModel {
    let amountString: String
    let amountTextColor: UIColor
    let monetaryAmountString: String?
    let statusImage: UIImage?
}

final class EthTransactionHeaderView: UIView {

    let imageView = UIImageView()
    let amountLabel = UILabel()
    let monetaryAmountLabel = UILabel()

    override init(frame: CGRect = .zero) {

        super.init(frame: frame)

        imageView.translatesAutoresizingMaskIntoConstraints = false

        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.textAlignment = .center
        amountLabel.font = EthTransactionHeaderAppereance.amountFont

        monetaryAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        monetaryAmountLabel.textAlignment = .center
        monetaryAmountLabel.font = EthTransactionHeaderAppereance.monetaryFont
        monetaryAmountLabel.textColor = EthTransactionHeaderAppereance.monetaryTextColor

        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            .spacerWidth(),
            amountLabel,
            monetaryAmountLabel,
        ])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(15)
            make.centerX.equalTo(snp.centerX)
            make.leading.greaterThanOrEqualTo(snp.leading)
            make.trailing.lessThanOrEqualTo(snp.trailing)
            make.bottom.equalTo(snp.bottom).offset(-15)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for viewModel: EthTransactionHeaderViewViewModel) {
        amountLabel.text = viewModel.amountString
        amountLabel.textColor = viewModel.amountTextColor
        monetaryAmountLabel.text = viewModel.monetaryAmountString
        imageView.image = viewModel.statusImage
    }
}

// MARK: - EthTransactionAppearance
enum EthDividerDirection {
    case vertical
    case horizontal
}
struct EthTransactionAppearance {
    static let spacing: CGFloat = 16

    static func divider(direction: EthDividerDirection = .horizontal, color: UIColor, alpha: CGFloat = 1, layoutInsets: UIEdgeInsets = .zero) -> UIView {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = color
        label.alpha = alpha

        switch direction {
        case .horizontal:
            label.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        case .vertical:
            label.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        }

        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = layoutInsets
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }

    static func item(
        title: String,
        subTitle: String,
        titleStyle: AppStyle = .heading,
        subTitleStyle: AppStyle = .paragraphLight,
        subTitleMinimumScaleFactor: CGFloat  = 0.7,
        layoutMargins: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15),
        completion:((_ title: String, _ value: String, _ sender: UIView) -> Void)? = .none
    ) -> UIView {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = titleStyle.font
        titleLabel.textColor = titleStyle.textColor
        titleLabel.textAlignment = .left

        let subTitleLabel = UILabel(frame: .zero)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.text = subTitle
        subTitleLabel.font = subTitleStyle.font
        subTitleLabel.textColor = subTitleStyle.textColor
        subTitleLabel.textAlignment = .left
        subTitleLabel.numberOfLines = 1
        subTitleLabel.adjustsFontSizeToFitWidth = true
        subTitleLabel.minimumScaleFactor = subTitleMinimumScaleFactor
        subTitleLabel.lineBreakMode = .byTruncatingMiddle

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true

//        UITapGestureRecognizer(addToView: stackView) {
//            completion?(title, subTitle, stackView)
//        }

        return stackView
    }

    static func horizontalItem(views: [UIView], distribution: UIStackView.Distribution = .fillProportionally) -> UIView {
        let view = UIStackView(arrangedSubviews: views)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = distribution
        return view
    }

    static func oneLine(
        title: String,
        subTitle: String,
        titleStyle: AppStyle = .heading,
        subTitleStyle: AppStyle = .paragraphLight,
        layoutMargins: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15),
        backgroundColor: UIColor = .clear,
        completion:((_ title: String, _ value: String, _ sender: UIView) -> Void)? = .none
    ) -> UIView {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = titleStyle.font
        titleLabel.textColor = titleStyle.textColor
        titleLabel.textAlignment = .left
        titleLabel.backgroundColor = backgroundColor

        let subTitleLabel = UILabel(frame: .zero)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.text = subTitle
        subTitleLabel.font = subTitleStyle.font
        subTitleLabel.textColor = subTitleStyle.textColor
        subTitleLabel.textAlignment = .right
        subTitleLabel.backgroundColor = backgroundColor

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.layoutMargins = layoutMargins
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.addBackground(color: backgroundColor)

//        UITapGestureRecognizer(addToView: stackView) {
//            completion?(title, subTitle, stackView)
//        }

        return stackView
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}


