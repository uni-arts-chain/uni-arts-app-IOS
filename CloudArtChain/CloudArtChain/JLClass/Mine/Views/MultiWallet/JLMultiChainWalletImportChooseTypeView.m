//
//  JLMultiChainWalletImportChooseTypeView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/24.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletImportChooseTypeView.h"

static JLMultiChainWalletImportChooseTypeView *chooseTypeView;

@interface JLMultiChainWalletImportChooseTypeView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *midLineView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, copy) JLMultiChainWalletImportChooseTypeViewCompleteBlock completeBlock;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *sourceArray;
@property (nonatomic, assign) JLMultiChainImportType defaultImportType;
@property (nonatomic, assign) CGFloat bgViewHeight;

@end

@implementation JLMultiChainWalletImportChooseTypeView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title sourceArray: (NSArray *)sourceArray defaultImportType: (JLMultiChainImportType)defaultImportType
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _sourceArray = sourceArray;
        _defaultImportType = defaultImportType;
        _bgViewHeight = 250 + KTouch_Responder_Height;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _maskView = [[UIView alloc] initWithFrame:self.bounds];
    _maskView.backgroundColor = JL_color_black;
    _maskView.alpha = 0;
    _maskView.userInteractionEnabled = YES;
    [_maskView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewDidTap:)]];
    [self addSubview:_maskView];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frameHeight, self.frameWidth, _bgViewHeight)];
    _bgView.backgroundColor = JL_color_white_ffffff;
    _bgView.layer.cornerRadius = 10;
    _bgView.layer.masksToBounds = YES;
    [self addSubview:_bgView];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = _title;
    _titleLabel.textColor = JL_color_gray_101010;
    _titleLabel.font = kFontPingFangSCRegular(17);
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(20);
        make.height.mas_equalTo(@60);
    }];
    
    _topLineView = [[UIView alloc] init];
    _topLineView.backgroundColor = JL_color_gray_666666;
    _topLineView.layer.cornerRadius = 1;
    [_bgView addSubview:_topLineView];
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(2);
        make.centerX.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(40, 2));
    }];
    
    _midLineView = [[UIView alloc] init];
    _midLineView.backgroundColor = JL_color_gray_DDDDDD;
    [_bgView addSubview:_midLineView];
    [_midLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(@1);
    }];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_bgView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.bgView);
        make.top.equalTo(self.midLineView);
    }];
    
    _contentView = [[UIView alloc] init];
    [_bgView addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    for (int i = 0; i < _sourceArray.count; i++) {
        UIView *itemBgView = [[UIView alloc] init];
        itemBgView.tag = 100 + i;
        itemBgView.userInteractionEnabled = YES;
        [itemBgView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemBgViewDidTap:)]];
        [_contentView addSubview:itemBgView];
        [itemBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(i * 60);
            make.height.mas_equalTo(@60);
            if (i == self.sourceArray.count - 1) {
                make.bottom.equalTo(self.contentView).offset(-(10 + KTouch_Responder_Height));
            }
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 200 + i;
        if (_sourceArray[i] == JLMultiChainImportTypeMnemonic) {
            label.text = @"助记词";
        }else if (_sourceArray[i] == JLMultiChainImportTypePrivateKey) {
            label.text = @"私钥";
        }else if (_sourceArray[i] == JLMultiChainImportTypeKeystore) {
            label.text = @"Keystore JSON";
        }
        label.textColor = JL_color_gray_101010;
        label.font = kFontPingFangSCRegular(16);
        [itemBgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemBgView).offset(20);
            make.centerY.equalTo(itemBgView);
            make.right.equalTo(itemBgView).offset(-100);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.tag = 300 + i;
        if (_defaultImportType == _sourceArray[i]) {
            imgView.hidden = NO;
        }else {
            imgView.hidden = YES;
        }
        imgView.image = [[UIImage imageNamed:@"EditImageClipDone"] jl_imageWithTintColor:JL_color_gray_101010 blendMode:kCGBlendModeDestinationIn];
        [itemBgView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(itemBgView).offset(-15);
            make.centerY.equalTo(itemBgView);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.maskView.alpha = 0.5;
        self.bgView.frame = CGRectMake(0, self.frameHeight - self.bgViewHeight, self.frameWidth, self.bgViewHeight);
    } completion:nil];
}

#pragma mark - event response
- (void)itemBgViewDidTap: (UITapGestureRecognizer *)ges {
    JLMultiChainImportType selectImportType = _sourceArray[ges.view.tag - 100];
    [_contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag >= 100 && obj.tag < 200) {
            [obj.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.tag >= 300) {
                    if (obj.tag - 300 == ges.view.tag - 100) {
                        obj.hidden = NO;
                    }else {
                        obj.hidden = YES;
                    }
                }
            }];
        }
    }];
    
    if (self.completeBlock) {
        self.completeBlock(selectImportType);
    }
    
    [self close];
}

- (void)maskViewDidTap: (UITapGestureRecognizer *)ges {
    [self close];
}

#pragma mark - private methods
- (void)close {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.maskView.alpha = 0;
        self.bgView.frame = CGRectMake(0, self.frameHeight, self.frameWidth, self.bgViewHeight);
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.bgView removeFromSuperview];
        [chooseTypeView removeFromSuperview];
    }];
}

#pragma mark - public methods
+ (void)showWithTitle:(NSString *)title
          sourceArray: (NSArray *)sourceArray
    defaultImportType: (JLMultiChainImportType)defaultImportType
           completion: (JLMultiChainWalletImportChooseTypeViewCompleteBlock)completion {
    chooseTypeView = [[JLMultiChainWalletImportChooseTypeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) title:title sourceArray:sourceArray defaultImportType:defaultImportType];
    
    chooseTypeView.completeBlock = completion;
    
    [[UIApplication sharedApplication].keyWindow addSubview:chooseTypeView];
}

- (void)dealloc
{
    NSLog(@"释放了: %@", self.class);
}

@end
