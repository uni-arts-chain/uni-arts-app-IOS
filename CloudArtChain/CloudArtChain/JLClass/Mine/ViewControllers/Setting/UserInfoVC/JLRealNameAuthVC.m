//
//  JLRealNameAuthVC.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLRealNameAuthVC.h"
#import "JLRealNameFailedView.h"
#import <AVFoundation/AVFoundation.h>

#define ViewHeight 60.0f

@interface JLRealNameAuthVC ()
@property (nonatomic, strong) UILabel *realNameLabel;
@property (nonatomic, strong) UITextField *realNameTF;

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UITextField *numberTF;

@property (nonatomic, strong) UILabel *certifLab;
@property (nonatomic, strong) UILabel *certifLabel;
@property (nonatomic, strong) UIImageView *certifImage;

@property (nonatomic, copy)   NSString *idDocumentNumber;
@property (nonatomic, copy)   NSString *realName;

@property (nonatomic, strong) UserDataBody *user;
@end

@implementation JLRealNameAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JL_color_white_ffffff;
    self.navigationItem.title = @"实人认证";
    [self addBackItem];
    [self createView];
    
    self.user = [AppSingleton sharedAppSingleton].userBody;
}

- (void)createView {
    UIView *realNameView = [[UIView alloc] init];
    [self.view addSubview:realNameView];
    [realNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(ViewHeight);
    }];
    
    [realNameView addSubview:self.realNameLabel];
    [realNameView addSubview:self.realNameTF];
    
    UIView *realNameLineView = [[UIView alloc] init];
    realNameLineView.backgroundColor = JL_color_gray_DDDDDD;
    [realNameView addSubview:realNameLineView];
    
    [self.realNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0.0f);
        make.left.mas_equalTo(0.0f);
        make.height.mas_equalTo(16.0f);
    }];
    [self.realNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0.0f);
        make.right.mas_equalTo(0.0f);
        make.left.mas_equalTo(105.0f);
    }];
    [realNameLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(realNameView);
        make.height.mas_equalTo(1.0f);
    }];
        
    UIView *numberView = [[UIView alloc] init];
    [self.view addSubview:numberView];
    [numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(realNameView.mas_bottom).offset(0.0f);
        make.height.mas_equalTo(ViewHeight);
    }];
       
    [numberView addSubview:self.numberLabel];
    [numberView addSubview:self.numberTF];
    
    UIView *numberLineView = [[UIView alloc] init];
    numberLineView.backgroundColor = JL_color_gray_DDDDDD;
    [numberView addSubview:numberLineView];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0.0f);
        make.left.mas_equalTo(0.0f);
        make.height.mas_equalTo(16.0f);
    }];
    [self.numberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0.0f);
        make.right.mas_equalTo(0.0f);
        make.left.mas_equalTo(105.0f);
    }];
    [numberLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(numberView);
        make.height.mas_equalTo(1.0f);
    }];
    
    UIView *certifView = [[UIView alloc] init];
    [self.view addSubview:certifView];
    [certifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(numberView.mas_bottom).offset(0.0f);
        make.height.mas_equalTo(ViewHeight);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sumbitButonAction)];
    [certifView addGestureRecognizer:tap];
       
    [certifView addSubview:self.certifLab];
    [certifView addSubview:self.certifImage];
    [certifView addSubview:self.certifLabel];


    [self.certifLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0.0f);
        make.left.mas_equalTo(0.0f);
        make.height.mas_equalTo(16.0f);
    }];
    
    [self.certifImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0.0f);
        make.right.mas_equalTo(0.0f);
        make.height.width.mas_equalTo(13.0f);
    }];
    self.certifImage.image = [UIImage imageNamed:@"icon_wallet_edit_arrowright"];
    
    [self.certifLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0.0f);
        make.right.mas_equalTo(self.certifImage.mas_left).offset(-7.0f);
        make.width.mas_equalTo(200);
    }];
    self.certifLabel.textAlignment = NSTextAlignmentRight;
}

- (UILabel*)certifLab {
    if (!_certifLab) {
        _certifLab = [self createSameLabel:@"实人认证"];
    }
    return _certifLab;
}

- (UILabel *)certifLabel {
    if (!_certifLabel) {
        _certifLabel = [[UILabel alloc] init];
        _certifLabel.text = @"开始认证";
        _certifLabel.textColor = JL_color_gray_BBBBBB;
        _certifLabel.font = kFontPingFangSCRegular(16.0f);
    }
    return _certifLabel;
}

- (UIImageView *)certifImage {
    if (!_certifImage) {
        _certifImage = [self createSameImage];
    }
    return _certifImage;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [self createSameLabel:@"证件号码"];
    }
    return _numberLabel;
}

- (UITextField *)numberTF {
    if (!_numberTF) {
        WS(weakSelf)
        _numberTF = [self createSameTextField:@"请输入证件号码"];
        [_numberTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
                UITextRange *selectedRange = [weakSelf.numberTF markedTextRange];
                UITextPosition *position = [weakSelf.numberTF positionFromPosition:selectedRange.start offset:0];
                if (!position) {
                    NSString *content = [JLUtils trimSpace:x];
                    weakSelf.numberTF.text = content;
                    weakSelf.idDocumentNumber = content;
                }
            } else {
                NSString *content = [JLUtils trimSpace:x];
                weakSelf.numberTF.text = content;
                weakSelf.idDocumentNumber = content;
            }
        }];
    }
    return _numberTF;
}

- (UILabel *)realNameLabel {
    if (!_realNameLabel) {
        _realNameLabel = [self createSameLabel:@"真实姓名"];
    }
    return _realNameLabel;
}

- (UITextField *)realNameTF {
    if (!_realNameTF) {
        WS(weakSelf)
        _realNameTF = [self createSameTextField:@"请输入姓名"];
        [_realNameTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
                UITextRange *selectedRange = [weakSelf.realNameTF markedTextRange];
                UITextPosition *position = [weakSelf.realNameTF positionFromPosition:selectedRange.start offset:0];
                if (!position) {
                    NSString *content = [JLUtils trimSpace:x];
                    weakSelf.realNameTF.text = content;
                    weakSelf.realName = content;
                }
            } else {
                NSString *content = [JLUtils trimSpace:x];
                weakSelf.realNameTF.text = content;
                weakSelf.realName = content;
            }
        }];
    }
    return _realNameTF;
}

- (UILabel *)createSameLabel:(NSString *)text {
    UILabel *lab = [[UILabel alloc] init];
    lab.text = text;
    lab.textColor = JL_color_gray_101010;
    lab.font = kFontPingFangSCRegular(16.0f);
    return lab;
}

- (UITextField *)createSameTextField:(NSString *)placeholder {
    UITextField *tf = [[UITextField alloc] init];
    tf.font = kFontPingFangSCRegular(16.0f);
    tf.textColor = JL_color_gray_101010;
    tf.textAlignment = NSTextAlignmentRight;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_BBBBBB, NSFontAttributeName: kFontPingFangSCRegular(16.0f)};
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:placeholder attributes:dic];
    tf.attributedPlaceholder = attr;
    return tf;
}

- (UIImageView *)createSameImage {
    UIImageView *image = [[UIImageView alloc] init];
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.image = [UIImage imageNamed:@"icon_arrow_down_auth"];
    return image;
}

#pragma mark 下一步
- (void)sumbitButonAction {
    if ([self checkForm]) {
        
    }
}

- (BOOL)checkForm{
    if (!self.numberTF.text.length) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入正确的证件号码" hideTime:KToastDismissDelayTimeInterval];
        return NO;
    } else if (!self.realNameTF.text.length) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入姓名" hideTime:KToastDismissDelayTimeInterval];
        return NO;
    } else {
        return YES;
    }
    return YES;
}
@end
