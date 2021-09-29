//
//  JLEthBrowserNavigationBar.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/29.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import UIKit

protocol JLEthBrowserNavigationBarDelegate: AnyObject {
    func showManagerFace()
    func close()
}

class JLEthBrowserNavigationBar: UIView {
    private let titleLabel = UILabel()
    private let faceView = UIView()
    private let managerBtn = UIButton(type: .system)
    private let closeBtn = UIButton(type: .system)
    private let lineView = UIView()
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    weak var delegate: JLEthBrowserNavigationBarDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
    }
    
    private func configUI() {
        titleLabel.textColor = UIColor(hex: "101010")
        titleLabel.font = UIFont(name: "PingFangSC-Semibold", size: 17)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self)
            make.left.equalTo(self).offset(100)
            make.right.equalTo(self).offset(-100)
            make.height.equalTo(44)
        }
        
        faceView.layer.cornerRadius = 16
        faceView.layer.borderWidth = 1.5
        faceView.layer.borderColor = UIColor(hex: "dddddd").cgColor
        faceView.layer.masksToBounds = true
        addSubview(faceView)
        faceView.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self.titleLabel)
            make.size.equalTo(CGSize(width: 80, height: 32))
        }
        
        managerBtn.setImage(UIImage(named: "icon_dapp_browser_bar_manger")?.withRenderingMode(.alwaysOriginal), for: .normal)
        managerBtn.addTarget(self, action: #selector(managerBtnClick(sender:)), for: .touchUpInside)
        faceView.addSubview(managerBtn)
        managerBtn.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(faceView)
            make.width.equalTo(40)
        }
        
        closeBtn.setImage(UIImage(named: "icon_dapp_browser_bar_close")?.withRenderingMode(.alwaysOriginal), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnClick(sender:)), for: .touchUpInside)
        faceView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.top.right.bottom.equalTo(faceView)
            make.width.equalTo(40)
        }
        
        lineView.backgroundColor = UIColor(hex: "dddddd")
        addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerX.equalTo(faceView);
            make.top.equalTo(faceView).offset(10)
            make.bottom.equalTo(faceView).offset(-10)
            make.width.equalTo(1)
        }
    }
    
    @objc private func managerBtnClick(sender: UIButton) {
        delegate?.showManagerFace()
    }
    
    @objc private func closeBtnClick(sender: UIButton) {
        delegate?.close()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
