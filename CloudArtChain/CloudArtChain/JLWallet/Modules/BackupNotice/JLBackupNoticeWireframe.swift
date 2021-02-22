//
//  JLBackupNoticeWireframe.swift
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/21.
//  Copyright © 2021 朱彬. All rights reserved.
//

import UIKit

final class JLBackupNoticeWireframe: JLBackupNoticeWireframeProtocol {
    func proceed(from view: JLBackupNoticeViewProtocol?, username: String) {
        guard let accountCreation = AccountCreateViewFactory.createViewForOnboarding(username: username) else {
            return
        }

        view?.controller.navigationController?.pushViewController(accountCreation.controller,
                                                                  animated: true)
    }
}
