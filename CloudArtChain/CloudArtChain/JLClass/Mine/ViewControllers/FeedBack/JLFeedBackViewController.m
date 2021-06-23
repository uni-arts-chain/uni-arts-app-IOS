//
//  JLFeedBackViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/22.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLFeedBackViewController.h"
#import "JLBaseTextField.h"
#import "JLUploadWorkDescriptionView.h"

@interface JLFeedBackViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *phoneWeChatTitleLabel;
@property (nonatomic, strong) UIView *phoneWeChatView;
@property (nonatomic, strong) JLBaseTextField *phoneWeChatInputTF;
@property (nonatomic, strong) UILabel *suggestionTitleLabel;
@property (nonatomic, strong) JLUploadWorkDescriptionView *suggestionView;
@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) UIButton *submitButton;
@end

@implementation JLFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见与反馈";
    [self addBackItem];
    [self createSubViews];
}

- (void)createSubViews {
    WS(weakSelf)
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(-(KTouch_Responder_Height + 44));
    }];
    [self.scrollView addSubview:self.phoneWeChatTitleLabel];
    [self.scrollView addSubview:self.phoneWeChatView];
    [self.phoneWeChatView addSubview:self.phoneWeChatInputTF];
    [self.phoneWeChatInputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.phoneWeChatView).insets(UIEdgeInsetsMake(0.0f, 12.0f, 0.0f, 12.0f));
    }];
    [self.scrollView addSubview:self.suggestionTitleLabel];
    [self.scrollView addSubview:self.suggestionView];
    [self.scrollView addSubview:self.noticeLabel];
    [self.view addSubview:self.submitButton];
    [self.view bringSubviewToFront:self.submitButton];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.noticeLabel.frameBottom);
    
    [self.phoneWeChatInputTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.phoneWeChatInputTF markedTextRange];
            UITextPosition *position = [weakSelf.phoneWeChatInputTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                weakSelf.phoneWeChatInputTF.text = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            weakSelf.phoneWeChatInputTF.text = result;
        }
    }];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UILabel *)phoneWeChatTitleLabel {
    if (!_phoneWeChatTitleLabel) {
        _phoneWeChatTitleLabel = [JLUIFactory labelInitText:@"电话/微信" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_black_101220 textAlignment:NSTextAlignmentLeft];
        _phoneWeChatTitleLabel.frame = CGRectMake(12.0f, 0.0f, kScreenWidth - 12.0f * 2, 55.0f);
        _phoneWeChatTitleLabel.jl_contentInsets = UIEdgeInsetsMake(25, 0, 15, 0);
    }
    return _phoneWeChatTitleLabel;
}

- (UIView *)phoneWeChatView {
    if (!_phoneWeChatView) {
        _phoneWeChatView = [[UIView alloc] initWithFrame:CGRectMake(12.0f, self.phoneWeChatTitleLabel.frameBottom, kScreenWidth - 12.0f * 2, 50.0f)];
        _phoneWeChatView.backgroundColor = JL_color_white_ffffff;
        ViewBorderRadius(_phoneWeChatView, 8.0f, 0.0f, JL_color_clear);
    }
    return _phoneWeChatView;
}

- (JLBaseTextField *)phoneWeChatInputTF {
    if (!_phoneWeChatInputTF) {
        _phoneWeChatInputTF = [[JLBaseTextField alloc]init];
        _phoneWeChatInputTF.font = kFontPingFangSCRegular(13.0f);
        _phoneWeChatInputTF.textColor = JL_color_gray_212121;
        _phoneWeChatInputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneWeChatInputTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _phoneWeChatInputTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _phoneWeChatInputTF.spellCheckingType = UITextSpellCheckingTypeNo;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_87888F, NSFontAttributeName: kFontPingFangSCRegular(13)};
        NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"请输入电话/微信" attributes:dic];
        _phoneWeChatInputTF.attributedPlaceholder = attr;
    }
    return _phoneWeChatInputTF;
}

- (UILabel *)suggestionTitleLabel {
    if (!_suggestionTitleLabel) {
        _suggestionTitleLabel = [JLUIFactory labelInitText:@"您的意见" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_black_101220 textAlignment:NSTextAlignmentLeft];
        _suggestionTitleLabel.frame = CGRectMake(12.0f, self.phoneWeChatView.frameBottom, kScreenWidth - 12.0f * 2, 49.0f);
        _suggestionTitleLabel.jl_contentInsets = UIEdgeInsetsMake(19, 0, 15, 0);
    }
    return _suggestionTitleLabel;
}

- (JLUploadWorkDescriptionView *)suggestionView {
    if (!_suggestionView) {
        _suggestionView = [[JLUploadWorkDescriptionView alloc] initWithMax:100 placeholder:@"留下您的宝贵意见，让我们做得更好" placeHolderColor:JL_color_gray_87888F textFont:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_212121 borderColor:JL_color_clear];
        _suggestionView.frame = CGRectMake(12.0f, self.suggestionTitleLabel.frameBottom, kScreenWidth - 12.0f * 2, 200.0f);
    }
    return _suggestionView;
}

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [JLUIFactory labelInitText:@"您的意见，我们会认真考虑，感谢您的支持!" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_87888F textAlignment:NSTextAlignmentLeft];
        _noticeLabel.frame = CGRectMake(12.0f, self.suggestionView.frameBottom, kScreenWidth - 12.0f * 2, 38.0f);
    }
    return _noticeLabel;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [JLUIFactory buttonInitTitle:@"提交反馈" titleColor:JL_color_white_ffffff backgroundColor:JL_color_mainColor font:kFontPingFangSCMedium(16.0f) addTarget:self action:@selector(submitButtonClick)];
        _submitButton.frame = CGRectMake(0.0f, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height - 44.0f, kScreenWidth, 44.0f + KTouch_Responder_Height);
    }
    return _submitButton;
}

- (void)submitButtonClick {
    WS(weakSelf)
    [self.view endEditing:YES];
    
    if ([NSString stringIsEmpty:self.suggestionView.inputContent]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请填写反馈意见" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    
    Model_feedbacks_Req *request = [[Model_feedbacks_Req alloc] init];
    if (![NSString stringIsEmpty:self.phoneWeChatInputTF.text]) {
        request.contact = self.phoneWeChatInputTF.text;
    }
    request.advise = self.suggestionView.inputContent;
    Model_feedbacks_Rsp *response = [[Model_feedbacks_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            [[JLLoading sharedLoading] showMBSuccessTipMessage:@"提交成功" hideTime:KToastDismissDelayTimeInterval];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

@end
