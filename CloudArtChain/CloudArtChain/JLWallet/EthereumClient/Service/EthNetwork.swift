//
//  EthNetwork.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/15.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import PromiseKit
import Moya
import TrustCore
import TrustKeystore
import JSONRPCKit
import APIKit
import Result
import BigInt

import enum Result.Result

enum EthNetworkProtocolError: LocalizedError {
    case missingContractInfo
}

protocol NetworkProtocol: EthNetworkProtocol {
    func getBalance(address: EthereumAddress) -> Promise<String>
    func tickers(with tokenPrices: [EthTokenPrice]) -> Promise<[EthCoinTicker]>
}

final class EthNetwork: NetworkProtocol {
    
    var provider: MoyaProvider<EthServiceAPI>
    let wallet: EthWalletInfo
    
    init(
        provider: MoyaProvider<EthServiceAPI>,
        wallet: EthWalletInfo) {
        self.provider = provider
        self.wallet = wallet
    }
    
    func getBalance(address: EthereumAddress) -> Promise<String> {
        return Promise { seal in
            provider.request(.getBalance(address: address.description)) { result in
                switch result {
                case .success(let response):
                    do {
                        let balance = try response.mapString()
                        seal.fulfill(balance)
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    func tickers(with tokenPrices: [EthTokenPrice]) -> Promise<[EthCoinTicker]> {
        return Promise { seal in
            let tokensPriceToFetch = EthTokensPrice(
                currency: EthConfig.current.currency.rawValue,
                tokens: tokenPrices
            )
            provider.request(.getTokensPrice(tokensPriceToFetch)) { result in
                switch result {
                case .success(let response):
                    do {
                        let rawTickers = try response.map(EthPricesResponse<EthCoinTicker>.self).tickers
                        let tickers = rawTickers.compactMap { self.getTickerFrom($0, tokenPrices) }
                        seal.fulfill(tickers)
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    private func getTickerFrom(_ rawTicker: EthCoinTicker, _ tokenPrices: [EthTokenPrice]) -> EthCoinTicker? {
        let tokenPrice: [EthTokenPrice] = tokenPrices.filter { (tokenPrice) -> Bool in
            return tokenPrice.symbol.lowercased() == rawTicker.symbol.lowercased()
        }
        if !tokenPrice.isEmpty {
//            guard let contract = EthereumAddress(string: tokenPrice.first!.contract) else { return .none }
            return EthCoinTicker(
                price: rawTicker.price,
                percent_change_24h: String(rawTicker.change_24h.doubleValue * 100),
                contract: EthereumAddress.zero,
                tickersKey: EthCoinTickerKeyMaker.makeCurrencyKey(),
                base: rawTicker.base,
                symbol: rawTicker.symbol,
                change_24h: rawTicker.change_24h,
                provider: rawTicker.provider,
                id: rawTicker.id
            )
        }
        return nil
    }
}
