//
//  JLBackupNoticeProtocols.swift
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/21.
//  Copyright © 2021 朱彬. All rights reserved.
//

import SoraFoundation

protocol JLBackupNoticeViewProtocol: ControllerBackedProtocol {
    func set(viewModel: InputViewModelProtocol)
}

protocol JLBackupNoticePresenterProtocol: class {
    func setup()
    func proceed()
    func skip()
    func defaultCreateWalletProceed()
}

protocol JLBackupNoticeWireframeProtocol: AlertPresentable {
    func proceed(from view: JLBackupNoticeViewProtocol?, username: String)
    func proceedDefaultCreateWallet(from view: JLBackupNoticeViewProtocol?, username: String)
}

protocol JLBackupNoticViewFactoryProtocol: class {
    static func createViewForBackupNotice(username: String) -> JLBackupNoticeViewProtocol?
    static func createViewForBackupNoticeDefaultCreateWallet(username: String) -> JLBackupNoticeViewProtocol?
}
