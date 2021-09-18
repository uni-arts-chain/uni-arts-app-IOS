//
//  EthKeystoreProtocol.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/3.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import TrustKeystore
import TrustCore
import Result

protocol EthKeystoreProtocol {
    @available(iOS 10.0, *)
    func createAccount(with password: String, completion: @escaping (Result<Wallet, EthKeystoreError>) -> Void)
    func importWallet(type: EthImportType, coin: Coin, completion: @escaping (Result<EthWalletInfo, EthKeystoreError>) -> Void)
    func createAccout(password: String) -> Wallet
    func importKeystore(value: String, password: String, newPassword: String, coin: Coin, completion: @escaping (Result<Wallet, EthKeystoreError>) -> Void)
    func importKeystore(value: String, password: String, newPassword: String, coin: Coin) -> Result<Wallet, EthKeystoreError>
    func export(account: Account, password: String, newPassword: String) -> Result<String, EthKeystoreError>
    func export(account: Account, password: String, newPassword: String, completion: @escaping (Result<String, EthKeystoreError>) -> Void)
    func exportData(account: Account, password: String, newPassword: String) -> Result<Data, EthKeystoreError>
    func exportPrivateKey(account: Account, completion: @escaping (Result<String, EthKeystoreError>) -> Void)
    func exportMnemonic(wallet: Wallet, completion: @escaping (Result<[String], EthKeystoreError>) -> Void)
    func signPersonalMessage(_ data: Data, for account: Account) -> Result<Data, EthKeystoreError>
    func signMessage(_ message: Data, for account: Account) -> Result<Data, EthKeystoreError>
    func signTypedMessage(_ datas: [EthTypedData], for account: Account) -> Result<Data, EthKeystoreError>
    func signHash(_ hash: Data, for account: Account) -> Result<Data, EthKeystoreError>
    func signTransaction(_ transaction: EthSignTransaction) -> Result<Data, EthKeystoreError>
    func getPassword(for account: Wallet) -> String?
    func setPassword(_ password: String, for account: Wallet) -> Bool
}
