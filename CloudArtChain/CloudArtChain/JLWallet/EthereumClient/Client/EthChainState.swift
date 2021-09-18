//
//  EthChainState.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import BigInt

final class EthChainState {

    struct Keys {
        static let latestBlock = "chainID"
        static let gasPrice = "gasPrice"
    }

    let server: EthRPCServer

    private var latestBlockKey: String {
        return "\(server.chainID)-" + Keys.latestBlock
    }

    private var gasPriceBlockKey: String {
        return "\(server.chainID)-" + Keys.gasPrice
    }

    var chainStateCompletion: ((Bool, Int) -> Void)?

    var latestBlock: Int {
        get {
            return defaults.integer(forKey: latestBlockKey)
        }
        set {
            defaults.set(newValue, forKey: latestBlockKey)
        }
    }
    var gasPrice: BigInt? {
        get {
            guard let value = defaults.string(forKey: gasPriceBlockKey) else { return .none }
            return BigInt(value, radix: 10)
        }
        set { defaults.set(newValue?.description, forKey: gasPriceBlockKey) }
    }

    let defaults: UserDefaults

    var updateLatestBlock: Timer?

    init(
        server: EthRPCServer
    ) {
        self.server = server
        self.defaults = EthConfig.current.defaults
        fetch()
    }

    func start() {
        fetch()
    }

    @objc func fetch() {
        getLastBlock()
        getGasPrice()
    }

    private func getLastBlock() {
        EthWalletRPCService(server: server).getLastBlock().done { number in
            self.latestBlock = number
            self.chainStateCompletion?(true, number)
        }.catch { error in
            self.chainStateCompletion?(false, 0)
        }
    }

    private func getGasPrice() {
        EthWalletRPCService(server: server).getGasPrice().done { balance in
            self.gasPrice = BigInt(balance)
        }.catch { error in
            self.gasPrice = 0
        }
    }

    func confirmations(fromBlock: Int) -> Int? {
        guard fromBlock > 0 else { return nil }
        let block = latestBlock - fromBlock
        guard latestBlock != 0, block >= 0 else { return nil }
        return max(1, block)
    }
}
