//
//  EthSignMessageCoordinator.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/17.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Result
import TrustCore
import TrustKeystore

enum EthSignMesageType {
    case message(Data)
    case personalMessage(Data)
    case typedMessage([EthTypedData])
}

protocol EthSignMessageCoordinatorDelegate: AnyObject {
    func didCancel(in coordinator: EthSignMessageCoordinator)
}

final class EthSignMessageCoordinator {
    
    let viewController: UIViewController
    let keystore: EthKeystore
    let account: Account

    weak var delegate: EthSignMessageCoordinatorDelegate?
    var didComplete: ((Result<Data, AnyError>) -> Void)?
    
    init(
        viewController: UIViewController,
        keystore: EthKeystore,
        account: Account
    ) {
        self.viewController = viewController
        self.keystore = keystore
        self.account = account
    }
    
    /// 开始确认签名
    func start(with type: EthSignMesageType) {
        let alertController = makeAlertController(with: type)
        viewController.present(alertController, animated: true, completion: nil)
    }

    private func makeAlertController(with type: EthSignMesageType) -> UIAlertController {
        let alertController = UIAlertController(
            title: "确认签名信息?",
            message: message(for: type),
            preferredStyle: .alert
        )
        let signAction = UIAlertAction(
            title: "确定",
            style: .default
        ) { [weak self] _ in
            guard let `self` = self else { return }
            self.handleSignedMessage(with: type)
        }
        signAction.setValue(UIColor(hex: "101010"), forKey: "_titleTextColor")
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { [weak self] _ in
            guard let `self` = self else { return }
            self.didComplete?(.failure(AnyError(EthDAppError.cancelled)))
            self.delegate?.didCancel(in: self)
        }
        cancelAction.setValue(UIColor(hex: "101010"), forKey: "_titleTextColor")
        alertController.addAction(signAction)
        alertController.addAction(cancelAction)
        return alertController
    }

    func message(for type: EthSignMesageType) -> String {
        switch type {
        case .message(let data),
             .personalMessage(let data):
                guard let message = String(data: data, encoding: .utf8) else {
                    return data.hexEncoded
                }
                return message
        case .typedMessage(let (typedData)):
                let string = typedData.map {
                    return "\($0.name) : \($0.value.string)"
                }.joined(separator: "\n")
                return string
        }
    }

    func isMessage(data: Data) -> Bool {
        guard let _ = String(data: data, encoding: .utf8) else { return false }
        return true
    }

    private func handleSignedMessage(with type: EthSignMesageType) {
        let result: Result<Data, EthKeystoreError>
        switch type {
        case .message(let data):
            // FIXME. If hash just sign it, otherwise call sign message
            if isMessage(data: data) {
                result = keystore.signMessage(data, for: account)
            } else {
                result = keystore.signHash(data, for: account)
            }
        case .personalMessage(let data):
            result = keystore.signPersonalMessage(data, for: account)
        case .typedMessage(let typedData):
            if typedData.isEmpty {
                result = .failure(EthKeystoreError.failedToSignMessage)
            } else {
                result = keystore.signTypedMessage(typedData, for: account)
            }
        }
        switch result {
        case .success(let data):
            didComplete?(.success(data))
        case .failure(let error):
            didComplete?(.failure(AnyError(error)))
        }
    }
}
