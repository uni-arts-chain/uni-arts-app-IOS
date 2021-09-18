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

enum EthBrowserAction {
    case qrCode
    case changeURL(URL)
    case navigationAction(EthBrowserNavigation)
}

protocol EthBrowserViewControllerDelegate: AnyObject {
    func didCall(action: EthDappAction, callbackID: Int)
    func runAction(action: EthBrowserAction)
    func didVisitURL(url: URL, title: String)
}

final class EthBrowserViewController: JLBaseViewController {
    private var myContext = 0
    let account: EthWalletInfo
    let sessionConfig: EthConfig
    let server: EthRPCServer
    let token: TokenObject
    
    var webUrl: URL?
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
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(
            frame: .zero,
            configuration: self.config
        )
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
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
        account: EthWalletInfo,
        config: EthConfig,
        server: EthRPCServer,
        webUrl: URL? = nil
    ) {
        self.account = account
        self.sessionConfig = config
        self.server = server
        self.webUrl = webUrl
        self.token = TokenObject(
            contract: server.priceID.description,
            name: "Ethereum 钱包",
            coin: server.coin,
            type: .coin,
            symbol: "ETH",
            decimals: server.decimals,
            value: "0",
            isCustom: false
        )

        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(webView)
        injectUserAgent()

        webView.addSubview(progressView)
        webView.bringSubviewToFront(progressView)
        
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        progressView.snp.makeConstraints { (make) in
            make.top.equalTo(view.layoutGuide.snp.top)
            make.leading.equalTo(webView.snp.leading)
            make.trailing.equalTo(webView.snp.trailing)
            make.height.equalTo(2.0)
        }
        
        webView.addObserver(self, forKeyPath: Keys.estimatedProgress, options: .new, context: &myContext)
        webView.addObserver(self, forKeyPath: Keys.URL, options: [.new, .initial], context: &myContext)
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
    
    func goHome() {
        guard let url = URL(string: EthConstants.dappsBrowserURL) else { return }
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
//        hideErrorView()
        webView.load(request)
        browserNavBar?.textField.text = url.absoluteString
    }

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
    }

    private func recordURL() {
        guard let url = webView.url else {
            return
        }
        delegate?.didVisitURL(url: url, title: webView.title ?? "")
    }

    private func changeURL(_ url: URL) {
        delegate?.runAction(action: .changeURL(url))
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        browserNavBar?.browserDelegate = self
        refreshURL()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackItem()
        
        guard (webUrl != nil) else { return }
        goTo(url: webUrl!)
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
    
    private func popVC() {
//        let transition = CATransition()
//        transition.type = CATransitionType.moveIn
//        transition.subtype = CATransitionSubtype.fromBottom
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        self.view.layer.add(transition, forKey: "animation")
        self.navigationController?.popViewController(animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EthBrowserViewController: EthBrowserNavigationBarDelegate {
    func did(action: EthBrowserNavigation) {
        delegate?.runAction(action: .navigationAction(action))
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

extension EthBrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        recordURL()
//        hideErrorView()
        refreshURL()
        print("ethereum webView didFinish")
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        hideErrorView()
        print("ethereum webView didCommit")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        handleError(error: error)
        print("ethereum webView didFail")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        handleError(error: error)
        print("ethereum webView didFailProvisionalNavigation")
    }
}

extension EthBrowserViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let command = EthDappAction.fromMessage(message) else { return }
        let requester = DAppRequester(title: webView.title, url: webView.url)
        //TODO: Refactor
//        let token = TokensDataStore.token(for: server)
        let transfer = Transfer(server: server, type: .dapp(token, requester))
        let action = EthDappAction.fromCommand(command, transfer: transfer)

        delegate?.didCall(action: action, callbackID: command.id)
    }
}









