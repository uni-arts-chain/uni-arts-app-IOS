//
//  JLAlertTipView.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/25.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAlertTipView.h"

static JLAlertTipView *alertTipView;

@interface JLAlertTipView ()

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *doneBtn;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *doneTitle;

@property (nonatomic, copy) NSString *cancelTitle;

@property (nonatomic, copy) JLAlertTipViewDoneBlock doneBlock;

@property (nonatomic, copy) JLAlertTipViewCancelBlock cancelBlock;

@end

@implementation JLAlertTipView

- (instancetype)initWithFrame:(CGRect)frame title: (NSString *)title message: (NSString *)message doneTitle: (NSString *)doneTitle cancelTitle: (NSString *)cancelTitle done: (JLAlertTipViewDoneBlock)done cancel: (JLAlertTipViewCancelBlock)cancel
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _message = message;
        _doneTitle = doneTitle;
        _cancelTitle = cancelTitle;
        _doneBlock = done;
        _cancelBlock = cancel;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    CGFloat textH = [JLTool getAdaptionSizeWithText:_message labelWidth:kScreenWidth - 68 * 2 font:kFontPingFangSCRegular(14)].height;
//    NSMutableAttributedString *attrs;
//    if (![NSString stringIsEmpty:_message]) {
//        attrs = [[NSMutableAttributedString alloc] initWithString:_message];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineSpacing = 2;
//        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
//        paragraphStyle.alignment = NSTextAlignmentCenter;
//        [attrs addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrs.length)];
//        textH = [JLTool getAdaptionSizeWithAttributedText:attrs font:kFontPingFangSCRegular(14) labelWidth:kScreenWidth - 68 * 2 lineSpace:2].size.height;
//    }
    
    _maskView = [[UIView alloc] init];
    _maskView.alpha = 0;
    _maskView.backgroundColor = [JL_color_black colorWithAlphaComponent:0.6];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    _bgView = [[UIView alloc] init];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(48);
        make.right.equalTo(self).offset(-48);
        make.height.mas_equalTo(@(textH + 170));
    }];
    
    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.image = [[UIImage imageNamed:@"alert_tip_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(80, 100, 80, 100) resizingMode:UIImageResizingModeStretch];
    [_bgView addSubview:_bgImgView];
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.bgView);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = _title;
    _titleLabel.textColor = JL_color_mainColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = kFontPingFangSCMedium(19);
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImgView).offset(35);
        make.left.equalTo(self.bgImgView).offset(22);
        make.right.equalTo(self.bgImgView).offset(-22);
    }];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.textColor = JL_color_black_101220;
    _descLabel.font = kFontPingFangSCRegular(14);
    _descLabel.numberOfLines = 0;
    _descLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _descLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
        make.left.equalTo(self.bgImgView).offset(20);
        make.right.equalTo(self.bgImgView).offset(-20);
    }];
    
    if (![NSString stringIsEmpty:_cancelTitle]) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:_cancelTitle forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:JL_color_mainColor forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kFontPingFangSCMedium(14);
        _cancelBtn.layer.cornerRadius = 20;
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.borderColor = JL_color_mainColor.CGColor;
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImgView).offset(21);
            make.bottom.equalTo(self.bgImgView).offset(-39);
            make.size.mas_equalTo(CGSizeMake((kScreenWidth - 68 * 2 - 18) / 2, 40));
        }];
    }
    
    _doneBtn = [[UIButton alloc] init];
    _doneBtn.backgroundColor = JL_color_mainColor;
    [_doneBtn setTitle:_doneTitle forState:UIControlStateNormal];
    [_doneBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
    _doneBtn.titleLabel.font = kFontPingFangSCMedium(14);
    _doneBtn.layer.cornerRadius = 20;
    [_doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_doneBtn];
    [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (![NSString stringIsEmpty:self.cancelTitle]) {
            make.right.equalTo(self.bgImgView).offset(-21);
            make.size.mas_equalTo(CGSizeMake((kScreenWidth - 68 * 2 - 18) / 2, 40));
        }else {
            make.left.equalTo(self.bgImgView).offset(32);
            make.right.equalTo(self.bgImgView).offset(-32);
            make.height.mas_equalTo(40);
        }
        make.bottom.equalTo(self.bgImgView).offset(-39);
    }];
    
//    if ([NSString stringIsEmpty:_message]) {
        _descLabel.text = _message;
//    }else {
//        _descLabel.attributedText = attrs;
//    }

    [_bgView layoutIfNeeded];
    _bgView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.35 animations:^{
        self.maskView.alpha = 1.0;
        self.bgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

#pragma mark - event response
- (void)doneBtnClick: (UIButton *)sender {
    if (_doneBlock) {
        _doneBlock();
    }
    
    [self dismiss];
}

- (void)cancelBtnClick: (UIButton *)sender {
    if (_cancelBlock) {
        _cancelBlock();
    }
    
    [self dismiss];
}

#pragma mark - public methods
+ (void)alertWithTitle: (NSString *)title message: (NSString *)message doneTitle: (NSString *)doneTitle done: (JLAlertTipViewDoneBlock)done {
    [JLAlertTipView alertWithTitle:title message:message doneTitle:doneTitle cancelTitle:@"" done:done cancel:nil];
}

+ (void)alertWithTitle: (NSString *)title message: (NSString *)message doneTitle: (NSString *)doneTitle cancelTitle: (NSString *)cancelTitle done: (JLAlertTipViewDoneBlock)done cancel: (JLAlertTipViewCancelBlock)cancel {
    alertTipView = [[JLAlertTipView alloc] initWithFrame:[UIScreen mainScreen].bounds title:title message:message doneTitle:doneTitle cancelTitle:cancelTitle done:done cancel:cancel];
    [[UIApplication sharedApplication].keyWindow addSubview:alertTipView];
}

#pragma mark - private methods
- (void)dismiss {
    [UIView animateWithDuration:0.35 animations:^{
        self.maskView.alpha = 0;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.maskView removeFromSuperview];
        [alertTipView removeFromSuperview];
        alertTipView = nil;
    }];
}

- (void)dealloc
{
    NSLog(@"释放了: %@", self.class);
}

@end
