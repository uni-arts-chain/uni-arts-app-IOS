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
import WalletConnect
import WebKit

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
    private let rpcServer = EthRPCServer.rinkeby
    
    var collectDappClourse: ((_ isCollect: Bool) -> Void)?
    
    var interactor: WCInteractor?

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

// MARK: - RPC SERVER
extension JLEthereumTool {
    // 获取当前 以太坊 账户的余额
    func getCurrentWalletBalance(completion: @escaping (_ balanceString: String?, _ errorMsg: String?) -> Void) {
        guard let walletInfo = keystore.recentlyUsedWalletInfo else { return }
        guard let ethAddress = walletInfo.address as? EthereumAddress else { return }
        // EthereumAddress(string: "0xa5760BB0777647cb1C69E75A64234F6103778D05")
        EthWalletRPCService(server: rpcServer, addressUpdate: ethAddress).getBalance().done { balance in
            completion(balance.amountShort == "0" ? "0.0" : balance.amountShort, .none)
        }.catch { error in
            completion(.none, error.prettyError)
        }
    }
    
    // 获取gasPrice
    func getGasPrice(completion: @escaping (_ gasPrice: String?, _ errorMsg: String?) -> Void) {
        EthWalletRPCService(server: rpcServer).getGasPrice().done { balance in
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

// MARK: - 导出钱包
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

// MARK: - 验证密码
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

// MARK: - DAPP 浏览器
extension JLEthereumTool: EthBrowserCoordinatorDelegate {
    /// 查看dapp
    func lookDapp(navigationViewController: JLNavigationViewController?, name: String?, imgUrl: String?, webUrl: URL, isCollect: Bool, collectCompletion: @escaping (_ isCollect: Bool) -> Void) {
        guard let _ = keystore.recentlyUsedWalletInfo else { return }
        guard navigationViewController != nil else { return }
        collectDappClourse = collectCompletion
//        let coordinator = EthBrowserCoordinator(keystore: keystore, navigationController: navigationViewController!, name: name, imgUrl: imgUrl, webUrl: webUrl, isCollect: isCollect)
//        coordinator.delegate = self
//        coordinator.start()
        
        let browserViewController = EthBrowserViewController(keystore: keystore, config: .current, server: rpcServer, name: name, imgUrl: imgUrl, webUrl: webUrl, isCollect: isCollect)
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

// MARK: - EthBrowserViewControllerDelegate
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

// MARK: - DApp Wallet Connect
extension JLEthereumTool {
    func connect(with uri: String,
                 viewController: UIViewController,
                 completion: @escaping (_ walletIsCollect: Bool) -> Void) {
        guard let session = WCSession.from(string: uri) else {
            completion(false)
            return
        }
        let clientMeta = WCPeerMeta(name: "WalletConnect SDK", url: "https://github.com/TrustWallet/wallet-connect-swift")
        let interactor = WCInteractor(session: session, meta: clientMeta, uuid: UIDevice.current.identifierForVendor ?? UUID())
        
        configure(interactor: interactor, viewController: viewController, completion: completion)
        
        interactor.connect().done { connected in
            print("ethereum dapp walletConnect socket 已连接")
        }.catch { [weak self] error in
            completion(false)
            self?.present(errorMsg: error.localizedDescription, viewController: viewController)
        }
        
        interactor.onDisconnect = { [weak self] (error) in
            if let error = error {
                print(error)
            }
            print("ethereum dapp walletConnect socket 断开连接")
            completion(false)
            self?.interactor = nil
        }

        self.interactor = interactor
    }
    
    func disconnected(_ completion: @escaping (Bool) -> Void) {
        interactor?.killSession().cauterize()
        completion(true)
    }
    
    func pauseConnect() {
        interactor?.pause()
    }
    
    func resumeConnect() {
        interactor?.resume()
    }
    
    private func configure(interactor: WCInteractor,
                           viewController: UIViewController,
                           completion: @escaping (_ walletIsCollect: Bool) -> Void) {
        guard let walletInfo = keystore.recentlyUsedWalletInfo else { return
            completion(false)
        }
        let accounts = [String(describing: walletInfo.address)]
        let chainId = rpcServer.chainID
        
        interactor.onError = { [weak self] error in
            self?.present(errorMsg: error.localizedDescription, viewController: viewController)
        }
        
        interactor.onSessionRequest = { [weak self] (id, peerParam) in
            let peer = peerParam.peerMeta
            let message = [peer.description, peer.url].joined(separator: "\n")
            let alert = UIAlertController(title: peer.name, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: { _ in
                interactor.rejectSession().cauterize()
                completion(false)
            }))
            alert.addAction(UIAlertAction(title: "Approve", style: .default, handler: { _ in
                self?.interactor?.approveSession(accounts: accounts, chainId: chainId).done({ _ in
                    completion(true)
                }).cauterize()
            }))
            viewController.present(alert, animated: true, completion: nil)
        }
                
        interactor.eth.onSign = { [weak self] (id, payload) in
            let alert = UIAlertController(title: payload.method, message: payload.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
                self?.interactor?.rejectRequest(id: id, message: "User canceled").cauterize()
            }))
            alert.addAction(UIAlertAction(title: "Sign", style: .default, handler: { _ in
                self?.signEth(id: id, payload: payload)
            }))
            viewController.present(alert, animated: true, completion: nil)
        }
        
        interactor.eth.onTransaction = { [weak self] (id, event, transaction) in
            guard let `self` = self else { return }
            guard let data = try? JSONEncoder().encode(transaction) else { return }
            let walletConnectCoordinator = EthWalletConnectCoordinator(keystore: self.keystore, server: self.rpcServer, transactionData: data, viewController: viewController)
            walletConnectCoordinator.didCompletion = { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case .success(let didSentTransaction):
                    let resultTransaction = didSentTransaction.original
                    var dict: [String: String] = [:]
                    dict["from"] = transaction.from
                    dict["to"] = transaction.to
                    dict["nonce"] = String(resultTransaction.nonce)
                    dict["gasPrice"] = String(resultTransaction.gasPrice)
                    dict["gas"] = String(resultTransaction.gasLimit)
                    dict["gasLimit"] = String(resultTransaction.gasLimit)
                    dict["value"] = String(resultTransaction.value)
                    dict["data"] = resultTransaction.data.hexEncoded
                    
                    guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
                          let str = String(data: data, encoding: String.Encoding.utf8) else { return }
                    let didSentTransactionData = Data(hex: didSentTransaction.id)
                    print("ethereum resultTransaction", str)
                    print("ethereum didSentTransaction callback", didSentTransactionData.hexEncoded)
                    
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: event.rawValue, message: str, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: { _ in
                            self.interactor?.rejectRequest(id: id, message: "I don't have ethers").cauterize()
                        }))
                        alert.addAction(UIAlertAction(title: "Approve", style: .default, handler: { _ in
                            self.interactor?.approveRequest(id: id, result: didSentTransactionData.hexEncoded).cauterize()
                        }))
                        viewController.present(alert, animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    self.interactor?.rejectRequest(id: id, message: error.localizedDescription).cauterize()
                }
            }
            walletConnectCoordinator.excuteTranscation()
        }

        interactor.bnb.onSign = { [weak self] (id, order) in
            let message = order.encodedString
            let alert = UIAlertController(title: "bnb_sign", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { [weak self] _ in
                self?.interactor?.rejectRequest(id: id, message: "User canceled").cauterize()
            }))
            alert.addAction(UIAlertAction(title: "Sign", style: .default, handler: { [weak self] _ in
                self?.present(errorMsg: "暂无功能", viewController: viewController)
//                self?.signBnbOrder(id: id, order: order)
            }))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    private func approve(accounts: [String], chainId: Int, viewController: UIViewController) {
        interactor?.approveSession(accounts: accounts, chainId: chainId).done {
            print("<== approveSession done")
        }.catch { [weak self] error in
            self?.present(errorMsg: error.localizedDescription, viewController: viewController)
        }
    }
    
    private func signEth(id: Int64, payload: WCEthereumSignPayload) {
        guard let walletInfo = keystore.recentlyUsedWalletInfo else { return }
        
        let data: Data = {
            switch payload {
            case .sign(let data, _):
                let prefix = "\u{19}Ethereum Signed Message:\n\(data.count)".data(using: .utf8)!
                return prefix + data
            case .personalSign(let data, _):
                let prefix = "\u{19}Ethereum Signed Message:\n\(data.count)".data(using: .utf8)!
                return prefix + data
            case .signTypeData(_, let data, _):
                // FIXME
                return data
            }
        }()

        let result = keystore.signHash(data, for: walletInfo.accounts[0])
        switch result {
        case .success(let data):
            self.interactor?.approveRequest(id: id, result: "0x" + data.hexString).cauterize()
        case .failure(let error):
            break
        }
    }
    
    private func present(errorMsg: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
