//
//  JLAccountListViewController.swift
//  CommonWallet
//
//  Created by 朱彬 on 2021/1/26.
//

import UIKit
import SoraUI
import SoraKeystore
import SnapKit
import SDWebImage

public protocol JLAccountListViewControllerProtocol: class {
    func pointDesc()
    func accountInfo()
    func pointDetail()
    func backClick(viewController: UIViewController)
}

public final class JLAccountListViewController: UIViewController, AdaptiveDesignable {
    var presenter: AccountListPresenterProtocol!

    var configuration: AccountListConfigurationProtocol?
    
    var currentAccount: JLWalletAccountItem? = {
        guard let selectedAccount = SettingsManager.shared.selectedAccount else {
            return nil
        }
        return selectedAccount
    }()
    
    public var delegate: JLAccountListViewControllerProtocol?
    public var userAvatar: String?
    
    lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        if let avatar = self.userAvatar {
            avatarImageView.sd_setImage(with: URL(string: avatar), completed: nil)
        }
        avatarImageView.layer.cornerRadius = 59.0 * 0.5
        avatarImageView.layer.masksToBounds = true
        return avatarImageView
    }()
    
    lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 220.0))
        
        let backImageView = UIImageView()
        backImageView.image = UIImage(named: "icon_qianbao_bg")
        tableHeaderView.addSubview(backImageView)
        
        let avatarView = UIView()
        avatarView.backgroundColor = UIColor.white
        avatarView.layer.cornerRadius = 65.0 * 0.5
        avatarView.layer.masksToBounds = true
        tableHeaderView.addSubview(avatarView)
        
        avatarView.addSubview(avatarImageView)
        
        let nameLabel = UILabel()
        nameLabel.text = self.currentAccount?.username
        nameLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.semibold)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        tableHeaderView.addSubview(nameLabel)
        
        let addressLabel = UILabel()
        if let account = self.currentAccount {
            addressLabel.text = "钱包地址：" + account.getHiddenAddress()
        }
        addressLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        addressLabel.textColor = .white
        addressLabel.textAlignment = .center
        tableHeaderView.addSubview(addressLabel)
        
        let headerButton = UIButton(type: UIButton.ButtonType.custom)
        headerButton.addTarget(self, action: #selector(headerButtonClick), for: UIControl.Event.touchUpInside)
        tableHeaderView.addSubview(headerButton)
        
        backImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(tableHeaderView)
        }
        avatarView.snp.makeConstraints { (make) in
            make.top.equalTo(38.0)
            make.size.equalTo(65.0)
            make.centerX.equalTo(tableHeaderView.snp.centerX)
        }
        avatarImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(avatarView).inset(UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(tableHeaderView)
            make.top.equalTo(avatarView.snp.bottom).offset(18.0)
            make.height.equalTo((13.0))
        }
        addressLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(tableHeaderView)
            make.top.equalTo(nameLabel.snp.bottom).offset(26.0)
            make.height.equalTo(13.0)
        }
        headerButton.snp.makeConstraints { (make) in
            make.edges.equalTo(tableHeaderView)
        }
        
        return tableHeaderView
    }()
    
    lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        
        let centerView = UIView()
        bottomView.addSubview(centerView)
        centerView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(bottomView)
            make.centerX.equalTo(bottomView.snp.centerX)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "积分说明"
        titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        titleLabel.textColor = UIColor(hex: "909090")
        titleLabel.textAlignment = .center
        centerView.addSubview(titleLabel)
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "icon_wallet_point_help")
        centerView.addSubview(iconImageView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(centerView)
        }
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(7.0)
            make.right.equalTo(centerView)
            make.size.equalTo(14.0)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        let pointDescBtn = UIButton(type: .custom)
        pointDescBtn.addTarget(self, action: #selector(pointDescBtnClick), for: .touchUpInside)
        bottomView.addSubview(pointDescBtn)
        pointDescBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(bottomView)
        }
        
        return bottomView
    }()
    
    @objc func pointDescBtnClick() {
        delegate?.pointDesc()
    }
    
    @objc func headerButtonClick() {
        delegate?.accountInfo()
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0.0
        tableView.estimatedSectionHeaderHeight = 0.0
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.separatorStyle = .none
        tableView.tableHeaderView = self.tableHeaderView
        return tableView
    }()

    private var viewModels: [WalletViewModelProtocol] = []
    private var collapsingRange: Range<Int> = 0..<0
    private var expanded: Bool = false
    private var didCompleteLoad: Bool = false

    private var collapsingRangeLength: Int {
        return collapsingRange.upperBound - collapsingRange.lowerBound
    }
    
    var observable = WalletViewModelObserverContainer<ContainableObserver>()

    weak var reloadableDelegate: ReloadableDelegate?

    var contentInsets: UIEdgeInsets = .zero

    lazy var preferredContentHeight: CGFloat = configuration?.minimumContentHeight ?? 0.0

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "积分钱包"
        addBackItem()

        configure()

        presenter.setup()
        didCompleteLoad = true
        NotificationCenter.default.addObserver(self, selector: #selector(userLoginNotification(notification:)), name: NSNotification.Name(rawValue: "UserLoginNotification"), object: nil)
    }
    
    @objc func userLoginNotification(notification: Notification) {
        let userAvatar = notification.userInfo?["url"] as? String
        if let avatar = userAvatar {
            self.avatarImageView.sd_setImage(with: URL(string: avatar), completed: nil)
        }
    }
    
    public func getBanlanceSetup() {
        presenter.setup()
        didCompleteLoad = true
    }
    
    func addBackItem() {
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.style = .plain
        leftBarButtonItem.image = UIImage(named: "icon_back")
        leftBarButtonItem.target = self;
        leftBarButtonItem.action = #selector(backClick)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func backClick() {
        delegate?.backClick(viewController: self)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter.viewDidAppear()
    }

    private func configure() {
        view.backgroundColor = .white
        
        view.addSubview(self.tableView)
        view.addSubview(self.bottomView)
        
        let touchResponderHeight = UIApplication.shared.statusBarFrame.size.height > 20.0 ? 34.0 : 0.0
        self.bottomView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(-touchResponderHeight)
            make.height.equalTo(62.0)
        }
        self.tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self.view)
            make.bottom.equalTo(self.bottomView.snp.top)
        }
        
        configueTableView()
    }

    private func configueTableView() {
        self.tableView.register(JLWalletPointCell.self, forCellReuseIdentifier: "JLWalletPointCell")
    }

    private func createContentHeight(from viewModels: [WalletViewModelProtocol],
                                     isExpanded: Bool,
                                     collapsingRange: Range<Int>) -> CGFloat {
        var height: CGFloat = 0.0

        for (index, model) in viewModels.enumerated() {
            if isExpanded || !collapsingRange.contains(index) {
                height += model.itemHeight
            }
        }

        let minimumContentHeight = configuration?.minimumContentHeight ?? 0.0

        return max(height, minimumContentHeight)
    }

    private func adjustedRow(for index: Int) -> Int {
        var row = index

        if !expanded && row >= collapsingRange.lowerBound {
            row += collapsingRangeLength
        }

        return row
    }

    // MARK: Actions

    @objc func actionReload() {
        presenter.reload()

        reloadableDelegate?.didInitiateReload(on: self)
    }
}

extension JLAccountListViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModels.count > 0 {
            return 1
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JLWalletPointCell", for: indexPath) as! JLWalletPointCell
        let viewModel = viewModels[1]
        cell.bind(viewModel: viewModel)
        return cell
    }
}

extension JLAccountListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.pointDetail()
    }
}

extension JLAccountListViewController: AccountListViewProtocol {
    func didLoad(viewModels: [WalletViewModelProtocol], collapsingRange: Range<Int>) {
        observable.observers.forEach {
            $0.observer?.willChangePreferredContentHeight()
        }

        if didCompleteLoad {
            self.viewModels = viewModels
            self.collapsingRange = collapsingRange
            tableView.reloadData()
        } else {
            self.viewModels = viewModels
        }

        preferredContentHeight = createContentHeight(from: viewModels,
                                                     isExpanded: expanded,
                                                     collapsingRange: collapsingRange)

        observable.observers.forEach {
            $0.observer?.didChangePreferredContentHeight(to: preferredContentHeight)
        }
    }

    func didCompleteReload() {
        self.tableView.reloadData()
    }

    func set(expanded: Bool, animated: Bool) {
        observable.observers.forEach {
            $0.observer?.willChangePreferredContentHeight()
        }

        preferredContentHeight = createContentHeight(from: viewModels,
                                                     isExpanded: expanded,
                                                     collapsingRange: collapsingRange)

        observable.observers.forEach {
            $0.observer?.didChangePreferredContentHeight(to: preferredContentHeight)
        }
    }
}

extension JLAccountListViewController: Containable {
    var contentView: UIView {
        return view
    }

    func setContentInsets(_ contentInsets: UIEdgeInsets, animated: Bool) {
        self.contentInsets = contentInsets
    }
}

extension JLAccountListViewController: Reloadable {
    func reload() {
        presenter.reload()
    }
}
