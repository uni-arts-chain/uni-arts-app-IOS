//
//  JLWalletPointCell.swift
//  CommonWallet
//
//  Created by 朱彬 on 2021/1/26.
//

import UIKit
import CommonWallet

class JLWalletPointCell: UITableViewCell {
    lazy var maskImageView: UIImageView = {
        let maskImageView = UIImageView()
        maskImageView.image = UIImage(named: "icon_home_wallet_point")
        return maskImageView
    }()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "积分"
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.regular)
        titleLabel.textColor = UIColor(hex: "101010")
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        numLabel.textColor = UIColor(hex: "101010")
        numLabel.textAlignment = .left
        return numLabel
    }()
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(hex: "DDDDDD")
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() {
        self.contentView.addSubview(self.maskImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.numLabel)
        self.contentView.addSubview(self.lineView)
        
        self.maskImageView.snp.makeConstraints { (make) in
            make.left.equalTo(26.0)
            make.top.equalTo(24.0)
            make.size.equalTo(20.0)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.maskImageView.snp.right).offset(15.0)
            make.top.equalTo(26.0)
            make.height.equalTo(16.0)
        }
        self.numLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-17.0)
            make.top.equalTo(26.0)
            make.height.equalTo(16.0)
        }
        self.lineView.snp.makeConstraints { (make) in
            make.left.equalTo(15.0)
            make.bottom.equalTo(self.contentView)
            make.right.equalTo(-15.0)
            make.height.equalTo(1.0)
        }
    }
    
    func bind(viewModel: WalletViewModelProtocol) {
        if let assetViewModel = viewModel as? WalletAssetViewModel {
            numLabel.text = assetViewModel.amount
        }
    }
}
