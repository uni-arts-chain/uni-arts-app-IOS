//
//  JLEthereumTool.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/3.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import CryptoSwift
import TrezorCrypto
import TrustCore
import TrustKeystore
import Result

@objcMembers class JLEthereumWalletInfo: NSObject {
    var address: String?
    var type: JLEthereumType?
    var storeKey: String?
    
    var name: String?
    
    override var description: String {
        return "address: \(address ?? ""), type: \(type?.rawValue ?? ""), storeKey: \(storeKey ?? ""), name: \(name ?? "")"
    }
}

@objcMembers class JLEthereumTool: NSObject {
    static let shared = JLEthereumTool()
    private let keystore = EthKeystore()
    
    var collectDappClourse: ((_ isCollect: Bool) -> Void)?

    override private init() { super.init() }

    /// 获取所有导入或创建的钱包
    /// - Returns: 账户信息数组
    func allWalletInfos() -> [JLEthereumWalletInfo] {
        return keystore.walletInfos.map { walletInfo -> JLEthereumWalletInfo in
            let resultInfo = JLEthereumWalletInfo()
            resultInfo.address = String(describing: walletInfo.address)
            resultInfo.storeKey = walletInfo.storeKey
            switch walletInfo.type {
            case .privateKey:
                resultInfo.type = .privateKey
            case .hd:
                resultInfo.type = .hd
            default:
                resultInfo.type = .address
            }
            return resultInfo
        }
    }
    
    /// 获取当前的账户
    /// - Returns: 账户信息
    func currentWalletInfo() -> JLEthereumWalletInfo? {
        guard let walletInfo = keystore.recentlyUsedWalletInfo else { return .none }
        let resultInfo = JLEthereumWalletInfo()
        resultInfo.address = String(describing: walletInfo.address)
        resultInfo.storeKey = walletInfo.storeKey
        switch walletInfo.type {
        case .privateKey:
            resultInfo.type = .privateKey
        case .hd:
            resultInfo.type = .hd
        default:
            resultInfo.type = .address
        }
        return resultInfo
    }

    /// 获取当前账户密码
    func getCurrentPassword() -> String? {
        guard let walletInfo = keystore.recentlyUsedWalletInfo else { return .none }
        guard let wallet = walletInfo.currentWallet else { return .none }
        return keystore.getPassword(for: wallet)
    }
    
    /// 选择账户
    /// - Parameters:
    ///   - walletInfo: 账户信息
    ///   - completion: 完成后回调
    func chooseAccount(walletInfo: JLEthereumWalletInfo, completion: @escaping (_ isSuccess: Bool, _ errorMsg: String?) -> Void) {
        guard let storeKey = walletInfo.storeKey else { return
            completion(false,"storeKey 不可用")
        }
        keystore.chooseWallet(with: storeKey) { result in
            switch result {
            case .success(_):
                completion(true, .none)
            case .failure(let error):
                completion(false, error.errorDescription)
            }
        }
    }

    /// 创建账户
    func createInstantWallet(completion: @escaping (_ address: String?, _ errorMsg: String?) -> Void) {
        if let walletInfo = keystore.recentlyUsedWalletInfo {
            print("ethereum 已经存在账户 address: \(String(describing: walletInfo.address)), type: \(walletInfo.type) storeKey: \(walletInfo.storeKey)")
            completion(String(describing: walletInfo.address), .none)
            return
        }
        print("ethereum 新建账户")
        keystore.createAccount { result in
            switch result {
            case .success(let wallet):
                completion(String(describing: wallet.accounts[0].address), .none)
            case .failure(let error):
                completion(.none, error.errorDescription)
            }
        }
    }
}

// MARK: TEST
extension JLEthereumTool {
    // 获取当前 以太坊 账户的余额
    func getCurrentWalletBalance(completion: @escaping (_ balanceString: String?, _ errorMsg: String?) -> Void) {
        guard let walletInfo = keystore.recentlyUsedWalletInfo else { return }
        guard let ethAddress = walletInfo.address as? EthereumAddress else { return }
        // EthereumAddress(string: "0xa5760BB0777647cb1C69E75A64234F6103778D05")
        EthWalletRPCService(server: .main, addressUpdate: ethAddress).getBalance().done { balance in
            completion(balance.amountShort == "0" ? "0.0" : balance.amountShort, .none)
        }.catch { error in
            completion(.none, error.prettyError)
        }
    }
    
    // 获取gasPrice
    func getGasPrice(completion: @escaping (_ gasPrice: String?, _ errorMsg: String?) -> Void) {
        EthWalletRPCService(server: .main).getGasPrice().done { balance in
            completion(balance, .none)
        }.catch { error in
            completion(.none, error.prettyError)
        }
    }
}

// MARK: 导入钱包
extension JLEthereumTool {
    /// 导入账户(助记词)
    func importWallet(mnemonics: [String], completion: @escaping (_ address: String?, _ errorMsg: String?) -> Void) {
        print("ethereum 导入账户(助记词)")
        keystore.importWallet(type: .mnemonic(words: mnemonics, password: "", derivationPath: Coin.ethereum.derivationPath(at: 0)), coin: .ethereum) { result in
            switch result {
            case .success(let walletInfo):
                completion(String(describing: walletInfo.address), .none)
            case .failure(let error):
                completion(.none, error.errorDescription)
            }
        }
    }
    
    /// 导入账户(private key)
    func importWallet(privateKey: String, completion: @escaping (_ address: String?, _ errorMsg: String?) -> Void) {
        print("ethereum 导入账户(private key)")
        keystore.importWallet(type: .privateKey(privateKey: privateKey), coin: .ethereum) { result in
            switch result {
            case .success(let walletInfo):
                completion(String(describing: walletInfo.address), .none)
            case .failure(let error):
                completion(.none, error.errorDescription)
            }
        }
    }
    
    /// 导入账户(keystore json)
    func importWallet(keystoreJson: String, password: String, completion: @escaping (_ address: String?, _ errorMsg: String?) -> Void) {
        print("ethereum 导入账户(keystore json)")
        keystore.importWallet(type: .keystore(string: keystoreJson, password: password), coin: .ethereum) { result in
            switch result {
            case .success(let walletInfo):
                completion(String(describing: walletInfo.address), .none)
            case .failure(let error):
                completion(.none, error.errorDescription)
            }
        }
    }
    
    /// 导入账户(地址)
    func importWallet(address: String, completion: @escaping (_ address: String?, _ errorMsg: String?) -> Void) {
        print("ethereum 导入账户(地址)")
        keystore.importWallet(type: .address(address: EthereumAddress(data: Data(hex: address))!), coin: .ethereum) { result in
            switch result {
            case .success(let wallet):
                completion(String(describing: wallet.accounts[0].address), .none)
            case .failure(let error):
                completion(.none, error.errorDescription)
            }
        }
    }
}

// MARK: 导出钱包
extension JLEthereumTool {
    /// 导出助记词
    func exportMnemonic(completion: @escaping (_ mnemonics: [String], _ errorMsg: String?) -> Void) {
        guard let walletInfo = keystore.recentlyUsedWalletInfo else { return completion([], "没有以太坊账户") }
        guard let wallet = walletInfo.currentWallet else { return
            completion([], "地址导入 不允许导出助记词")
        }
        keystore.exportMnemonic(wallet: wallet) { mnemonicResult in
            switch mnemonicResult {
            case .success(let mnemonics):
                completion(mnemonics, .none)
            case .failure(let error):
                completion([], error.errorDescription)
            }
        }
    }
    
    /// 导出私钥
    func exportPrivateKey(completion: @escaping (_ privateKey: String?, _ errorMsg: String?) -> Void) {
        guard let walletInfo = keystore.recentlyUsedWalletInfo else { return completion(.none, "没有以太坊账户") }
        guard !walletInfo.isWatch else { return
            completion(.none, "地址导入 不允许导出私钥")
        }
        keystore.exportPrivateKey(account: walletInfo.accounts[0]) { privateKeyResult in
            switch privateKeyResult {
            case .success(let privateKey):
                completion(privateKey.hasPrefix("0x") ? privateKey : "0x\(privateKey)", .none)
            case .failure(let error):
                completion(.none, error.errorDescription)
            }
        }
    }
    
    /// 导出keystore json
    /// - Parameters:
    ///   - exportedKey: keystore json 的密码
    ///   - completion: 完成回调
    func exportKeystoreJson(exportedKey: String, completion: @escaping (_ keystore: String?, _ errorMsg: String?) -> Void) {
        guard let walletInfo = keystore.recentlyUsedWalletInfo else { return completion(.none, "没有以太坊账户") }
        guard !walletInfo.isWatch else { return
            completion(.none, "地址导入 不允许导出keystore")
        }
        guard let wallet = walletInfo.currentWallet, let password = keystore.getPassword(for: wallet) else { return
            completion(.none, "不存在的password")
        }
        keystore.export(account: wallet.accounts[0], password: password, newPassword: exportedKey) { keystoreResult in
            switch keystoreResult {
            case .success(let keystore):
                completion(keystore, .none)
            case .failure(let error):
                completion(.none, error.errorDescription)
            }
        }
    }
}

// MARK: 验证密码
private let authorization = UUID().uuidString
private struct AuthorizationConstants {
    static var completionBlockKey: String = "co.jp.fearless.auth.delegate"
    static var authorizationViewKey: String = "co.jp.fearless.auth.view"
}
extension JLEthereumTool {
    private var completionBlock: AuthorizationCompletionBlock? {
        get {
            return objc_getAssociatedObject(authorization, &AuthorizationConstants.completionBlockKey)
                as? AuthorizationCompletionBlock
        }
        set {
            objc_setAssociatedObject(authorization,
                                     &AuthorizationConstants.completionBlockKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN)
        }
    }
    private var authorizationView: PinSetupViewProtocol? {
        get {
            return objc_getAssociatedObject(authorization, &AuthorizationConstants.authorizationViewKey)
                as? PinSetupViewProtocol
        }

        set {
            objc_setAssociatedObject(authorization,
                                     &AuthorizationConstants.authorizationViewKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN)
        }
    }
    private var isAuthorizing: Bool {
        return authorizationView != nil
    }
    
    // 验证密码
    func authorize(animated: Bool,
                   cancellable: Bool,
                   with completionBlock: @escaping AuthorizationCompletionBlock) {

        guard !isAuthorizing else {
            return
        }

        guard let presentingController = UIApplication.shared.keyWindow?
            .rootViewController?.topModalViewController else {
            return
        }
        
        guard let authorizationView = PinViewFactory.createScreenAuthorizationView(with: self,
                                                                                   cancellable: cancellable) else {
            completionBlock(false)
            return
        }

        self.completionBlock = completionBlock
        self.authorizationView = authorizationView

        authorizationView.controller.modalTransitionStyle = .crossDissolve
        authorizationView.controller.modalPresentationStyle = .fullScreen
        presentingController.present(authorizationView.controller, animated: animated, completion: nil)
    }
}
extension JLEthereumTool: ScreenAuthorizationWireframeProtocol {
    func showAuthorizationCompletion(with result: Bool) {
        guard let completionBlock = completionBlock else {
            return
        }

        self.completionBlock = nil

        guard let authorizationView = authorizationView else {
            return
        }

        authorizationView.controller.presentingViewController?.dismiss(animated: true) {
            self.authorizationView = nil
            completionBlock(result)
        }
    }
}

// MARK: DAPP 浏览器
extension JLEthereumTool: EthBrowserCoordinatorDelegate {
    /// 查看dapp
    func lookDapp(navigationViewController: JLNavigationViewController?, name: String?, imgUrl: String?, webUrl: URL, isCollect: Bool, collectCompletion: @escaping (_ isCollect: Bool) -> Void) {
        guard let _ = keystore.recentlyUsedWalletInfo else { return }
        guard navigationViewController != nil else { return }
        collectDappClourse = collectCompletion
//        let coordinator = EthBrowserCoordinator(keystore: keystore, navigationController: navigationViewController!, name: name, imgUrl: imgUrl, webUrl: webUrl, isCollect: isCollect)
//        coordinator.delegate = self
//        coordinator.start()
        
        let browserViewController = EthBrowserViewController(keystore: keystore, config: .current, server: .rinkeby, name: name, imgUrl: imgUrl, webUrl: webUrl, isCollect: isCollect)
        browserViewController.delegate = self
        browserViewController.modalPresentationStyle = .fullScreen
        navigationViewController?.present(browserViewController, animated: true, completion: nil)
        
    }
    
    func didSentTransaction(transaction: EthSentTransaction, in coordinator: EthBrowserCoordinator) {
        print("ethereum 已经发送交易")
    }
    
    func collectDapp(isCollect: Bool) {
        if collectDappClourse != nil {
            collectDappClourse!(isCollect)
        }
    }
}

// MARK: EthBrowserViewControllerDelegate
extension JLEthereumTool: EthBrowserViewControllerDelegate {
    func didSentTransaction(transaction: EthSentTransaction) {
        print("ethereum 已经发送交易")
    }
    
    func collectCurrentDapp(with isCollect: Bool) {
        if collectDappClourse != nil {
            collectDappClourse!(isCollect)
        }
    }
}
