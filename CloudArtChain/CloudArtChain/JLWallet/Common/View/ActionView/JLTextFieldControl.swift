//
//  JLTextFieldControl.swift
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

import UIKit

class JLTextFieldControl: UIView {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = UIColor(hex: "212121")
        return label
    }()
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        textField.textColor = UIColor(hex: "212121")
        textField.textAlignment = .right
        textField.tintColor = UIColor(hex: "212121")
        return textField
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
        self.addSubview(self.textField)
        self.addSubview(self.lineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(self)
            make.height.equalTo(40.0)
        }
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(16.0)
            make.right.bottom.equalTo(self)
            make.height.equalTo(40.0)
            make.width.greaterThanOrEqualTo(200.0)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.bottom.equalTo(self.snp.bottom)
            make.right.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    func setPlaceHolder(placeHolder: String) {
        let attr: NSMutableAttributedString = NSMutableAttributedString(string: placeHolder)
        attr.addAttributes([.foregroundColor: UIColor(hex: "BBBBBB"), .font: UIFont.systemFont(ofSize: 16.0, weight: .regular)], range: NSRange(location: 0, length: placeHolder.count))
        textField.attributedPlaceholder = attr
    }
}
