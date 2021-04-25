/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/
import FearlessUtils

protocol ContactsViewProtocol: ControllerBackedProtocol, AlertPresentable {
    
    func set(listViewModel: ContactListViewModelProtocol)
    func set(barViewModel: WalletBarActionViewModelProtocol)
    func didStartSearch()
    func didStopSearch()
}


protocol ContactsPresenterProtocol: class {

    func setup()
    func search(_ pattern: String)

}


protocol ContactsCoordinatorProtocol: class {
    
    func send(to payload: TransferPayload)
    func send(to payload: TransferPayload, call: ScaleCodable, moduleIndex: UInt8, callIndex: UInt8) -> TransferViewController?
    func sendToGetSignMessage(to payload: TransferPayload, call: ScaleCodable, moduleIndex: UInt8, callIndex: UInt8, signMessageBlock: @escaping (String?) -> Void) -> TransferViewController?
    func scanInvoice()
    
}


protocol ContactsAssemblyProtocol: class {
    
    static func assembleView(with resolver: ResolverProtocol,
                             selectedAsset: WalletAsset) -> ContactsViewProtocol?
    
    static func assembleView(with resolver: ResolverProtocol,
                             selectedAsset: WalletAsset,
                             contactBlock: @escaping (ContactListViewModelProtocol, WalletAsset, ContactsPresenter) -> Void) -> ContactsViewProtocol?
    
}
