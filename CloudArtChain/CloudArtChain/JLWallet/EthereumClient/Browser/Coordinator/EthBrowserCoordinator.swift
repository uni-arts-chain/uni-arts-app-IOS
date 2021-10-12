//
//  EthBrowserCoordinator.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import UIKit
import BigInt
import TrustKeystore
import WebKit
import Result

//enum EthConfirmType {
//    case sign
//    case signThenSend
//}
//
//enum EthConfirmResult {
//    case signedTransaction(EthSentTransaction)
//    case sentTransaction(EthSentTransaction)
//}

protocol EthBrowserCoordinatorDelegate: class {
    func didSentTransaction(transaction: EthSentTransaction, in coordinator: EthBrowserCoordinator)
    func collectDapp(isCollect: Bool)
}

final class EthBrowserCoordinator: NSObject {
    
    let keystore: EthKeystore
    let navigationController: JLNavigationViewController
    
    var name: String?
    var imgUrl: String?
    var webUrl: URL?
    var isCollect: Bool
    weak var delegate: EthBrowserCoordinatorDelegate?
    
    var urlParser: EthBrowserURLParser {
        let engine = EthSearchEngine(rawValue: UserDefaults.standard.value(forKey: EthPreferenceOption.browserSearchEngine.key) as? Int ?? 0) ?? .default
        return EthBrowserURLParser(engine: engine)
    }
//    lazy var browserViewController: EthBrowserViewController = {
//        let controller = EthBrowserViewController(account: keystore.recentlyUsedWalletInfo!, config: .current, server: .main, name: name, imgUrl: imgUrl, webUrl: webUrl)
//        controller.delegate = self
//        controller.webView.uiDelegate = self
//        return controller
//    }()
    
    init(
        keystore: EthKeystore,
        navigationController: JLNavigationViewController,
        name: String?,
        imgUrl: String?,
        webUrl: URL? = nil,
        isCollect: Bool = false
    ) {
        self.keystore = keystore
        self.navigationController = navigationController
        self.name = name
        self.imgUrl = imgUrl
        self.webUrl = webUrl
        self.isCollect = isCollect
        super.init()
    }
    
    @objc func collectDapp(notification: NSNotification) {
        let userInfo = notification.userInfo as? [String:Bool]
        let isCollect = userInfo?["isCollect"]
        delegate?.collectDapp(isCollect: isCollect ?? false)
    }
    
    func start() {
//        navigationController.modalPresentationStyle = .fullScreen
//        browserViewController.modalPresentationStyle = .fullScreen
//        navigationController.present(browserViewController, animated: true, completion: nil)
        
//        navigationController.pushViewController(browserViewController, animated: true)
    }
    
    func openURL(_ url: URL) {
//        browserViewController.goTo(url: url)
    }
    
    func signMessage(with type: EthSignMesageType, account: Account, callbackID: Int) {
        let coordinator = EthSignMessageCoordinator(
            viewController: navigationController,
            keystore: keystore,
            account: account
        )
        coordinator.didComplete = { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                let callback: EthDappCallback
                switch type {
                case .message:
                    callback = EthDappCallback(id: callbackID, value: .signMessage(data))
                case .personalMessage:
                    callback = EthDappCallback(id: callbackID, value: .signPersonalMessage(data))
                case .typedMessage:
                    callback = EthDappCallback(id: callbackID, value: .signTypedMessage(data))
                }
//                self.browserViewController.notifyFinish(callbackID: callbackID, value: .success(callback))
            case .failure:
//                self.browserViewController.notifyFinish(callbackID: callbackID, value: .failure(EthDAppError.cancelled))
            break
            }
            coordinator.didComplete = nil
        }
        coordinator.delegate = self
        coordinator.start(with: type)
    }
    
    private func executeTransaction(account: Account, action: EthDappAction, callbackID: Int, transaction: EthUnconfirmedTransaction, type: EthConfirmType, server: EthRPCServer) {
        let configurator = EthTransactionConfigurator(
            walletInfo: keystore.recentlyUsedWalletInfo!,
            transaction: transaction,
            server: server,
            chainState: EthChainState(server: server)
        )
        let coordinator = EthConfirmCoordinator(
            configurator: configurator,
            keystore: keystore,
            type: type,
            server: server
        )
        coordinator.didCompleted = { [unowned self] result in
            switch result {
            case .success(let type):
                switch type {
                case .signedTransaction(let transaction):
                    // on signing we pass signed hex of the transaction
                    let callback = EthDappCallback(id: callbackID, value: .signTransaction(transaction.data))
//                    self.browserViewController.notifyFinish(callbackID: callbackID, value: .success(callback))
                    self.delegate?.didSentTransaction(transaction: transaction, in: self)
                case .sentTransaction(let transaction):
                    // on send transaction we pass transaction ID only.
                    let data = Data(hex: transaction.id)
                    let callback = EthDappCallback(id: callbackID, value: .sentTransaction(data))
//                    self.browserViewController.notifyFinish(callbackID: callbackID, value: .success(callback))
                    self.delegate?.didSentTransaction(transaction: transaction, in: self)
                }
            case .failure:
//                self.browserViewController.notifyFinish(
//                    callbackID: callbackID,
//                    value: .failure(EthDAppError.cancelled)
//                )
                break
            }
            coordinator.didCompleted = nil
            self.navigationController.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: EthBrowserViewControllerDelegate
//extension EthBrowserCoordinator: EthBrowserViewControllerDelegate {
//    func runAction(action: EthBrowserAction) {
//        switch action {
//        case .navigationAction(let navAction):
//            switch navAction {
//            case .home:
//                break
//            case .more(let sender):
//                break
//            case .enter(let string):
//                guard let url = urlParser.url(from: string) else { return }
//                openURL(url)
//            case .goBack:
//                browserViewController.webView.goBack()
//            default: break
//            }
//        case .changeURL(let url):
//            break
//        case .qrCode:
//            break
//        }
//    }
//
//    func didCall(action: EthDappAction, callbackID: Int) {
//        guard let account = keystore.recentlyUsedWalletInfo?.currentAccount, let _ = account.wallet else {
//            browserViewController.notifyFinish(callbackID: callbackID, value: .failure(EthDAppError.cancelled))
//            return
//        }
//        switch action {
//        case .signTransaction(let unconfirmedTransaction):
//            executeTransaction(account: account, action: action, callbackID: callbackID, transaction: unconfirmedTransaction, type: .signThenSend, server: browserViewController.server)
//        case .sendTransaction(let unconfirmedTransaction):
//            executeTransaction(account: account, action: action, callbackID: callbackID, transaction: unconfirmedTransaction, type: .signThenSend, server: browserViewController.server)
//        case .signMessage(let hexMessage):
//            signMessage(with: .message(Data(hex: hexMessage)), account: account, callbackID: callbackID)
//        case .signPersonalMessage(let hexMessage):
//            signMessage(with: .personalMessage(Data(hex: hexMessage)), account: account, callbackID: callbackID)
//        case .signTypedMessage(let typedData):
//            signMessage(with: .typedMessage(typedData), account: account, callbackID: callbackID)
//        case .unknown:
//            break
//        }
//    }
//
//    func didVisitURL(url: URL, title: String) {
////        historyStore.record(url: url, title: title)
//    }
//
//    func collectCurrentDapp(with isCollect: Bool) {
//        print("browser 收藏dapp: ", isCollect)
//        delegate?.collectDapp(isCollect: isCollect)
//    }
//}

// MARK: WKUIDelegate
extension EthBrowserCoordinator: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
//            browserViewController.webView.load(navigationAction.request)
        }
        return nil
    }

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController.alertController(
            title: .none,
            message: message,
            style: .alert,
            in: navigationController
        )
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            completionHandler()
        }))
        navigationController.present(alertController, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController.alertController(
            title: .none,
            message: message,
            style: .alert,
            in: navigationController
        )
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            completionHandler(true)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: { _ in
            completionHandler(false)
        }))
        navigationController.present(alertController, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController.alertController(
            title: .none,
            message: prompt,
            style: .alert,
            in: navigationController
        )
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: { _ in
            completionHandler(nil)
        }))
        navigationController.present(alertController, animated: true, completion: nil)
    }
}

// MARK: EthSignMessageCoordinatorDelegate
extension EthBrowserCoordinator: EthSignMessageCoordinatorDelegate {
    func didCancel(in coordinator: EthSignMessageCoordinator) {
        coordinator.didComplete = nil
    }
}
