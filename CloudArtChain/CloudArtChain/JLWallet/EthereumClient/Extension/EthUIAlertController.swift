//
//  EthUIAlertController.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import UIKit
import Result

enum ConfirmationError: LocalizedError {
    case cancel
}

extension UIAlertController {

    static func askPassword(
        title: String = "",
        message: String = "",
        completion: @escaping (Result<String, ConfirmationError>) -> Void
    ) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: NSLocalizedString("OK", value: "OK", comment: ""), style: .default, handler: { _ -> Void in
            let textField = alertController.textFields![0] as UITextField
            let password = textField.text ?? ""
            completion(.success(password))
        })
        okAction.setValue(UIColor(hex: "00C3C4"), forKey: "_titleTextColor")
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            completion(.failure(.cancel))
        })
        cancelAction.setValue(UIColor(hex: "00C3C4"), forKey: "_titleTextColor")
        alertController.addAction(cancelAction)
        alertController.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = NSLocalizedString("Password", value: "Password", comment: "")
            textField.isSecureTextEntry = true
        })
        return alertController
    }

    static func alertController(
        title: String? = .none,
        message: String? = .none,
        style: UIAlertController.Style,
        in navigationController: JLNavigationViewController
    ) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.popoverPresentationController?.sourceView = navigationController.view
        alertController.popoverPresentationController?.sourceRect = navigationController.view.centerRect
        return alertController
    }
    
    static func alertController(
        title: String? = .none,
        message: String? = .none,
        in navigationController: JLNavigationViewController
    ) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.popoverPresentationController?.sourceView = navigationController.view
        alertController.popoverPresentationController?.sourceRect = navigationController.view.centerRect
        let confirmAction = UIAlertAction(title: "确定", style: .default) { (_) in
            
        }
        confirmAction.setValue(UIColor(hex: "00C3C4"), forKey: "_titleTextColor")
        alertController.addAction(confirmAction)
        return alertController
    }
}
