//
//  EthConfirmCoordinator.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/17.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import TrustCore
import TrustKeystore
import Result

protocol ConfirmCoordinatorDelegate: AnyObject {
    func didCancel(in coordinator: EthConfirmCoordinator)
}

final class EthConfirmCoordinator {
    let keystore: EthKeystore
    var configurator: EthTransactionConfigurator
    var didCompleted: ((Result<EthConfirmResult, AnyError>) -> Void)?
    let type: EthConfirmType
    let server: EthRPCServer

    weak var delegate: ConfirmCoordinatorDelegate?
    
    lazy var sendTransactionCoordinator = {
        return EthSendTransactionCoordinator(keystore: keystore, confirmType: type, server: server)
    }()
    
    init(
        configurator: EthTransactionConfigurator,
        keystore: EthKeystore,
        type: EthConfirmType,
        server: EthRPCServer
    ) {
        self.configurator = configurator
        self.keystore = keystore
        self.type = type
        self.server = server
    }
    
    func send() {
        let transaction = configurator.signTransaction
        self.sendTransactionCoordinator.send(transaction: transaction) { [weak self] result in
            guard let `self` = self else { return }
            self.didCompleted?(result)
        }
    }
}
