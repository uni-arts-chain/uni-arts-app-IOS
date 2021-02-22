//
//  JLBackupNoticeViewFactory.swift
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/21.
//  Copyright © 2021 朱彬. All rights reserved.
//

import Foundation
import SoraFoundation

final class JLBackupNoticeViewFactory: JLBackupNoticViewFactoryProtocol {
    static func createViewForBackupNotice(username: String) -> JLBackupNoticeViewProtocol? {
        let view = JLBackupNoticeViewController(nibName: "JLBackupNoticeViewController", bundle: Bundle.main)
        let presenter = JLBackupNoticePresenter()
        let wireframe = JLBackupNoticeWireframe()

        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe

        view.localizationManager = LocalizationManager.shared
        presenter.localizationManager = LocalizationManager.shared

        return view
    }
}
