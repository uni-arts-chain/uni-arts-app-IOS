//
//  JLEthereumTool.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/3.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import CryptoSwift
import TrezorCrypto
import TrustCore
import TrustKeystore

@objcMembers class JLEthereumWalletInfo: NSObject {
    var address: String?
    var type: JLEthereumType?
    var storeKey: String?
    
    override var description: String {
        return "address: \(address ?? ""), type: \(type?.rawValue ?? ""), storeKey: \(storeKey ?? "")"
    }
}

@objcMembers class JLEthereumTool: NSObject {
    static let shared = JLEthereumTool()
    private let keystore = EthKeystore()

    override private init() { }

    /// 获取所有导入或创建的钱包
    /// - Returns: 账户数组信息
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
    /// - Returns: 账户字典信息
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
    ///   - walletInfoDict: 账户信息字典
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
                completion(privateKey, .none)
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
