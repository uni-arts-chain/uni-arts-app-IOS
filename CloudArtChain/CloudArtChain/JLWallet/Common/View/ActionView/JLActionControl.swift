//
//  JLActionControl.swift
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

import SoraUI
import UIKit

class JLActionControl: UIView {
    let actionControl: BaseActionControl = BaseActionControl()
    var arrowIndicator: UIImageView = {
        let indicator = UIImageView(image: UIImage(named: "icon_wallet_import_arrow"))
        return indicator
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = UIColor(hex: "212121")
        return label
    }()
    
    var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = UIColor(hex: "212121")
        return label
    }()
    
    var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(hex: "DDDDDD")
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    private func configure() {
        backgroundColor = .clear
        
        self.addSubview(titleLabel)
        self.addSubview(self.subTitleLabel)
        self.addSubview(self.arrowIndicator)
        self.addSubview(self.actionControl)
        self.addSubview(self.lineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(self)
            make.height.equalTo(40.0)
        }
        arrowIndicator.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(10.0)
            make.height.equalTo(6.0)
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowIndicator.snp.left).offset(-6.0)
            make.bottom.equalTo(self)
            make.height.equalTo(40.0)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.bottom.equalTo(self.snp.bottom)
            make.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        actionControl.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}
