//
//  JLBackupNoticeViewController.swift
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/21.
//  Copyright © 2021 朱彬. All rights reserved.
//

import UIKit
import SoraFoundation
import SoraUI

final class JLBackupNoticeViewController: JLBaseViewController {
    var presenter: JLBackupNoticePresenterProtocol!

    @IBOutlet weak var noticeFirstLabel: UILabel!
    @IBOutlet weak var noticeSecondLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    private var viewModel: InputViewModelProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "备份提示"
        self.addBackItem()
        
        presenter.setup()
        
        self.setupNavi()
        
        self .setupViews()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        presenter.proceed()
    }
    
    func defaultCreateWallet() {
        presenter.defaultCreateWalletProceed()
    }
    
    private func setupNavi() {
        let title = "稍后备份"
        let rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(skipBackup))
        let dic = [NSAttributedString.Key.foregroundColor: UIColor(hex: "38B2F1"), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
        rightBarButtonItem.setTitleTextAttributes(dic, for: .normal)
        rightBarButtonItem.setTitleTextAttributes(dic, for: .highlighted)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func skipBackup() {
        presenter.skip()
    }
    
    private func setupViews() {
        self.nextButton.layer.cornerRadius = 23.0
        self.nextButton.layer.masksToBounds = true
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5.0
        
        let noticeFirstAttr = NSMutableAttributedString(string: self.noticeFirstLabel.text ?? "")
        noticeFirstAttr.addAttributes([NSAttributedString.Key.paragraphStyle: paragraph], range: NSRange(location: 0, length: (self.noticeFirstLabel.text ?? "").count))
        self.noticeFirstLabel.attributedText = noticeFirstAttr
        
        let noticeSecondAttr = NSMutableAttributedString(string: self.noticeSecondLabel.text ?? "")
        noticeSecondAttr.addAttributes([NSAttributedString.Key.paragraphStyle: paragraph], range: NSRange(location: 0, length: (self.noticeSecondLabel.text ?? "").count))
        self.noticeSecondLabel.attributedText = noticeSecondAttr
    }
}

extension JLBackupNoticeViewController: JLBackupNoticeViewProtocol {
    func set(viewModel: InputViewModelProtocol) {
        self.viewModel = viewModel
    }
}

extension JLBackupNoticeViewController: Localizable {
    private func setupLocalization() {
        
    }

    func applyLocalization() {
        if isViewLoaded {
            setupLocalization()
            view.setNeedsLayout()
        }
    }
}
