//
//  JLMultiChainWalletBackupMnemonicContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletBackupMnemonicContentView.h"

@interface JLMultiChainWalletBackupMnemonicContentView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *mnemonicView;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, assign) CGFloat wordSpaceH; // 水平间隔
@property (nonatomic, assign) CGFloat wordSpaceV; // 垂直间隔
@property (nonatomic, assign) CGFloat wordHeight; // 高度
@property (nonatomic, assign) NSInteger column;   // 列数

@end

@implementation JLMultiChainWalletBackupMnemonicContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _wordSpaceH = 130;
        _wordSpaceV = 5;
        _wordHeight = 20;
        _column = 2;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"抄写下你的钱包助记词";
    _titleLabel.textColor = JL_color_gray_101010;
    _titleLabel.font = kFontPingFangSCSCSemibold(18);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
    }];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.text = @"助记词用于恢复钱包或重置钱包密码，将它准确的抄写到纸上，并存放在只有你知道的安全的地方。";
    _descLabel.textColor = JL_color_gray_999999;
    _descLabel.font = kFontPingFangSCRegular(14);
    _descLabel.textAlignment = NSTextAlignmentCenter;
    _descLabel.numberOfLines = 0;
    _descLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.left.equalTo(self).offset(26);
        make.right.equalTo(self).offset(-26);
    }];
    
    _mnemonicView = [[UIView alloc] init];
    [self addSubview:_mnemonicView];
    [_mnemonicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self);
    }];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _nextBtn.backgroundColor = JL_color_blue_50C3FF;
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = kFontPingFangSCRegular(17.0f);
    _nextBtn.layer.cornerRadius = 23;
    [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextBtn];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-(25 + KTouch_Responder_Height));
        make.height.mas_equalTo(@46);
    }];
}

- (void)updateMnemonicWords {
    [_mnemonicView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    NSInteger line = _mnemonicArray.count / _column + _mnemonicArray.count % _column;
    // 计算最后一列里最长的行
    NSInteger lastColumnMaxLineWord = line;
    CGFloat lastWidth = 0;
    for (int i = 0; i < _mnemonicArray.count; i++) {
        if (i >= line) {
            CGFloat width = [JLTool getAdaptionSizeWithText:_mnemonicArray[i] labelHeight:_wordHeight font:kFontPingFangSCMedium(16)].width;
            if (width > lastWidth) {
                lastColumnMaxLineWord = i;
                lastWidth = width;
            }
        }
    }
    for (int i = 0; i < _mnemonicArray.count; i++) {
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.text = [NSString stringWithFormat:@"%d", i + 1];
        numLabel.textColor = JL_color_gray_999999;
        numLabel.font = kFontPingFangSCMedium(16);
        [_mnemonicView addSubview:numLabel];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mnemonicView).offset((self.wordSpaceV + self.wordHeight) * (i % line));
            make.left.equalTo(self.mnemonicView).offset(self.wordSpaceH * (i / line));
            make.height.mas_equalTo(@(self.wordHeight));
            if (i == line - 1) {
                make.bottom.equalTo(self.mnemonicView);
            }
        }];
        
        UILabel *wordLabel = [[UILabel alloc] init];
        wordLabel.text = _mnemonicArray[i];
        wordLabel.textColor = JL_color_gray_101010;
        wordLabel.font = kFontPingFangSCMedium(16);
        [_mnemonicView addSubview:wordLabel];
        [wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(numLabel);
            make.left.equalTo(numLabel).offset(30);
            if (i == lastColumnMaxLineWord) {
                make.right.equalTo(self.mnemonicView);
            }
        }];
    }
}

- (void)nextBtnClick: (UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(next)]) {
        [_delegate next];
    }
}

#pragma mark - setters and getters
- (void)setMnemonicArray:(NSArray *)mnemonicArray {
    _mnemonicArray = mnemonicArray;
    
    [self updateMnemonicWords];
}

@end
