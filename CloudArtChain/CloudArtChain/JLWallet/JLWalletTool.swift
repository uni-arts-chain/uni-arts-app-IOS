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
    
    @objc init(window: UIWindow) {
        self.window = window
        super.init()
        self.getContacts()
    }
    
    func getRootPresenter() -> RootPresenterProtocol {
        let presenter = RootPresenterFactory.createPresenter(with: window)
        return presenter
    }
    
    @objc func presenterLoadOnLaunch(navigationController: UINavigationController) {
        getRootPresenter().loadOnLaunch(navigationController: navigationController)
    }
    
    @objc func getAccountBalance(balanceBlock: @escaping (String) -> Void) {
        getAccountBalanceFromAccountList(balanceBlock: balanceBlock)
    }
    
    @objc func hasSelectedAccount() -> Bool {
        return getRootPresenter().hasSelectedAccount()
    }
    
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
    
    @objc func showBackupNotice(navigationController: UINavigationController, username: String) {
        guard let backupNotice = JLBackupNoticeViewFactory.createViewForBackupNotice(username: username) else {
            return
        }
        navigationController.pushViewController(backupNotice.controller, animated: true)
    }
    
    @objc func toolShowAccountRestore(_ navigationController: UINavigationController) {
        guard let restorationController = AccountImportViewFactory
            .createViewForOnboarding()?.controller else {
            return
        }

        navigationController.pushViewController(restorationController, animated: true)
    }
    
    @objc func getCurrentAccount() -> JLAccountItem? {
        guard let selectedAccount = SettingsManager.shared.selectedAccount else {
            return nil
        }
        return JLAccountItem(address: selectedAccount.address, cryptoType: selectedAccount.cryptoType, username: selectedAccount.username, publicKeyData: selectedAccount.publicKeyData)
    }
    
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
    
    @objc func fetchExportDataForAddress(address: String, seedBlock: @escaping (String) -> Void) {
        let keychain = Keychain()
        let repository: CoreDataRepository<AccountItem, CDAccountItem> =
            UserDataStorageFacade.shared.createRepository()

        self.seedInteractor = ExportSeedInteractor(keystore: keychain,
                                              repository: AnyDataProviderRepository(repository),
                                              operationManager: OperationManagerFacade.sharedManager)
        self.seedInteractor?.fetchExportSeedDataForAddress(address, seedBlock)
    }
    
    @objc func fetchExportRestoreDataForAddress(address: String, password: String, restoreBlock: @escaping (String) -> Void) {
        let exportJsonWrapper = KeystoreExportWrapper(keystore: Keychain())

        let facade = UserDataStorageFacade.shared
        let repository: CoreDataRepository<AccountItem, CDAccountItem> = facade.createRepository()

        self.restoreInteractor = AccountExportPasswordInteractor(exportJsonWrapper: exportJsonWrapper,
                                                         repository: AnyDataProviderRepository(repository),
                                                         operationManager: OperationManagerFacade.sharedManager)
        
        self.restoreInteractor?.exportAccount(address: address, password: password, restoreBlock: restoreBlock)
    }
    
    @objc func backupMnemonic(address: String, navigationController: UINavigationController) {
        guard let mnemonicView = ExportMnemonicViewFactory.createViewForAddress(address) else {
            return
        }

        navigationController.pushViewController(mnemonicView.controller, animated: true)
    }
    
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
    
    @objc func reloadContacts() {
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
}

extension JLWalletTool {
    @objc func sellOrderCall(collectionId: UInt64, itemId: UInt64, price: String, block:(Bool, String) -> Void) {
        guard let uintPrice = Decimal(string: price)?.toSubstrateAmountUInt64(precision: self.selectedAsset?.precision ?? 0) else { return }
        sellOrderCallSwift(collectionId: collectionId, itemId: itemId, value: 0, price: uintPrice, block: block)
    }
    
    func sellOrderCallSwift(collectionId: UInt64, itemId: UInt64, value: UInt64, price: UInt64, block:(Bool, String) -> Void) {
        let saleOrderCall = CreateSaleOrderCall(collectionId: collectionId, itemId: itemId, value: value, price: price)
        self.transferVC = self.contactsPresenter?.didSelect(contact: self.contactViewModel!, call: saleOrderCall) ?? nil
        if (self.transferVC != nil) {
            block(true, "")
            sellOrderSubmit()
        } else {
            block(false, "")
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
