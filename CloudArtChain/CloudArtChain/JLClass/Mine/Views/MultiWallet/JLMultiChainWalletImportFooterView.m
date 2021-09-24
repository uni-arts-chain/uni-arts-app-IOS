//
//  JLMultiChainWalletImportFooterView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletImportFooterView.h"
#import "JLBaseTextView.h"

@interface JLMultiChainWalletImportFooterView ()<UITextViewDelegate>

@property (nonatomic, strong) UIImageView *tipImgView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) JLBaseTextView *textView;

@end

@implementation JLMultiChainWalletImportFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _tipImgView = [[UIImageView alloc] init];
    _tipImgView.image = [UIImage imageNamed:@"icon_wallet_import_notice"];
    [self addSubview:_tipImgView];
    [_tipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
        make.width.height.mas_equalTo(@15);
    }];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.text = @"此账户的名称将会在您的地址下显示";
    _tipLabel.textColor = JL_color_gray_999999;
    _tipLabel.font = kFontPingFangSCRegular(14);
    [self addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipImgView.mas_right).offset(10);
        make.centerY.equalTo(self.tipImgView);
    }];
    
    _textView = [[JLBaseTextView alloc] init];
    _textView.textColor = JL_color_gray_101010;
    _textView.font = kFontPingFangSCRegular(15);
    _textView.delegate = self;
    _textView.layer.cornerRadius = 5;
    _textView.layer.borderColor = JL_color_gray_101010.CGColor;
    _textView.layer.borderWidth = 1;
    _textView.layer.masksToBounds = YES;
    _textView.contentInset = UIEdgeInsetsMake(8, 12, 8, 12);
    [self addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.top.equalTo(self.tipImgView.mas_bottom).offset(25);
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    JLLog(@"textView.text: %@", textView.text);
    _sourceText = textView.text;
    
    if (_changeTextBlock) {
        _changeTextBlock(_sourceText);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return YES;
}

#pragma mark - setters and getters
- (void)setImportType:(JLMultiChainImportType)importType {
    _importType = importType;
    
    _textView.hidden = YES;
    if (_importType == JLMultiChainImportTypeMnemonic) {
        _textView.jl_placeholder = @"请输入助记词，按空格分隔";
        _textView.hidden = NO;
    }else if (_importType == JLMultiChainImportTypePrivateKey) {
        _textView.jl_placeholder = @"私钥：64位十六进制符号";
        _textView.hidden = NO;
    }
}

- (void)setSourceText:(NSString *)sourceText {
    _sourceText = sourceText;
    
    _textView.text = _sourceText;
}

@end
