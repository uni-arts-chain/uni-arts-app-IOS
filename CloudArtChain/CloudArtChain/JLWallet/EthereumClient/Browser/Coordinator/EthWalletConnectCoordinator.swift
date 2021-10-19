//
//  EthWalletConnectCoordinator.swift
//  CloudArtChain
//
//  Created by jielian on 2021/10/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import BigInt
import TrustCore
import TrustKeystore
import Result
import WalletConnect

enum EthWalletConnectError: Error {
    case jsonFail
    case notFindAccount
    case passwordAuthenticationFailed
}

class EthWalletConnectCoordinator {
    let keystore: EthKeystore
    let server: EthRPCServer
    let transactionData: Data
    let viewController: UIViewController
    
    var didCompletion: ((Result<EthSentTransaction, Error>) -> Void)?
    
    init(
        keystore: EthKeystore,
        server: EthRPCServer,
        transactionData: Data,
        viewController: UIViewController
    ) {
        self.keystore = keystore
        self.server = server
        self.transactionData = transactionData
        self.viewController = viewController
    }
    
    deinit {
        print("ethereum deinit EthWalletConnectCoordinator")
    }
    
    func excuteTranscation() {
        print("ethereum excuteTranscation")
        loadBalance { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let token):
                print("ethereum get balance success")
                let requester = DAppRequester(title: .none, url: .none)
                let transfer = Transfer(server: self.server, type: .dapp(token, requester))
                guard let dict = try? JSONSerialization.jsonObject(with: self.transactionData, options: []) as? [String: AnyObject] else { return }

                let uncomfird = self.makeUnconfirmedTransaction(dict, transfer: transfer)
                let action = EthDappAction.signTransaction(uncomfird)
                print("ethereum didCall 处理信息")
                // 处理信息
                self.didCall(action: action)
            case .failure(let error):
                print("ethereum get balance failure")
                JLLoading.shared().showMBFailedTipMessage(error.localizedDescription, hideTime: 2.0)
                if self.didCompletion != nil {
                    self.didCompletion!(.failure(error))
                }
            }
        }
    }
    
    /// 获取账户余额
    private func loadBalance(_ completion: @escaping (Result<TokenObject, Error>) -> Void) {
        print("ethereum loadBalance")
        guard let walletInfo = keystore.recentlyUsedWalletInfo,
              let ethAddress = walletInfo.address as? EthereumAddress else {
                print("ethereum accountNotFound")
            completion(.failure(EthKeystoreError.accountNotFound))
            return
        }
        print("ethereum loadBalance rpc")
        EthWalletRPCService(server: server, addressUpdate: ethAddress).getBalance().done {  balance in
            print("ethereum balance",balance)
            let token = TokenObject(
                contract: self.server.priceID.description,
                name: "Ethereum",
                coin: self.server.coin,
                type: .coin,
                symbol: self.server.symbol,
                decimals: self.server.decimals,
                value: String(balance.value.magnitude),
                isCustom: false
            )
            
            completion(.success(token))
        }.catch { error in
            print("ethereum get eth balance error: ", error)
            completion(.failure(error))
        }
    }
    
    private func didCall(action: EthDappAction) {
        guard let account = keystore.recentlyUsedWalletInfo?.currentAccount, let _ = account.wallet else {
            if self.didCompletion != nil {
                self.didCompletion!(.failure(EthWalletConnectError.notFindAccount))
            }
            return
        }
        JLEthereumTool.shared.authorize(animated: true, cancellable: true) { isSuccess in
//            guard let `self` = self else { return }
            if isSuccess {
                switch action {
                case .signTransaction(let unconfirmedTransaction):
                    self.executeTransaction(account: account, action: action, transaction: unconfirmedTransaction, type: .signThenSend, server: self.server)
                case .sendTransaction(let unconfirmedTransaction):
                    self.executeTransaction(account: account, action: action, transaction: unconfirmedTransaction, type: .signThenSend, server: self.server)
                case .signMessage(let hexMessage):
                    self.signMessage(with: .message(Data(hex: hexMessage)), account: account)
                case .signPersonalMessage(let hexMessage):
                    self.signMessage(with: .personalMessage(Data(hex: hexMessage)), account: account)
                case .signTypedMessage(let typedData):
                    self.signMessage(with: .typedMessage(typedData), account: account)
                case .unknown:
                    break
                }
            }else {
                if self.didCompletion != nil {
                    self.didCompletion!(.failure(EthWalletConnectError.passwordAuthenticationFailed))
                }
            }
        }
    }
    
    private func signMessage(with type: EthSignMesageType, account: Account) {
        let coordinator = EthSignMessageCoordinator(
            viewController: self.viewController,
            keystore: keystore,
            account: account
        )
        coordinator.didComplete = { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
//                let callback: EthDappCallback
//                switch type {
//                case .message:
//                    callback = EthDappCallback(id: callbackID, value: .signMessage(data))
//                case .personalMessage:
//                    callback = EthDappCallback(id: callbackID, value: .signPersonalMessage(data))
//                case .typedMessage:
//                    callback = EthDappCallback(id: callbackID, value: .signTypedMessage(data))
//                }
//                self.notifyFinish(callbackID: callbackID, value: .success(callback))
            break
            case .failure:
//                self.notifyFinish(callbackID: callbackID, value: .failure(EthDAppError.cancelled))
            break
            }
            coordinator.didComplete = nil
        }
        coordinator.delegate = self
        coordinator.start(with: type)
    }
    
    private func executeTransaction(account: Account, action: EthDappAction, transaction: EthUnconfirmedTransaction, type: EthConfirmType, server: EthRPCServer) {
        print("ethereum executeTransaction")
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
        coordinator.didCompleted = { result in
//            guard let `self` = self else { return }
            switch result {
            case .success(let type):
                switch type {
                case .signedTransaction(let transaction):
                    if self.didCompletion != nil {
                        self.didCompletion!(.success(transaction))
                    }
                case .sentTransaction(let transaction):
                    if self.didCompletion != nil {
                        self.didCompletion!(.success(transaction))
                    }
                }
            case .failure(let error):
                if self.didCompletion != nil {
                    self.didCompletion!(.failure(error))
                }
            }
            coordinator.didCompleted = nil
        }
        
        let confirmVC = EthConfirmPaymentViewController(keystore: keystore, configurator: configurator, confirmType: type, server: server)
        confirmVC.didCompleted = { result in
            switch result {
            case .success(let data):
                coordinator.didCompleted?(.success(data))
            case .failure(let error):
                coordinator.didCompleted?(.failure(error))
            }
        }
        let nav = JLNavigationViewController(rootViewController: confirmVC)
        nav.modalPresentationStyle = .fullScreen
        confirmVC.modalPresentationStyle = .fullScreen
        self.viewController.present(nav, animated: true, completion: nil)
    }
}

extension EthWalletConnectCoordinator: EthSignMessageCoordinatorDelegate {
    func didCancel(in coordinator: EthSignMessageCoordinator) {
        coordinator.didComplete = nil
    }
}

extension EthWalletConnectCoordinator {
    
    func makeUnconfirmedTransaction(_ object: [String: AnyObject], transfer: Transfer) -> EthUnconfirmedTransaction {
        let to = EthereumAddress(string: object["to"] as? String ?? "")
        let value = BigInt((object["value"] as? String ?? "0").drop0x, radix: 16) ?? BigInt()
        let nonce: BigInt? = {
            guard let value = object["nonce"] as? String else { return .none }
            return BigInt(value.drop0x, radix: 16)
        }()
        let gasLimit: BigInt? = {
            guard let value = object["gasLimit"] as? String ?? object["gas"] as? String else { return .none }
            return BigInt((value).drop0x, radix: 16)
        }()
        let gasPrice: BigInt? = {
            guard let value = object["gasPrice"] as? String else { return .none }
            return BigInt((value).drop0x, radix: 16)
        }()
        let data = Data(hex: object["data"] as? String ?? "0x")
        
        print("ethereum unconfirmed transaction value:\(EthBalance(value: value).amountFull),,,nonce:\(String(describing: nonce)),,,gasLimit:\(String(describing: gasLimit)),,,gasPrice:\(String(describing: gasPrice)),,,to:\(String(describing: to?.eip55String))")
        return EthUnconfirmedTransaction(
            transfer: transfer,
            value: value,
            to: to,
            data: data,
            gasLimit: gasLimit,
            gasPrice: gasPrice,
            nonce: nonce
        )
    }
}
