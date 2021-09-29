//
//  EthBrowserManagerFaceView.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/29.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import UIKit

enum EthBrowserManagerFaceViewItemType {
    case collect
    case copy
    case refresh
}

var managerFaceView: EthBrowserManagerFaceView? = nil

class EthBrowserManagerFaceView: UIView {
    private let maskBgView = UIView()
    private let bgView = UIView()
    private let titleLabel = UILabel()
    private let closeBtn = UIButton(type: .system)
    
    private var isCollect: Bool = false
    private var clickClourse: ((_ itemType: EthBrowserManagerFaceViewItemType) -> Void)?
    
    private var titleArray: [String] {
        ["收藏","复制链接","刷新"]
    }
    private var imageNamedArray: [String] {
        ["icon_dapp_browser_face_collect",
         "icon_dapp_browser_face_copy",
         "icon_dapp_browser_face_refresh"]
    }

    init(frame: CGRect, isCollect: Bool) {
        super.init(frame: frame)
        self.isCollect = isCollect
        
        configUI()
    }
    
    private func configUI() {
        maskBgView.frame = self.bounds
        maskBgView.alpha = 0;
        maskBgView.backgroundColor = .black;
        maskBgView.isUserInteractionEnabled = true
        maskBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maskBgViewDidTap(ges:))))
        addSubview(maskBgView)
        
        bgView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 182 + (UIApplication.shared.statusBarFrame.size.height > 20 ? 34 : 20))
        bgView.layer.cornerRadius = 5
        bgView.backgroundColor = .white
        addSubview(bgView)
        
        titleLabel.text = "页面管理"
        titleLabel.font = UIFont(name: "PingFangSC-Regular", size: 17)
        titleLabel.textAlignment = .center
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bgView).offset(13)
            make.centerX.equalTo(bgView)
        }
        
        closeBtn.setImage(UIImage(named: "icon_dapp_browser_face_close")?.withRenderingMode(.alwaysOriginal), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnClick(sender:)), for: .touchUpInside)
        bgView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.top.right.equalTo(bgView)
            make.size.equalTo(CGSize(width: 60, height: 50))
        }
        
        let itemW: CGFloat = (UIScreen.main.bounds.size.width - 30 ) / 4
        let itemH: CGFloat = 90
        for i in 0..<titleArray.count {
            let itemView = UIView()
            itemView.tag = 100 + i
            itemView.isUserInteractionEnabled = true
            itemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(itemViewDidTap(ges:))))
            bgView.addSubview(itemView)
            itemView.snp.makeConstraints { make in
                make.top.equalTo(bgView).offset(56)
                make.left.equalTo(bgView).offset(15.0 + itemW * CGFloat(i))
                make.size.equalTo(CGSize(width: itemW, height: itemH))
            }
            
            let imgBgView = UIView()
            imgBgView.tag = 200 + i
            imgBgView.layer.cornerRadius = 25
            imgBgView.layer.borderWidth = 1
            imgBgView.layer.borderColor = UIColor(hex: "dddddd").cgColor
            imgBgView.clipsToBounds = true
            itemView.addSubview(imgBgView)
            imgBgView.snp.makeConstraints { make in
                make.top.equalTo(itemView).offset(10)
                make.centerX.equalTo(itemView)
                make.width.height.equalTo(50)
            }
            
            let imgView = UIImageView()
            imgView.tag = 300 + i
            imgView.image = UIImage(named: imageNamedArray[i])
            imgBgView.addSubview(imgView)
            imgView.snp.makeConstraints { make in
                make.center.equalTo(imgBgView)
                make.width.height.equalTo(30)
            }
            
            let label = UILabel()
            label.tag = 400 + i
            label.text = titleArray[i]
            label.textColor = UIColor(hex: "999999");
            label.textAlignment = .center
            label.font = UIFont(name: "PingFangSC-Regular", size: 14)
            itemView.addSubview(label)
            label.snp.makeConstraints { make in
                make.top.equalTo(imgBgView.snp.bottom).offset(17)
                make.centerX.equalTo(imgBgView)
            }

            if (i == 0 && isCollect) {
                imgView.image = UIImage(named: "icon_dapp_browser_face_collected")
            }
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.maskBgView.alpha = 0.5
            self.bgView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - (182 + (UIApplication.shared.statusBarFrame.size.height > 20 ? 34 : 20)), width: UIScreen.main.bounds.size.width, height: 182 + (UIApplication.shared.statusBarFrame.size.height > 20 ? 34 : 20))
        }
    }
    
    @objc private func maskBgViewDidTap(ges: UITapGestureRecognizer) {
        dismiss()
    }
    
    @objc private func closeBtnClick(sender: UIButton) {
        dismiss()
    }
    
    @objc private func itemViewDidTap(ges: UITapGestureRecognizer) {
        if clickClourse != nil {
            var type: EthBrowserManagerFaceViewItemType = .collect
            if ges.view!.tag - 100 == 0 {
                for subView in ges.view!.subviews {
                    if subView.tag >= 200 && subView.tag < 300 {
                        for subView1 in subView.subviews {
                            if subView1.tag >= 300 && subView1.tag < 400 {
                                if !isCollect {
                                    (subView1 as! UIImageView).image = UIImage(named: "icon_dapp_browser_face_collected")
                                }else {
                                    (subView1 as! UIImageView).image = UIImage(named: "icon_dapp_browser_face_collect")
                                }
                            }
                        }
                    }
                }
            }else if ges.view!.tag - 100 == 1 {
                type = .copy
            }else if ges.view!.tag - 100 == 2 {
                type = .refresh
            }
            clickClourse!(type)
        }
        dismiss()
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.maskBgView.alpha = 0
            self.bgView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 182 + (UIApplication.shared.statusBarFrame.size.height > 20 ? 34 : 20))
        } completion: { _ in
            self.maskBgView.removeFromSuperview()
            self.bgView.removeFromSuperview()
            managerFaceView?.removeFromSuperview()
            managerFaceView = nil
        }
    }
    
    static func show(with isCollect: Bool, completion: @escaping (_ itemType: EthBrowserManagerFaceViewItemType) -> Void) {
        managerFaceView = EthBrowserManagerFaceView(frame: UIScreen.main.bounds, isCollect: isCollect)
        managerFaceView?.clickClourse = completion
        UIApplication.shared.windows.last?.addSubview(managerFaceView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
