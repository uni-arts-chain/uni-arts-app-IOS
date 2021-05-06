//
//  JLAppDelegate.swift
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

import Foundation
import UIKit
import CommonWallet
import SoraKeystore
import RobinHood
import IrohaCrypto
import SoraFoundation
import BigInt
import FearlessUtils

private let authorization = UUID().uuidString

private struct AuthorizationConstants {
    static var completionBlockKey: String = "co.jp.fearless.auth.delegate"
    static var authorizationViewKey: String = "co.jp.fearless.auth.view"
}

class JLWalletTool: NSObject, ScreenAuthorizationWireframeProtocol {
    var window: UIWindow!
    var seedInteractor: ExportSeedInteractor?
    var restoreInteractor: AccountExportPasswordInteractor?
    var contactViewModel: ContactViewModel?
    var selectedAsset: WalletAsset?
    var contactsPresenter: ContactsPresenter?
    var transferVC: TransferViewController?
    var confirmVC: WalletNewFormViewController?
    var metadata: RuntimeMetadata?
    
    @objc init(window: UIWindow) {
        self.window = window
        super.init()
        self.getGenisisHash { genisisHash in
            print("genisisHash: \(genisisHash)")
            if let tempGenisisHash = genisisHash {
                let tempData = try! Data(hexString: tempGenisisHash)
                UserDefaults.standard.set(tempData.toHex(includePrefix:false), forKey: "JLGenisisHash")
                UserDefaults.standard.synchronize()
            }
        }
        self.getMetadata()
        self.getContacts()
    }
    
    @objc func getAssetPrecision() -> Int16 {
        return self.selectedAsset?.precision ?? 0
    }
    
    func getRootPresenter() -> RootPresenterProtocol {
        let presenter = RootPresenterFactory.createPresenter(with: window)
        return presenter
    }
    
    // 显示当前钱包
    @objc func presenterLoadOnLaunch(navigationController: UINavigationController, userAvatar: String?) {
        getRootPresenter().loadOnLaunch(navigationController: navigationController, userAvatar: userAvatar)
    }
    
    // 默认创建钱包
    @objc func defaultCreateWallet(navigationController: UINavigationController, userAvatar: String?) {
        getRootPresenter().defaultCreateWallet(navigationController: navigationController, userAvatar: userAvatar)
    }
    
    // 获取账户余额
    @objc func getAccountBalance(balanceBlock: @escaping (String) -> Void) {
        getAccountBalanceFromAccountList(balanceBlock: balanceBlock)
    }
    // 是否有账户
    @objc func hasSelectedAccount() -> Bool {
        return getRootPresenter().hasSelectedAccount()
    }
    
    // 是否设置密码
    @objc func pincodeExists() -> Bool {
        return getRootPresenter().pincodeExists()
    }
    // 获取账户余额
    func getAccountBalanceFromAccountList(balanceBlock: @escaping (String) -> Void) {
        let updateBlock: ([WalletViewModelProtocol]) -> Void = { models in
            if models.count > 0 {
                let viewModel = models[1]
                if let assetViewModel = viewModel as? WalletAssetViewModel {
                    balanceBlock(assetViewModel.amount)
                }
            }
        }
        getRootPresenter().getAccountBalance(balanceBlock: updateBlock)
    }
    // 显示备份钱包提示
    @objc func showBackupNotice(navigationController: UINavigationController, username: String) {
        guard let backupNotice = JLBackupNoticeViewFactory.createViewForBackupNotice(username: username) else {
            return
        }
        navigationController.pushViewController(backupNotice.controller, animated: true)
    }
    // 默认创建钱包 备份钱包提示
    @objc func showBackupNoticeDefaultCreateWallet(navigationController: UINavigationController, username: String) {
        guard let backupNotice = JLBackupNoticeViewFactory.createViewForBackupNoticeDefaultCreateWallet(username: username) else {
            return
        }
        navigationController.pushViewController(backupNotice.controller, animated: false)
        (backupNotice.controller as! JLBackupNoticeViewController).defaultCreateWallet()
    }
    
    @objc func toolShowAccountRestore(_ navigationController: UINavigationController) {
        guard let restorationController = AccountImportViewFactory
            .createViewForOnboarding()?.controller else {
            return
        }

        navigationController.pushViewController(restorationController, animated: true)
    }
    // 获取当前账户
    @objc func getCurrentAccount() -> JLAccountItem? {
        guard let selectedAccount = SettingsManager.shared.selectedAccount else {
            return nil
        }
        return JLAccountItem(address: selectedAccount.address, cryptoType: selectedAccount.cryptoType, username: selectedAccount.username, publicKeyData: selectedAccount.publicKeyData)
    }
    // 保存钱包名称
    @objc func saveUsername(username: String, address: String) {
        let facade = UserDataStorageFacade.shared
        let mapper = ManagedAccountItemMapper()
        let repository = facade.createRepository(mapper: AnyCoreDataMapper(mapper))

        let interactor = AccountInfoInteractor(repository: AnyDataProviderRepository(repository),
                                               settings: SettingsManager.shared,
                                               keystore: Keychain(),
                                               eventCenter: EventCenter.shared,
                                               operationManager: OperationManagerFacade.sharedManager)
        
        interactor.performUsernameSave(username, address: address)
        
        if
            let selectedAccount = interactor.settings.selectedAccount, selectedAccount.address == address {
            let newSelectedAccount = selectedAccount.replacingUsername(username)
            SettingsManager.shared.selectedAccount = newSelectedAccount
        }
    }
    // 验证密码
    @objc func authorize(animated: Bool,
                   cancellable: Bool,
                   with completionBlock: @escaping AuthorizationCompletionBlock) {

        guard !isAuthorizing else {
            return
        }

        guard let presentingController = UIApplication.shared.keyWindow?
            .rootViewController?.topModalViewController else {
            return
        }

        guard let authorizationView = PinViewFactory.createScreenAuthorizationView(with: self,
                                                                                   cancellable: cancellable) else {
            completionBlock(false)
            return
        }

        self.completionBlock = completionBlock
        self.authorizationView = authorizationView

        authorizationView.controller.modalTransitionStyle = .crossDissolve
        authorizationView.controller.modalPresentationStyle = .fullScreen
        presentingController.present(authorizationView.controller, animated: animated, completion: nil)
    }
    // 导出私钥
    @objc func fetchExportDataForAddress(address: String, seedBlock: @escaping (String) -> Void) {
        let keychain = Keychain()
        let repository: CoreDataRepository<AccountItem, CDAccountItem> =
            UserDataStorageFacade.shared.createRepository()

        self.seedInteractor = ExportSeedInteractor(keystore: keychain,
                                              repository: AnyDataProviderRepository(repository),
                                              operationManager: OperationManagerFacade.sharedManager)
        self.seedInteractor?.fetchExportSeedDataForAddress(address, seedBlock)
    }
    // 导出KeyStore
    @objc func fetchExportRestoreDataForAddress(address: String, password: String, restoreBlock: @escaping (String) -> Void) {
        let exportJsonWrapper = KeystoreExportWrapper(keystore: Keychain())

        let facade = UserDataStorageFacade.shared
        let repository: CoreDataRepository<AccountItem, CDAccountItem> = facade.createRepository()

        self.restoreInteractor = AccountExportPasswordInteractor(exportJsonWrapper: exportJsonWrapper,
                                                         repository: AnyDataProviderRepository(repository),
                                                         operationManager: OperationManagerFacade.sharedManager)
        
        self.restoreInteractor?.exportAccount(address: address, password: password, restoreBlock: restoreBlock)
    }
    // 导出助记词
    @objc func backupMnemonic(address: String, navigationController: UINavigationController) {
        guard let mnemonicView = ExportMnemonicViewFactory.createViewForAddress(address) else {
            return
        }

        navigationController.pushViewController(mnemonicView.controller, animated: true)
    }
    // 修改密码
    @objc func changePinSetup(from: UINavigationController) {
        authorize(animated: true, cancellable: true) { (success) in
            if success {
                guard let pinSetup = PinViewFactory.createPinChangeView() else {
                    return
                }

                pinSetup.controller.hidesBottomBarWhenPushed = true

                from.pushViewController(pinSetup.controller, animated: true)
            }
        }
    }
    // 重新加载用户数据
    @objc func reloadContacts() {
        getRootPresenter()
        self.getContacts()
    }
    
    func getContacts() {
        let contactBlock: (ContactListViewModelProtocol, WalletAsset, ContactsPresenter) -> Void = { [weak self] (listViewModel, selectedAsset, contactsPresenter) in
            if listViewModel.numberOfSections > 0 {
                self?.contactViewModel = listViewModel[IndexPath(row: 0, section: 0)] as? ContactViewModel
                self?.selectedAsset = selectedAsset
//                let receiveInfo = ReceiveInfo(accountId: contactViewModel.accountId,
//                                              assetId: selectedAsset.identifier,
//                                              amount: nil,
//                                              details: nil)
//
//                let payload = TransferPayload(receiveInfo: receiveInfo,
//                                              receiverName: contactViewModel.name)
//                try? listViewModel[IndexPath(row: 0, section: 0)]?.command?.execute()
                self?.contactsPresenter = contactsPresenter
            }
        }
        let updateBlock: ([WalletViewModelProtocol]) -> Void = { models in
            if models.count > 0 {
                let viewModel = models[2]
                if let actionsViewModel = viewModel as? WalletActionsViewModel {
                    try! actionsViewModel.send.command.getModelsExecute(contactBlock: contactBlock)
                }
            }
        }
        getRootPresenter().getAccountBalance(balanceBlock: updateBlock)
    }
    // 账户签名
    @objc func accountSign(originData: Data) throws -> String {
        let accountSigner = SigningWrapper(keystore: Keychain(), settings: SettingsManager.shared)
        let signature = try accountSigner.sign(originData)
        return signature.rawData().toHex(includePrefix: true)
    }
}

/** 取消拍卖 */
extension JLWalletTool {
    @objc func cancelAuctionCall(collectionId: UInt64, itemId: UInt64, block:(Bool, String) -> Void) {
        cancelAuctionCallSwift(collectionId: collectionId, itemId: itemId, block: block)
    }
    
    func cancelAuctionCallSwift(collectionId: UInt64, itemId: UInt64, block:(Bool, String) -> Void) {
        let cancelAuctionCall = CancelAuctionCall(collectionId: collectionId, itemId: itemId)
//        self.transferVC = self.contactsPresenter?.didSelect(contact: self.contactViewModel!, call: cancelAuctionCall, callIndex: Chain.uniarts.cancelAuctionCallIndex) ?? nil
        if let tempMetaData = self.metadata, let moduleIndex = tempMetaData.getModuleIndex("Nft"), let callIndex = tempMetaData.getCallIndex(in: "Nft", callName: "cancel_auction") {
            self.transferVC = self.contactsPresenter?.didSelect(contact: self.contactViewModel!, call: cancelAuctionCall, moduleIndex: moduleIndex, callIndex: callIndex) ?? nil
            if (self.transferVC != nil) {
                block(true, "")
                createAuctionSubmit()
            } else {
                block(false, "")
            }
        } else {
            block(false, "不存在Metadata")
        }
    }
    
    @objc func cancelAuctionCallConfirm(callbackBlock: @escaping (Bool, String?) -> Void) {
        self.confirmVC?.presenter.jlperformAction(callbackBlock: callbackBlock)
    }
}

/** 发起拍卖 */
extension JLWalletTool {
    @objc func createAuctionCall(collectionId: UInt64, itemId: UInt64, price: String, increment: String, startTime: UInt32, endTime: UInt32, block: (Bool, String) -> Void) {
        guard let uintPrice = Decimal(string: price)?.toSubstrateAmountUInt64(precision: self.selectedAsset?.precision ?? 0) else { return }
        guard let unitIncrement = Decimal(string: increment)?.toSubstrateAmountUInt64(precision: self.selectedAsset?.precision ?? 0) else { return }
        createAuctionCallSwift(collectionId: collectionId, itemId: itemId, value: 0, price: uintPrice, increment: unitIncrement, startTime: startTime, endTime: endTime, block: block)
    }
    
    func createAuctionCallSwift(collectionId: UInt64, itemId: UInt64, value: UInt64, price: UInt64, increment: UInt64, startTime: UInt32, endTime: UInt32, block: (Bool, String) -> Void) {
        let createAuctionCall = CreateAuctionCall(collectionId: collectionId, itemId: itemId, value: value, startPrice: price, increment: increment, startTime: startTime, endTime: endTime)
//        self.transferVC = self.contactsPresenter?.didSelect(contact: self.contactViewModel!, call: createAuctionCall, callIndex: Chain.uniarts.createAuctionCallIndex) ?? nil
        if let tempMetaData = self.metadata, let moduleIndex = tempMetaData.getModuleIndex("Nft"), let callIndex = tempMetaData.getCallIndex(in: "Nft", callName: "create_auction") {
            self.transferVC = self.contactsPresenter?.didSelect(contact: self.contactViewModel!, call: createAuctionCall, moduleIndex: moduleIndex, callIndex: callIndex) ?? nil
            if (self.transferVC != nil) {
                block(true, "")
                createAuctionSubmit()
            } else {
                block(false, "")
            }
        } else {
            block(false, "不存在Metadata")
        }
    }
    
    @objc func createAuctionSubmit() {
        let callbackBlock: (WalletNewFormViewController?) -> Void = { [weak self] confirmViewController in
            self?.confirmVC = confirmViewController
        }
        self.transferVC?.presenter.proceed(callbackBlock: callbackBlock)
    }
    
    @objc func createAuctionConfirm(callbackBlock: @escaping (Bool, String?) -> Void) {
        self.confirmVC?.presenter.jlperformAction(callbackBlock: callbackBlock)
    }
    
    @objc func createAuctionCancel() {
        self.transferVC = nil
        self.confirmVC = nil
    }
}

/** 拍卖出价 */
extension JLWalletTool {
    @objc func auctionBidCall(collectionId: UInt64, itemId: UInt64, block:@escaping (Bool, String?) -> Void) {
        let auctionBidCall = AuctionBidCall(collectionId: collectionId, itemId: itemId)
//        self.transferVC = self.contactsPresenter?.didSelect(contact: self.contactViewModel!, call: auctionBidCall, callIndex: Chain.uniarts.bidCallIndex) ?? nil
        if let tempMetadata = self.metadata, let moduleIndex = tempMetadata.getModuleIndex("Nft"), let callIndex = tempMetadata.getCallIndex(in: "Nft", callName: "bid") {
            self.transferVC = self.contactsPresenter?.didSelect(contact: self.contactViewModel!, call: auctionBidCall, moduleIndex: moduleIndex, callIndex: callIndex) ?? nil
            if (self.transferVC != nil) {
                auctionBidSubmit(block: block)
            } else {
                block(false, "")
            }
        } else {
            block(false, "不存在Metadata")
        }
    }
    
    @objc func auctionBidSubmit(block:@escaping (Bool, String?) -> Void) {
        let callbackBlock: (WalletNewFormViewController?) -> Void = { [weak self] confirmViewController in
            self?.confirmVC = confirmViewController
            self?.auctionBidConfirm(callbackBlock: block)
        }
        self.transferVC?.presenter.proceed(callbackBlock: callbackBlock)
    }
    
    @objc func auctionBidConfirm(callbackBlock: @escaping (Bool, String?) -> Void) {
        self.confirmVC?.presenter.jlperformAction(callbackBlock: callbackBlock)
    }
    
    @objc func auctionBidCancel() {
        self.transferVC = nil
        self.confirmVC = nil
    }
}

/** 购买作品 */
extension JLWalletTool {
    @objc func acceptSaleOrderCall(collectionId: UInt64, itemId: UInt64, block:(Bool, String) -> Void) {
        let acceptSaleOrderCall = AcceptSaleOrderCall(collectionId: collectionId, itemId: itemId)
//        self.transferVC = self.contactsPresenter?.didSelect(contact: self.contactViewModel!, call: acceptSaleOrderCall, callIndex: Chain.uniarts.acceptSaleOrderCallIndex) ?? nil
        if let tempMetadata = self.metadata, let moduleIndex = tempMetadata.getModuleIndex("Nft"), let callIndex = tempMetadata.getCallIndex(in: "Nft", callName: "accept_sale_order") {
            self.transferVC = self.contactsPresenter?.didSelect(contact: self.contactViewModel!, call: acceptSaleOrderCall, moduleIndex: moduleIndex, callIndex: callIndex) ?? nil
            if (self.transferVC != nil) {
                block(true, "")
                acceptSaleOrderSubmit()
            } else {
                block(false, "")
            }
        } else {
            block(false, "不存在Metadata")
        }
    }
    
    @objc func acceptSaleOrderSubmit() {
        let callbackBlock: (WalletNewFormViewController?) -> Void = { [weak self] confirmViewController in
            self?.confirmVC = confirmViewController
        }
        self.transferVC?.presenter.proceed(callbackBlock: callbackBlock)
    }
    
    @objc func acceptSaleOrderConfirm(callbackBlock: @escaping (Bool, String?) -> Void) {
        self.confirmVC?.presenter.jlperformAction(callbackBlock: callbackBlock)
    }
    
    @objc func acceptSaleOrderCancel() {
        self.transferVC = nil
        self.confirmVC = nil
    }
}

/** 作品出售 */
extension JLWalletTool {
    @objc func productSellCall(accountId: String ,collectionId: UInt64, itemId: UInt64, value: String, block:(Bool, String) -> Void) {
        guard let unitValue = Decimal(string: value)?.toSubstrateAmountUInt64(precision: 0) else { return }
        let transferAccountId = AccountId(accountId: accountId)
        productSellCallSwift(accountId: transferAccountId, collectionId: collectionId, itemId: itemId, value: unitValue, block: block)
    }
    
    func productSellCallSwift(accountId: AccountId, collectionId: UInt64, itemId: UInt64, value: UInt64, block:(Bool, String) -> Void) {
        let productSellTransferCall = ProductSellTransferCall(recipient: accountId, collectionId: collectionId, itemId: itemId, value: value)
//        self.transferVC = self.contactsPresenter?.didSelect(contact: self.contactViewModel!, call: saleOrderCall, callIndex: Chain.uniarts.createSaleOrderCallIndex) ?? nil
        if let tempMetadata = self.metadata, let moduleIndex = tempMetadata.getModuleIndex("Nft"), let callIndex = tempMetadata.getCallIndex(in: "Nft", callName: "transfer") {
            self.transferVC = self.contactsPresenter?.didSelect(contact: self.contactViewModel!, call: productSellTransferCall, moduleIndex: moduleIndex, callIndex: callIndex) ?? nil
            if (self.transferVC != nil) {
                block(true, "")
                productSellSubmit()
            } else {
                block(false, "")
            }
        } else {
            block(false, "不存在Metadata")
        }
    }
    
    @objc func productSellSubmit() {
        let callbackBlock: (WalletNewFormViewController?) -> Void = { [weak self] confirmViewController in
            self?.confirmVC = confirmViewController
        }
        self.transferVC?.presenter.proceed(callbackBlock: callbackBlock)
    }
    
    @objc func productSellConfirm(block:@escaping (String?) -> Void) {
        if let tempConfirmVC = self.confirmVC {
            tempConfirmVC.presenter.jlperformActionWithSignMessage(signMessageBlock: block)
        } else {
            block(nil)
        }
    }
    
    @objc func productSellCancel() {
        self.transferVC = nil
        self.confirmVC = nil
    }
}

/** 作品上架 */
extension JLWalletTool {
    @objc func sellOrderCall(collectionId: UInt64, itemId: UInt64, price: String, block:(Bool, String) -> Void) {
        guard let uintPrice = Decimal(string: price)?.toSubstrateAmountUInt64(precision: self.selectedAsset?.precision ?? 0) else { return }
        sellOrderCallSwift(collectionId: collectionId, itemId: itemId, value: 0, price: uintPrice, block: block)
    }
    
    func sellOrderCallSwift(collectionId: UInt64, itemId: UInt64, value: UInt64, price: UInt64, block:(Bool, String) -> Void) {
        let saleOrderCall = CreateSaleOrderCall(collectionId: collectionId, itemId: itemId, value: value, price: price)
//        self.transferVC = self.contactsPresenter?.didSelect(contact: self.contactViewModel!, call: saleOrderCall, callIndex: Chain.uniarts.createSaleOrderCallIndex) ?? nil
        if let tempMetadata = self.metadata, let moduleIndex = tempMetadata.getModuleIndex("Nft"), let callIndex = tempMetadata.getCallIndex(in: "Nft", callName: "create_sale_order") {
            self.transferVC = self.contactsPresenter?.didSelect(contact: self.contactViewModel!, call: saleOrderCall, moduleIndex: moduleIndex, callIndex: callIndex) ?? nil
            if (self.transferVC != nil) {
                block(true, "")
                sellOrderSubmit()
            } else {
                block(false, "")
            }
        } else {
            block(false, "不存在Metadata")
        }
    }
    
    @objc func sellOrderSubmit() {
        let callbackBlock: (WalletNewFormViewController?) -> Void = { [weak self] confirmViewController in
            self?.confirmVC = confirmViewController
        }
        self.transferVC?.presenter.proceed(callbackBlock: callbackBlock)
    }
    
    @objc func sellOrderConfirm(callbackBlock: @escaping (Bool, String?) -> Void) {
        self.confirmVC?.presenter.jlperformAction(callbackBlock: callbackBlock)
    }
    
    @objc func sellOrderCancel() {
        self.transferVC = nil
        self.confirmVC = nil
    }
}

/** 作品下架 */
extension JLWalletTool {
    @objc func cancelSellOrderCall(collectionId: UInt64, itemId: UInt64, block:(Bool, String) -> Void) {
        cancelSellOrderCallSwift(collectionId: collectionId, itemId: itemId, value: 0, block: block)
    }
    
    func cancelSellOrderCallSwift(collectionId: UInt64, itemId: UInt64, value: UInt64, block:(Bool, String) -> Void) {
        let cancelSaleOrderCall = CancelSaleOrderCall(collectionId: collectionId, itemId: itemId, value: value)
//        self.transferVC = self.contactsPresenter?.didSelect(contact: self.contactViewModel!, call: cancelSaleOrderCall, callIndex: Chain.uniarts.cancelSaleOrderCallIndex) ?? nil
        if let tempMetadata = self.metadata, let moduleIndex = tempMetadata.getModuleIndex("Nft"), let callIndex = tempMetadata.getCallIndex(in: "Nft", callName: "cancel_sale_order") {
            self.transferVC = self.contactsPresenter?.didSelect(contact: self.contactViewModel!, call: cancelSaleOrderCall, moduleIndex: moduleIndex, callIndex: callIndex) ?? nil
            if (self.transferVC != nil) {
                block(true, "")
                sellOrderSubmit()
            } else {
                block(false, "")
            }
        } else {
            block(false, "不存在Metadata")
        }
    }
    
    @objc func cancelSellOrderConfirm(callbackBlock: @escaping (Bool, String?) -> Void) {
        self.confirmVC?.presenter.jlperformAction(callbackBlock: callbackBlock)
    }
}

/** 输入密码 */
extension JLWalletTool {
    func showAuthorizationCompletion(with result: Bool) {
        guard let completionBlock = completionBlock else {
            return
        }

        self.completionBlock = nil

        guard let authorizationView = authorizationView else {
            return
        }

        authorizationView.controller.presentingViewController?.dismiss(animated: true) {
            self.authorizationView = nil
            completionBlock(result)
        }
    }
}

extension JLWalletTool {
    private var completionBlock: AuthorizationCompletionBlock? {
        get {
            return objc_getAssociatedObject(authorization, &AuthorizationConstants.completionBlockKey)
                as? AuthorizationCompletionBlock
        }

        set {
            objc_setAssociatedObject(authorization,
                                     &AuthorizationConstants.completionBlockKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN)
        }
    }

    private var authorizationView: PinSetupViewProtocol? {
        get {
            return objc_getAssociatedObject(authorization, &AuthorizationConstants.authorizationViewKey)
                as? PinSetupViewProtocol
        }

        set {
            objc_setAssociatedObject(authorization,
                                     &AuthorizationConstants.authorizationViewKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN)
        }
    }

    private var isAuthorizing: Bool {
        return authorizationView != nil
    }
}

extension JLWalletTool {
    /** 获取当前 block number */
    @objc func getBlock(blockNumberBlock: @escaping (UInt32) -> Void) {
        let logger = Logger.shared
        let operationQueue = OperationQueue()
        let engine = WebSocketEngine(url: ConnectionItem.defaultConnection.url, logger: logger)
        
        let operation = JSONRPCListOperation<SignedBlock>(engine: engine, method: RPCMethod.getChainBlock, parameters: nil)
        let operationsWrapper = CompoundOperationWrapper(targetOperation: operation)
        operationsWrapper.targetOperation.completionBlock = {
            DispatchQueue.main.async {
                do {
                    let result = try operation.extractResultData(throwing: BaseOperationError.parentOperationCancelled)
                    let blockNumberData = try Data(hexString: result.block.header.number)
                    let blockNumber = UInt32(BigUInt(blockNumberData))
                    blockNumberBlock(blockNumber)
                } catch {
                    blockNumberBlock(UInt32(Date().timeIntervalSince1970 / 6))
                }
            }
        }
        operationQueue.addOperations(operationsWrapper.allOperations, waitUntilFinished: false)
    }
    
    /** 获取作品拍卖信息 */
    @objc func performAuctionInfo(collectionID: UInt64, itemID: UInt64, auctionDataBlock: @escaping (AuctionInfo?) -> Void) {
        let logger = Logger.shared
        let operationQueue = OperationQueue()
        let engine = WebSocketEngine(url: ConnectionItem.defaultConnection.url, logger: logger)
        
        var collectionInt = collectionID
        let collectionData: Data = Data(bytes: &collectionInt, count: MemoryLayout<UInt64>.size)
        
        var itemInt = itemID
        let itemData: Data = Data(bytes: &itemInt, count: MemoryLayout<UInt64>.size)
        
        do {
            let key = try (StorageKeyFactory().auctionList() + (collectionData.blake128Concat() + itemData.blake128Concat())).toHex(includePrefix: true)
      
            let operation = JSONRPCListOperation<JSONScaleDecodable<AuctionInfo>>(engine: engine,
                                                                                  method: RPCMethod.getStorage,
                                                                                  parameters: [key])
            let operationsWrapper = CompoundOperationWrapper(targetOperation: operation)
            operationsWrapper.targetOperation.completionBlock = {
                DispatchQueue.main.async {
                    do {
                        let result = try operation.extractResultData(throwing: BaseOperationError.parentOperationCancelled)

                        guard let aunctionData = result.underlyingValue else {
                            auctionDataBlock(nil)
                            return
                        }
                        auctionDataBlock(aunctionData)
                    } catch {
                        auctionDataBlock(nil)
                    }
                }
            }
            operationQueue.addOperations(operationsWrapper.allOperations, waitUntilFinished: false)
        } catch {
            auctionDataBlock(nil)
        }
    }
    
    /** 获取作品出价列表 */
    @objc func performAuctionBidList(auctionInfo: AuctionInfo, bidListBlock: @escaping (Array<BidHistory>) -> Void) {
        let logger = Logger.shared
        let operationQueue = OperationQueue()
        let engine = WebSocketEngine(url: ConnectionItem.defaultConnection.url, logger: logger)
        
        var auctionId = auctionInfo.id
        let auctionIdData: Data = Data(bytes: &auctionId, count: MemoryLayout<UInt64>.size)
        
        do {
            let key = try (StorageKeyFactory().auctionBidHistoryList() + auctionIdData).toHex(includePrefix: true)
            let operation = JSONRPCListOperation<JSONScaleListDecodable>(engine: engine,
                                                                                  method: RPCMethod.getStorage,
                                                                                  parameters: [key])
            
            let operationsWrapper = CompoundOperationWrapper(targetOperation: operation)
            operationsWrapper.targetOperation.completionBlock = {
                do {
                    let result = try operation.extractResultData(throwing: BaseOperationError.parentOperationCancelled)
                    guard let auctionList = result.underlyingValue else {
                        bidListBlock(Array())
                        return
                    }
                    bidListBlock(auctionList)
                } catch {
                    bidListBlock(Array())
                }
            }
            operationQueue.addOperations(operationsWrapper.allOperations, waitUntilFinished: false)
        } catch {
            bidListBlock(Array())
        }
    }
    
    /** 获取metadata数据 */
    func getMetadata() {
        let logger = Logger.shared
        let operationQueue = OperationQueue()

        let engine = WebSocketEngine(url: ConnectionItem.defaultConnection.url, logger: logger)
        
        let operation = JSONRPCOperation<[String], String>(engine: engine, method: RPCMethod.getMetaData)
        let operationsWrapper = CompoundOperationWrapper(targetOperation: operation)
        operationsWrapper.targetOperation.completionBlock = { [weak self] in
            do {
                let result = try operation.extractResultData(throwing: BaseOperationError.parentOperationCancelled)
                let rawMetadata = try Data(hexString: result)
                let decoder = try ScaleDecoder(data: rawMetadata)
                let tempMetaData = try RuntimeMetadata(scaleDecoder: decoder)
                self?.metadata = tempMetaData
            } catch {
                print("Unexpected error: \(error)")
            }
        }
        operationQueue.addOperations(operationsWrapper.allOperations, waitUntilFinished: false)
    }
    
    /** 获取GenisisHash */
    func getGenisisHash(genisisHashBlock: @escaping (String?) -> Void) {
        let logger = Logger.shared
        let operationQueue = OperationQueue()
        let engine = WebSocketEngine(url: ConnectionItem.defaultConnection.url, logger: logger)
        
        var currentBlock: UInt32 = 0
        
        let param = Data(Data(bytes: &currentBlock, count: MemoryLayout<UInt32>.size).reversed())
                    .toHex(includePrefix: true)
        let operation = JSONRPCListOperation<String>(engine: engine,method: RPCMethod.getBlockHash, parameters: [param])
        
        let operationsWrapper = CompoundOperationWrapper(targetOperation: operation)
        operationsWrapper.targetOperation.completionBlock = {
            do {
                let result = try operation.extractResultData(throwing: BaseOperationError.parentOperationCancelled)
                genisisHashBlock(result)
            } catch {
                genisisHashBlock(nil)
            }
        }
        operationQueue.addOperations(operationsWrapper.allOperations, waitUntilFinished: false)
    }
}
