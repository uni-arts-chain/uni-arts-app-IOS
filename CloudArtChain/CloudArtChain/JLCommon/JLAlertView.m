//
//  JLAlertView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/21.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAlertView.h"

static JLAlertView *alertView;

@interface JLAlertView ()

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *doneBtn;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *doneTitle;

@property (nonatomic, copy) NSString *cancelTitle;

@property (nonatomic, copy) JLAlertViewDoneBlock doneBlock;

@property (nonatomic, copy) JLAlertViewCancelBlock cancelBlock;

@end

@implementation JLAlertView

- (instancetype)initWithFrame:(CGRect)frame title: (NSString *)title message: (NSString *)message doneTitle: (NSString *)doneTitle cancelTitle: (NSString *)cancelTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _message = message;
        _doneTitle = doneTitle;
        _cancelTitle = cancelTitle;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _maskView = [[UIView alloc] initWithFrame:self.bounds];
    _maskView.backgroundColor = JL_color_black;
    _maskView.alpha = 0;
    [self addSubview:_maskView];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 284, 278)];
    _bgView.alpha = 0;
    _bgView.center = self.center;
    _bgView.backgroundColor = JL_color_white_ffffff;
    [self addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = _title;
    _titleLabel.textColor = JL_color_gray_212121;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = kFontPingFangSCSCSemibold(18);
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(37);
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(@20);
    }];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"icon_common_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.bgView);
        make.width.height.mas_equalTo(@51);
    }];
    
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneBtn.backgroundColor = JL_color_gray_101010;
    [_doneBtn setTitle:_doneTitle forState:UIControlStateNormal];
    [_doneBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
    _doneBtn.titleLabel.font = kFontPingFangSCRegular(17);
    [_doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_doneBtn];
    
    if ([NSString stringIsEmpty:_cancelTitle]) {
        [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(35);
            make.right.equalTo(self.bgView).offset(-35);
            make.bottom.equalTo(self.bgView).offset(-50);
            make.height.mas_equalTo(@47);
        }];
    }else {
        [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView).offset(-26);
            make.bottom.equalTo(self.bgView).offset(-50);
            make.size.mas_equalTo(CGSizeMake(109, 47));
        }];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:_cancelTitle forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kFontPingFangSCRegular(17);
        _cancelBtn.layer.borderWidth = 2;
        _cancelBtn.layer.borderColor = JL_color_gray_101010.CGColor;
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(26);
            make.bottom.equalTo(self.bgView).offset(-50);
            make.size.mas_equalTo(CGSizeMake(109, 47));
        }];
    }
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.text = _message;
    _messageLabel.textColor = JL_color_gray_212121;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.font = kFontPingFangSCRegular(15);
    _messageLabel.numberOfLines = 0;
    _messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_bgView addSubview:_messageLabel];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.bgView).offset(44);
        make.right.equalTo(self.bgView).offset(-44);
        make.bottom.equalTo(self.doneBtn.mas_top).offset(-10);
    }];
    
    _bgView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.maskView.alpha = 0.5;
        self.bgView.alpha = 1;
        self.bgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
}

#pragma mark - event response
- (void)closeBtnClick: (UIButton *)sender {
    [self dismiss];
}

- (void)doneBtnClick: (UIButton *)sender {
    if (self.doneBlock) {
        self.doneBlock();
    }
    [self dismiss];
}

- (void)cancelBtnClick: (UIButton *)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self dismiss];
}

#pragma mark - public methods
+ (void)alertWithTitle: (NSString *)title message: (NSString *)message doneTitle: (NSString *)doneTitle done: (JLAlertViewDoneBlock)done {
    [JLAlertView alertWithTitle:title message:message doneTitle:doneTitle cancelTitle:nil done:done cancel:nil];
}

+ (void)alertWithTitle: (NSString *)title message: (NSString *)message doneTitle: (NSString *)doneTitle cancelTitle: (NSString *)cancelTitle done: (JLAlertViewDoneBlock)done cancel: (JLAlertViewCancelBlock)cancel {
    alertView = [[JLAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) title:title message:message doneTitle:doneTitle cancelTitle:cancelTitle];
    alertView.doneBlock = done;
    alertView.cancelBlock = cancel;
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
}

#pragma mark - private methods
- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
        alertView = nil;
    }];
}

- (void)dealloc
{
    NSLog(@"释放了: %@", self.class);
}

@end
