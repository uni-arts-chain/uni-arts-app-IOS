//
//  JLBackupNoticePresenter.swift
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/21.
//  Copyright © 2021 朱彬. All rights reserved.
//

import Foundation
import SoraFoundation

class JLBackupNoticePresenter : NSObject {
    weak var view: JLBackupNoticeViewProtocol?
    var wireframe: JLBackupNoticeWireframeProtocol!

    private var viewModel: InputViewModelProtocol = {
        let inputHandling = InputHandler(predicate: NSPredicate.notEmpty,
                                         processor: ByteLengthProcessor.username)
        return InputViewModel(inputHandler: inputHandling)
    }()
}

extension JLBackupNoticePresenter: JLBackupNoticePresenterProtocol {
    func setup() {
        view?.set(viewModel: viewModel)
    }
    
    func proceed() {
        let value = viewModel.inputHandler.value
        self.wireframe.proceed(from: self.view, username: value)
    }
    
    func skip() {
        
    }
    
    func defaultCreateWalletProceed() {
        let value = viewModel.inputHandler.value
        self.wireframe.proceedDefaultCreateWallet(from: self.view, username: value)
    }
}

extension JLBackupNoticePresenter: Localizable {
    func applyLocalization() {}
}
