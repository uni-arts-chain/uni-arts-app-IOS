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
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
    }];
    [self.scrollView addSubview:self.phoneWeChatTitleLabel];
    [self.scrollView addSubview:self.phoneWeChatView];
    [self.phoneWeChatView addSubview:self.phoneWeChatInputTF];
    [self.phoneWeChatInputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.phoneWeChatView).insets(UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 13.0f));
    }];
    [self.scrollView addSubview:self.suggestionTitleLabel];
    [self.scrollView addSubview:self.suggestionView];
    [self.scrollView addSubview:self.noticeLabel];
    [self.scrollView addSubview:self.submitButton];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.submitButton.frameBottom);
    
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
        _scrollView.backgroundColor = JL_color_white_ffffff;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UILabel *)phoneWeChatTitleLabel {
    if (!_phoneWeChatTitleLabel) {
        _phoneWeChatTitleLabel = [JLUIFactory labelInitText:@"电话/微信" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        _phoneWeChatTitleLabel.frame = CGRectMake(20.0f, 0.0f, kScreenWidth - 20.0f * 2, 46.0f);
    }
    return _phoneWeChatTitleLabel;
}

- (UIView *)phoneWeChatView {
    if (!_phoneWeChatView) {
        _phoneWeChatView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, self.phoneWeChatTitleLabel.frameBottom, kScreenWidth - 15.0f * 2, 47.0f)];
        ViewBorderRadius(_phoneWeChatView, 5.0f, 1.0f, JL_color_gray_101010);
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
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_BBBBBB, NSFontAttributeName: kFontPingFangSCRegular(13)};
        NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"请输入电话/微信" attributes:dic];
        _phoneWeChatInputTF.attributedPlaceholder = attr;
    }
    return _phoneWeChatInputTF;
}

- (UILabel *)suggestionTitleLabel {
    if (!_suggestionTitleLabel) {
        _suggestionTitleLabel = [JLUIFactory labelInitText:@"您的意见" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        _suggestionTitleLabel.frame = CGRectMake(20.0f, self.phoneWeChatView.frameBottom + 8.0f, kScreenWidth - 20.0f * 2, 46.0f);
    }
    return _suggestionTitleLabel;
}

- (JLUploadWorkDescriptionView *)suggestionView {
    if (!_suggestionView) {
        _suggestionView = [[JLUploadWorkDescriptionView alloc] initWithMax:100 placeholder:@"留下您的宝贵意见，让我们做得更好" placeHolderColor:JL_color_gray_BBBBBB textFont:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_212121 borderColor:JL_color_gray_101010];
        _suggestionView.frame = CGRectMake(15.0f, self.suggestionTitleLabel.frameBottom, kScreenWidth - 15.0f * 2, 155.0f);
    }
    return _suggestionView;
}

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [JLUIFactory labelInitText:@"您的意见，我们会认真考虑，感谢您的支持!" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        _noticeLabel.frame = CGRectMake(16.0f, self.suggestionView.frameBottom, kScreenWidth - 16.0f * 2, 42.0f);
    }
    return _noticeLabel;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [JLUIFactory buttonInitTitle:@"提交反馈" titleColor:JL_color_white_ffffff backgroundColor:JL_color_gray_101010 font:kFontPingFangSCRegular(17.0f) addTarget:self action:@selector(submitButtonClick)];
        _submitButton.frame = CGRectMake(16.0f, self.noticeLabel.frameBottom + 10.0f, kScreenWidth - 16.0f * 2, 46.0f);
        ViewBorderRadius(_submitButton, 23.0f, 0.0f, JL_color_clear);
    }
    return _submitButton;
}

- (void)submitButtonClick {
    [self.view endEditing:YES];
}

@end
