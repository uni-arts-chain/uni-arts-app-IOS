/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation

func dispatchInQueueWhenPossible(_ queue: DispatchQueue?, block: @escaping () -> Void ) {
    if let queue = queue {
        queue.async(execute: block)
    } else {
        block()
    }
}
