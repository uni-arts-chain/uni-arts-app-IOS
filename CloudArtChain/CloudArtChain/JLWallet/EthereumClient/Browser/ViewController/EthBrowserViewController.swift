//
//  EthBrowserViewController.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore
import Result
import TrustCore

enum EthBrowserAction {
    case qrCode
    case changeURL(URL)
    case navigationAction(EthBrowserNavigation)
}

protocol EthBrowserViewControllerDelegate: AnyObject {
    func didSentTransaction(transaction: EthSentTransaction)
    func collectCurrentDapp(with isCollect: Bool)
}

final class EthBrowserViewController: JLBaseViewController {
    private var myContext = 0
    let keystore: EthKeystore
    let account: EthWalletInfo
    let sessionConfig: EthConfig
    let server: EthRPCServer
    var token: TokenObject
    
    var name: String?
    var imgUrl: String?
    var webUrl: URL?
    var isCollect: Bool
    weak var delegate: EthBrowserViewControllerDelegate?
    
    private struct Keys {
        static let estimatedProgress = "estimatedProgress"
        static let developerExtrasEnabled = "developerExtrasEnabled"
        static let URL = "URL"
        static let ClientName = Bundle.main.appName
    }
    
    private lazy var userClient: String = {
        return Keys.ClientName + "/" + (Bundle.main.versionNumber ?? "")
    }()
    
    lazy var config: WKWebViewConfiguration = {
        //TODO
        let config = WKWebViewConfiguration.make(for: server, address: account.address, with: sessionConfig, in: EthScriptMessageProxy(delegate: self))
        config.websiteDataStore = WKWebsiteDataStore.default()
        return config
    }()
    
    lazy var navigationBar: JLDappBrowserNavigationBar = {
        let navigationBar = JLDappBrowserNavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIApplication.shared.statusBarFrame.size.height + 44), title: name ?? "") { [weak self] in
            guard let `self` = self else { return }
            self.showManagerFaceView()
        } back: { [weak self] in
            guard let `self` = self else { return }
            self.webView.goBack()
        } close: { [weak self] in
            guard let `self` = self else { return }
            self.popVC()
        }
        return navigationBar
    }()
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(
            frame: .zero,
            configuration: self.config
        )
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        if isDebug {
            webView.configuration.preferences.setValue(true, forKey: Keys.developerExtrasEnabled)
        }
        return webView
    }()
    
    var browserNavBar: EthBrowserNavigationBar? {
        return navigationController?.navigationBar as? EthBrowserNavigationBar
    }
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = UIColor(hex: "00C3C4")
        progressView.trackTintColor = .clear
        return progressView
    }()
    
    init(
        keystore: EthKeystore,
        config: EthConfig,
        server: EthRPCServer,
        name: String? = nil,
        imgUrl: String? = nil,
        webUrl: URL? = nil,
        isCollect: Bool = false
    ) {
        self.keystore = keystore
        self.account = keystore.recentlyUsedWalletInfo!
        self.sessionConfig = config
        self.server = server
        self.name = name
        self.imgUrl = imgUrl
        self.webUrl = webUrl
        self.isCollect = isCollect
        self.token = TokenObject(
            contract: server.priceID.description,
            name: "Ethereum",
            coin: server.coin,
            type: .coin,
            symbol: server.symbol,
            decimals: server.decimals,
            value: "0",
            isCustom: false
        )
        super.init(nibName: nil, bundle: nil)
        
        loadBalance()
    }
    
    private func loadBalance(_ completion: ((Result<Bool, Error>) -> Void)? = nil) {
        guard let ethAddress = self.account.address as? EthereumAddress else { return }
        EthWalletRPCService(server: server, addressUpdate: ethAddress).getBalance().done { [weak self]  balance in
            guard let `self` = self else { return }
            self.token = TokenObject(
                contract: self.server.priceID.description,
                name: "Ethereum",
                coin: self.server.coin,
                type: .coin,
                symbol: self.server.symbol,
                decimals: self.server.decimals,
                value: String(balance.value.magnitude),
                isCustom: false
            )
            if completion != nil {
                completion!(.success(true))
            }
        }.catch { error in
            print("ethereum get eth balance error: ", error)
            if completion != nil {
                completion!(.failure(error))
            }
        }
    }
    
    private func injectUserAgent() {
        webView.evaluateJavaScript("navigator.userAgent") { [weak self] result, _ in
            guard let `self` = self, let currentUserAgent = result as? String else { return }
            self.webView.customUserAgent = currentUserAgent + " " + self.userClient
        }
    }
    
    func goTo(url: URL) {
        print("ethereum open dapp webUrl: ", url)
        webView.load(URLRequest(url: url))
    }
    
    func notifyFinish(callbackID: Int, value: Result<EthDappCallback, EthDAppError>) {
        let script: String = {
            switch value {
            case .success(let result):
                return "executeCallback(\(callbackID), null, \"\(result.value.object)\")"
            case .failure(let error):
                return "executeCallback(\(callbackID), \"\(error)\", null)"
            }
        }()
        webView.evaluateJavaScript(script, completionHandler: nil)
    }
    
//    func goHome() {
//        guard let url = URL(string: EthConstants.dappsBrowserURL) else { return }
//        var request = URLRequest(url: url)
//        request.cachePolicy = .returnCacheDataElseLoad
////        hideErrorView()
//        webView.load(request)
//        browserNavBar?.textField.text = url.absoluteString
//    }

    func reload() {
//        hideErrorView()
        webView.reload()
    }

    private func stopLoading() {
        webView.stopLoading()
    }

    private func refreshURL() {
        browserNavBar?.textField.text = webView.url?.absoluteString
        browserNavBar?.backButton.isHidden = !webView.canGoBack
        
        print("ethereum is show back: ", webView.backForwardList.backList.count, webView.canGoBack)
        navigationBar.isShowBackBtn = webView.backForwardList.backList.count == 0 ? false : true
    }

    private func recordURL() {
        guard let url = webView.url else {
            return
        }
    }

    private func changeURL(_ url: URL) {
        refreshURL()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change else { return }
        if context != &myContext {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        if keyPath == Keys.estimatedProgress {
            if let progress = (change[NSKeyValueChangeKey.newKey] as AnyObject).floatValue {
                progressView.progress = progress
                progressView.isHidden = progress == 1
            }
        } else if keyPath == Keys.URL {
            if let url = webView.url {
                self.browserNavBar?.textField.text = url.absoluteString
                changeURL(url)
            }
        }
    }

    deinit {
        webView.removeObserver(self, forKeyPath: Keys.estimatedProgress)
        webView.removeObserver(self, forKeyPath: Keys.URL)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        browserNavBar?.browserDelegate = self
        refreshURL()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addBackItem()

        NotificationCenter.default.addObserver(self, selector: #selector(collectDapp), name: NSNotification.Name.init("JLocalNotification_JLCollectDappSuccess"), object: nil)
        
        view.addSubview(navigationBar)
        
        view.addSubview(webView)
        injectUserAgent()

        webView.addSubview(progressView)
        webView.bringSubviewToFront(progressView)
        
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(view)
            make.height.equalTo(UIApplication.shared.statusBarFrame.size.height + 44)
        }
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        progressView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.equalTo(webView.snp.leading)
            make.trailing.equalTo(webView.snp.trailing)
            make.height.equalTo(2.0)
        }
        
        webView.addObserver(self, forKeyPath: Keys.estimatedProgress, options: .new, context: &myContext)
        webView.addObserver(self, forKeyPath: Keys.URL, options: [.new, .initial], context: &myContext)
        
        guard (webUrl != nil) else { return }

        /// 授权申请视图
        if isNeedShowApplyForAuthorisation() {
            showApplyForAuthorisationView()
        }else {
            goTo(url: webUrl!)
        }
    }
    
    private func isNeedShowApplyForAuthorisation() -> Bool {
        var isNeed = true
        if let arr = UserDefaults.standard.array(forKey: USERDEFAULTS_JL_DAPP_APPLY_FOR_AUTHORISATION), arr.count != 0 {
            for result in arr {
                if let dict = result as? [String: AnyObject] {
                    for (key, value) in dict {
                        if webUrl!.absoluteString == key {
                            if value.boolValue {
                                isNeed = false
                                break
                            }
                        }
                    }
                }
            }
        }
        
        return isNeed
    }
    
    override func backClick() {
        if webView.canGoBack {
            if webView.backForwardList.backList.count != 0 {
                let backWebInitUrl = webView.backForwardList.backList.last?.initialURL.absoluteString.components(separatedBy: "?").first
                let currentWebInitUrl = webView.backForwardList.currentItem?.initialURL.absoluteString.components(separatedBy: "?").first
                if backWebInitUrl == currentWebInitUrl {
                    popVC()
                }else {
                    webView.goBack()
                }
            }else {
                webView.goBack()
            }
        }else {
            popVC()
        }
    }
    
    @objc func collectDapp() {
        isCollect = !isCollect
    }
    
    private func popVC() {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showApplyForAuthorisationView() {
        JLDappApplyForAuthorisationView.show(withDappName: name ?? "", dappImgUrl: imgUrl ?? "", dappWebUrl: webUrl!.absoluteString, superView: view) { [weak self] in
            guard let `self` = self else { return }
            self.popVC()
        } agree: { [weak self] in
            guard let `self` = self else { return }
            self.goTo(url: self.webUrl!)
        }
    }
    
    private func showManagerFaceView() {
        JLDappBrowserManagerView.show(withIsCollect: isCollect, superView: view) { [weak self] itemType in
            guard let `self` = self else { return }
            if itemType == .collect {
                self.delegate?.collectCurrentDapp(with: !self.isCollect)
            }else if itemType == .copy {
                UIPasteboard.general.string = self.webUrl?.absoluteString ?? ""
                JLLoading.shared().showMBSuccessTipMessage("链接已复制", hideTime: 2.0)
            }else if itemType == .refresh {
                self.goTo(url: self.webUrl!)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: EthBrowserNavigationBarDelegate
extension EthBrowserViewController: EthBrowserNavigationBarDelegate {
    func did(action: EthBrowserNavigation) {
        switch action {
        case .goBack:
            break
        case .more:
            break
        case .home:
            break
        case .enter:
            break
        case .beginEditing:
            stopLoading()
        }
    }
}

// MARK: WKNavigationDelegate
extension EthBrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        recordURL()
//        hideErrorView()
        refreshURL()
        print("ethereum webView didFinish url: \(webView.url?.absoluteString ?? "")")
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        hideErrorView()
        print("ethereum webView didCommit url: \(webView.url?.absoluteString ?? "")")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        handleError(error: error)
        refreshURL()
        print("ethereum webView didFail error: \(error) url: \(webView.url?.absoluteString ?? "")")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        handleError(error: error)
        refreshURL()
        print("ethereum webView didFailProvisionalNavigation error: \(error) url: \(webView.url?.absoluteString ?? "")")
    }
}

// MARK: WKUIDelegate
extension EthBrowserViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//        let alertController = UIAlertController.alertController(
//            title: .none,
//            message: message,
//            style: .alert,
//            in: self
//        )
//        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
//            completionHandler()
//        }))
//        self.present(alertController, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
//        let alertController = UIAlertController.alertController(
//            title: .none,
//            message: message,
//            style: .alert,
//            in: navigationController
//        )
//        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
//            completionHandler(true)
//        }))
//        alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: { _ in
//            completionHandler(false)
//        }))
//        self.present(alertController, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
//        let alertController = UIAlertController.alertController(
//            title: .none,
//            message: prompt,
//            style: .alert,
//            in: navigationController
//        )
//        alertController.addTextField { (textField) in
//            textField.text = defaultText
//        }
//        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
//            if let text = alertController.textFields?.first?.text {
//                completionHandler(text)
//            } else {
//                completionHandler(defaultText)
//            }
//        }))
//        alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: { _ in
//            completionHandler(nil)
//        }))
//        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: WKScriptMessageHandler
extension EthBrowserViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let json = message.json
        print("ethereum WKScriptMessage json: ", json)
        guard let command = EthDappAction.fromMessage(message) else { return }
        let requester = DAppRequester(title: webView.title, url: webView.url)
        //TODO: Refactor
//        let token = TokensDataStore.token(for: server)
        if token.valueBalance.value == 0 {
            loadBalance { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case .success(_):
                    let transfer = Transfer(server: self.server, type: .dapp(self.token, requester))
                    let action = EthDappAction.fromCommand(command, transfer: transfer)

                    // 处理信息
                    self.didCall(action: action, callbackID: command.id)
                case .failure(let error):
                    JLLoading.shared().showMBFailedTipMessage(error.localizedDescription, hideTime: 2.0)
                }
            }
        }else {
            let transfer = Transfer(server: server, type: .dapp(token, requester))
            let action = EthDappAction.fromCommand(command, transfer: transfer)

            // 处理信息
            didCall(action: action, callbackID: command.id)
        }
    }
}

extension WKScriptMessage {
    var json: [String: Any] {
        if let string = body as? String,
            let data = string.data(using: .utf8),
            let object = try? JSONSerialization.jsonObject(with: data, options: []),
            let dict = object as? [String: Any] {
            return dict
        } else if let object = body as? [String: Any] {
            return object
        }
        return [:]
    }
}









