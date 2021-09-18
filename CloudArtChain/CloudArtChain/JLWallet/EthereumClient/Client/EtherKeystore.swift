//
//  EthKeystore.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/3.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import BigInt
import KeychainSwift
import CryptoSwift
import TrustCore
import TrustKeystore
import Result

let JLEthereumSelectWallet = "JLEthereumSelectWallet"
let JLEthereumImportAddress = "JLEthereumImportAddress"

class EthKeystore:EthKeystoreProtocol {
    struct Keys {
        static let recentlyUsedAddress: String = "recentlyUsedAddress"
        static let recentlyUsedWallet: String = "recentlyUsedWallet"
    }

    private let keychain: KeychainSwift
    private let datadir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    var keyStore: KeyStore
    private let defaultKeychainAccess: KeychainSwiftAccessOptions = .accessibleWhenUnlockedThisDeviceOnly
    let keysDirectory: URL
    let userDefaults = UserDefaults.standard
    var recentlyUsedWalletInfo: EthWalletInfo? {
        set {
            userDefaults.setValue(newValue?.storeKey, forKey: JLEthereumSelectWallet)
            userDefaults.synchronize()
        }
        get {
            guard let walletKey = userDefaults.value(forKey: JLEthereumSelectWallet) as? String else {
                return .none
            }
            let foundWallet = walletInfos.filter { $0.storeKey == walletKey }.first
            guard let wallet = foundWallet else {
                return .none
            }
            return wallet
        }
    }
    var walletInfos: [EthWalletInfo] {
        var addressWalletInfo = [EthWalletInfo]()
        if let addresses = userDefaults.array(forKey: JLEthereumImportAddress) {
            for address in addresses {
                if let dict = address as? [String: String] {
                    for (key, value) in dict {
                        if let etherumAddress = EthereumAddress(string: value) {
                            addressWalletInfo.append(EthWalletInfo(type: .address(Coin.ethereum, etherumAddress), storeKey: key))
                        }
                    }
                }
            }
        }
        return [
            keyStore.wallets.filter { !$0.accounts.isEmpty }.compactMap {
                switch $0.type {
                case .encryptedKey:
                    return EthWalletInfo(type: .privateKey($0), storeKey: $0.keyURL.lastPathComponent)
                case .hierarchicalDeterministicWallet:
                    return EthWalletInfo(type: .hd($0), storeKey: $0.keyURL.lastPathComponent)
                }
            }.filter { !$0.accounts.isEmpty }, addressWalletInfo
        ].flatMap { $0 }.sorted(by: { $0.storeKey < $1.storeKey })
    }

    init(
        keychain: KeychainSwift = KeychainSwift(keyPrefix: EthConstants.keychainKeyPrefix),
        keysSubfolder: String = "/EthKeystore"
    ) {
        self.keysDirectory = URL(fileURLWithPath: datadir + keysSubfolder)
        self.keychain = keychain
        self.keyStore = try! KeyStore(keyDirectory: keysDirectory)
        print("ethereum dir: ", keysDirectory)
    }
    
    /// 创建账户
    /// - Parameter completion: 完成后回调
    func createAccount(completion: @escaping (Result<Wallet, EthKeystoreError>) -> Void) {
        let password = EthPasswordGenerator.generateRandom()
        self.createAccount(with: password, completion: completion)
    }
    
    /// 选择账户
    /// - Parameters:
    ///   - storeKey: 保存到本地的账户key
    ///   - completion: 完成后回调
    func chooseWallet(with storeKey: String, completion: @escaping (Result<Bool, EthKeystoreError>) -> Void) {
        for walletInfo in walletInfos {
            if storeKey == walletInfo.storeKey {
                switch walletInfo.type {
                case .address:
                    chooseAddressWallet(with: storeKey, completion: completion)
                case .privateKey, .hd:
                    choosePrivateKeyOrHDWallet(with: storeKey, completion: completion)
                }
                return
            }
        }
        completion(.failure(.chooseWalletNotFind))
    }
    
    /// 选择地址导入的账户
    /// - Parameters:
    ///   - storeKey: 保存到本地的账户key
    ///   - completion: 完成后回调
    private func chooseAddressWallet(with storeKey: String, completion: @escaping (Result<Bool, EthKeystoreError>) -> Void) {
        if let addresses = userDefaults.array(forKey: JLEthereumImportAddress) {
            for address in addresses {
                let dict = address as! [String: String]
                for (key, value) in dict {
                    if key == storeKey, let etherumAddress = EthereumAddress(string: value) {
                        let walletInfo = EthWalletInfo(type: .address(Coin.ethereum, etherumAddress), storeKey: key)
                        recentlyUsedWalletInfo = walletInfo

                        completion(.success(true))
                        return
                    }
                }
            }
        }
        completion(.failure(.chooseWalletNotFind))
    }
    
    /// 选择非地址导入的账户
    /// - Parameters:
    ///   - storeKey: 保存到本地的账户key
    ///   - completion: 完成后回调
    private func choosePrivateKeyOrHDWallet(with storeKey: String, completion: @escaping (Result<Bool, EthKeystoreError>) -> Void) {
        for wallet in keyStore.wallets {
            if wallet.keyURL.lastPathComponent == storeKey {
                switch wallet.type {
                case .encryptedKey:
                    let walletInfo = EthWalletInfo(type: .privateKey(wallet), storeKey: storeKey)
                    recentlyUsedWalletInfo = walletInfo
                case .hierarchicalDeterministicWallet:
                    let walletInfo = EthWalletInfo(type: .hd(wallet), storeKey: storeKey)
                    recentlyUsedWalletInfo = walletInfo
                }
                completion(.success(true))
                return
            }
        }
        completion(.failure(.chooseWalletNotFind))
    }

    private func saveImportAddress(for storeKey: String, address: String) {
        var addressArr: [[String: String]] = []
        if let addresses = userDefaults.array(forKey: JLEthereumImportAddress) {
            for address in addresses {
                addressArr.append(address as! [String : String])
            }
        }
        let dict: [String: String] = [storeKey: address]
        addressArr.append(dict)
        userDefaults.setValue(addressArr, forKey: JLEthereumImportAddress)
        userDefaults.synchronize()
    }

    private func makeAccountURL(for address: String) -> URL {
        return keysDirectory.appendingPathComponent(generateFileName(identifier: address))
    }

    private func generateFileName(identifier: String, date: Date = Date(), timeZone: TimeZone = .current) -> String {
        return "UTC--\(filenameTimestamp(for: date, in: timeZone))--\(identifier)"
    }

    private func filenameTimestamp(for date: Date, in timeZone: TimeZone = .current) -> String {
        var tz = ""
        let offset = timeZone.secondsFromGMT()
        if offset == 0 {
            tz = "Z"
        } else {
            tz = String(format: "%03d00", offset/60)
        }

        let components = Calendar(identifier: .iso8601).dateComponents(in: timeZone, from: date)
        return String(format: "%04d-%02d-%02dT%02d-%02d-%02d.%09d%@", components.year!, components.month!, components.day!, components.hour!, components.minute!, components.second!, components.nanosecond!, tz)
    }
}

// MARK: 创建钱包或导入钱包
extension EthKeystore {
    /// 创建以太坊钱包
    @available(iOS 10.0, *)
    func createAccount(with password: String, completion: @escaping (Result<Wallet, EthKeystoreError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let account = self.createAccout(password: password)
            DispatchQueue.main.async {
                completion(.success(account))
            }
        }
    }
    /// 创建账户(根据32字节私钥)
    func createAccout(password: String) -> Wallet {
        let derivationPaths = EthConfig.current.servers.map { $0.derivationPath(at: 0) }
        let wallet = try! keyStore.createWallet(
            password: password,
            derivationPaths: derivationPaths
        )
        let _ = setPassword(password, for: wallet)
        recentlyUsedWalletInfo = EthWalletInfo(type: .hd(wallet), storeKey: wallet.keyURL.lastPathComponent)
        return wallet
    }
    /// 导入钱包
    func importWallet(type: EthImportType, coin: Coin, completion: @escaping (Result<EthWalletInfo, EthKeystoreError>) -> Void) {
        // 获取新的32字节私钥
        let newPassword = EthPasswordGenerator.generateRandom()
        switch type {
        case .keystore(let string, let password):
            importKeystore(
                value: string,
                password: password,
                newPassword: newPassword,
                coin: coin
            ) { result in
                switch result {
                case .success(let wallet):
                    let walletInfo = EthWalletInfo(type: .privateKey(wallet), storeKey: wallet.keyURL.lastPathComponent)
                    self.recentlyUsedWalletInfo = walletInfo
                    completion(.success(walletInfo))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case .privateKey(let privateKey):
            if let data = Data(hexStr: privateKey),
               let privateKeyData = PrivateKey(data: data) {
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        let wallet = try self.keyStore.import(privateKey: privateKeyData, password: newPassword, coin: coin)
                        self.setPassword(newPassword, for: wallet)
                        let walletInfo = EthWalletInfo(type: .privateKey(wallet), storeKey: wallet.keyURL.lastPathComponent)
                        self.recentlyUsedWalletInfo = walletInfo
                        DispatchQueue.main.async {
                            completion(.success(walletInfo))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(EthKeystoreError.failedToImportPrivateKey))
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(EthKeystoreError.failedToImportPrivateKey))
                }
            }
        case .mnemonic(let words, let passphrase, let derivationPath):
            let string = words.map { String($0) }.joined(separator: " ")
            if !Crypto.isValid(mnemonic: string) {
                return completion(.failure(EthKeystoreError.invalidMnemonicPhrase))
            }
            do {
                let wallet = try keyStore.import(mnemonic: string, passphrase: passphrase, encryptPassword: newPassword, derivationPath: derivationPath)
                setPassword(newPassword, for: wallet)
                let walletInfo = EthWalletInfo(type: .hd(wallet), storeKey: wallet.keyURL.lastPathComponent)
                self.recentlyUsedWalletInfo = walletInfo
                completion(.success(walletInfo))
            } catch {
                return completion(.failure(EthKeystoreError.duplicateAccount))
            }
        case .address(let address):
            let walletInfo = EthWalletInfo(type: .address(coin, address), storeKey: makeAccountURL(for: address.description).lastPathComponent)
            saveImportAddress(for: walletInfo.storeKey, address: address.description)
            self.recentlyUsedWalletInfo = walletInfo
            completion(.success(walletInfo))
        }
    }
    /// 导入钱包(keystore 结果回调)
    func importKeystore(value: String, password: String, newPassword: String, coin: Coin, completion: @escaping (Result<Wallet, EthKeystoreError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = self.importKeystore(value: value, password: password, newPassword: newPassword, coin: coin)
            DispatchQueue.main.async {
                switch result {
                case .success(let account):
                    completion(.success(account))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    /// 导入钱包(keystore 结果返回)
    func importKeystore(value: String, password: String, newPassword: String, coin: Coin) -> Result<Wallet, EthKeystoreError> {
        guard let data = value.data(using: .utf8) else {
            return (.failure(.failedToParseJSON))
        }
        do {
            let wallet = try keyStore.import(json: data, password: password, newPassword: newPassword, coin: coin)
            let _ = setPassword(newPassword, for: wallet)
            return .success(wallet)
        } catch {
            if case KeyStore.Error.accountAlreadyExists = error {
                return .failure(.duplicateAccount)
            } else {
                return .failure(.failedToImport(error))
            }
        }
    }

    func getPassword(for account: Wallet) -> String? {
        let key = keychainKey(for: account)
        return keychain.get(key)
    }
    @discardableResult
    func setPassword(_ password: String, for account: Wallet) -> Bool {
        let key = keychainKey(for: account)
        return keychain.set(password, forKey: key, withAccess: defaultKeychainAccess)
    }
    internal func keychainKey(for account: Wallet) -> String {
        return account.identifier
    }
}

// MARK: 导出钱包相关信息
extension EthKeystore {
    /// 导出钱包(根据账户和密码 返回结果)
    func export(account: Account, password: String, newPassword: String) -> Result<String, EthKeystoreError> {
        let result = self.exportData(account: account, password: password, newPassword: newPassword)
        switch result {
        case .success(let data):
            let string = String(data: data, encoding: .utf8) ?? ""
             return .success(string)
        case .failure(let error):
             return .failure(error)
        }
    }
    /// 导出钱包(根据账户和密码 回调结果)
    func export(account: Account, password: String, newPassword: String, completion: @escaping (Result<String, EthKeystoreError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = self.export(account: account, password: password, newPassword: newPassword)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    /// 导出钱包JSON(根据账户和密码 返回结果)
    func exportData(account: Account, password: String, newPassword: String) -> Result<Data, EthKeystoreError> {
        do {
            let data = try keyStore.export(wallet: account.wallet!, password: password, newPassword: newPassword)
            return (.success(data))
        } catch {
            return (.failure(.failedToDecryptKey))
        }
    }
    /// 导出钱包私钥(根据账户和密码 回调结果)
    func exportPrivateKey(account: Account, completion: @escaping (Result<String, EthKeystoreError>) -> Void) {
        guard let password = getPassword(for: account.wallet!) else {
            return completion(.failure(EthKeystoreError.accountNotFound))
        }
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let privateKey = try account.privateKey(password: password).description
                DispatchQueue.main.async {
                    completion(.success(privateKey))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(EthKeystoreError.accountNotFound))
                }
            }
        }
    }
    /// 导出钱包助记词(根据账户和密码 回调结果)
    func exportMnemonic(wallet: Wallet, completion: @escaping (Result<[String], EthKeystoreError>) -> Void) {
        guard let password = getPassword(for: wallet) else {
            return completion(.failure(EthKeystoreError.accountNotFound))
        }
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let mnemonic = try  self.keyStore.exportMnemonic(wallet: wallet, password: password)
                let words = mnemonic.components(separatedBy: " ")
                DispatchQueue.main.async {
                    completion(.success(words))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(EthKeystoreError.notHDAccount))
                }
            }
        }
    }
}

// MARK: 签名消息
extension EthKeystore {
    func signPersonalMessage(_ data: Data, for account: Account) -> Result<Data, EthKeystoreError> {
        let prefix = "\u{19}Ethereum Signed Message:\n\(data.count)".data(using: .utf8)!
        return signMessage(prefix + data, for: account)
    }

    func signMessage(_ message: Data, for account: Account) -> Result<Data, EthKeystoreError> {
        return signHash(message.sha3(.keccak256), for: account)
    }

    func signTypedMessage(_ datas: [EthTypedData], for account: Account) -> Result<Data, EthKeystoreError> {
        let schemas = datas.map { $0.schemaData }.reduce(Data(), { $0 + $1 }).sha3(.keccak256)
        let values = datas.map { $0.typedData }.reduce(Data(), { $0 + $1 }).sha3(.keccak256)
        let combined = (schemas + values).sha3(.keccak256)
        return signHash(combined, for: account)
    }

    func signHash(_ hash: Data, for account: Account) -> Result<Data, EthKeystoreError> {
        guard
            let password = getPassword(for: account.wallet!) else {
                return .failure(EthKeystoreError.failedToSignMessage)
        }
        do {
            var data = try account.sign(hash: hash, password: password)
            // TODO: Make it configurable, instead of overriding last byte.
            data[64] += 27
            return .success(data)
        } catch {
            return .failure(EthKeystoreError.failedToSignMessage)
        }
    }

    func signTransaction(_ transaction: EthSignTransaction) -> Result<Data, EthKeystoreError> {
        let account = transaction.account
        guard let wallet  = account.wallet, let password = getPassword(for: wallet) else {
            return .failure(.failedToSignTransaction)
        }
        let signer: EthSigner
//        signer = HomesteadSigner()
//        if transaction.chainID == 0 {
//            signer = HomesteadSigner()
//        } else {
//            signer = EIP155Signer(chainId: BigInt(transaction.chainID))
//        }
        if transaction.chainID == 0 {
            signer = EIP155Signer(chainId: BigInt(transaction.chainID))
        } else {
            signer = HomesteadSigner()
        }

        do {
            let hash = signer.hash(transaction: transaction)
            let signature = try account.sign(hash: hash, password: password)
            let (r, s, v) = signer.values(transaction: transaction, signature: signature)
            let data = RLP.encode([
                transaction.nonce,
                transaction.gasPrice,
                transaction.gasLimit,
                transaction.to?.data ?? Data(),
                transaction.value,
                transaction.data,
                v, r, s,
            ])!
            return .success(data)
        } catch {
            return .failure(.failedToSignTransaction)
        }
    }
}
