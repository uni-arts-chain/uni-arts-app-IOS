/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation

private struct Constants {
    static var factoryKey: String = "co.jp.sora.ui.modal.presentation.factory"
}

public extension UIViewController {
    var modalTransitioningFactory: UIViewControllerTransitioningDelegate? {
        get {
            transitioningDelegate
        }

        set {
            transitioningDelegate = newValue

            objc_setAssociatedObject(self,
                                     &Constants.factoryKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
