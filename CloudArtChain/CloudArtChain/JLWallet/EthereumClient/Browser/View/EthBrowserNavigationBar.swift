//
//  EthBrowserNavigationBar.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import UIKit

protocol EthBrowserNavigationBarDelegate: AnyObject {
    func did(action: EthBrowserNavigation)
}

final class EthBrowserNavigationBar: UINavigationBar {

    let textField = UITextField()
    let moreButton = UIButton()
    let homeButton = UIButton()
    let backButton = UIButton()
    weak var browserDelegate: EthBrowserNavigationBarDelegate?

    private struct Layout {
        static let width: CGFloat = 34
        static let moreButtonWidth: CGFloat = 24
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.autocapitalizationType = .none
        textField.autoresizingMask = .flexibleWidth
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.returnKeyType = .go
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 30))
        textField.leftViewMode = .always
        textField.autoresizingMask = [.flexibleWidth]
        textField.setContentHuggingPriority(.required, for: .horizontal)
        textField.placeholder = NSLocalizedString("browser.url.textfield.placeholder", value: "Search or enter website url", comment: "")
        textField.keyboardType = .webSearch

        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.setImage(UIImage(named: "toolbarMenu"), for: .normal)
        moreButton.addTarget(self, action: #selector(moreAction(_:)), for: .touchUpInside)

        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.setImage(UIImage(named: "browserHome"), for: .normal)
        homeButton.addTarget(self, action: #selector(homeAction(_:)), for: .touchUpInside)

        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "toolbarBack"), for: .normal)
        backButton.addTarget(self, action: #selector(goBackAction), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [
            homeButton,
            .spacerWidth(),
            backButton,
            textField,
            .spacerWidth(),
            moreButton,
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4

        addSubview(stackView)

        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(4.0)
            make.leading.equalTo(layoutGuide.snp.leading).offset(10.0)
            make.trailing.equalTo(layoutGuide.snp.trailing).offset(-10.0)
            make.bottom.equalTo(snp.bottom).offset(-6.0)
        }
        homeButton.snp.makeConstraints { (make) in
            make.width.equalTo(Layout.width)
        }
        backButton.snp.makeConstraints { (make) in
            make.width.equalTo(Layout.width)
        }
        moreButton.snp.makeConstraints { (make) in
            make.width.equalTo(Layout.moreButtonWidth)
        }
    }

    @objc private func goBackAction() {
        browserDelegate?.did(action: .goBack)
    }

    @objc private func moreAction(_ sender: UIView) {
        browserDelegate?.did(action: .more(sender: sender))
    }

    @objc private func homeAction(_ sender: UIView) {
        browserDelegate?.did(action: .home)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EthBrowserNavigationBar: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        browserDelegate?.did(action: .enter(textField.text ?? ""))
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        browserDelegate?.did(action: .beginEditing)
    }
}

