//
//  JLCashAccountPasswordAuthorizeView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLCashAccountPasswordAuthorizeView.h"
#import "JLBaseTextField.h"

static JLCashAccountPasswordAuthorizeView *authorizeView;

@interface JLCashAccountPasswordAuthorizeView ()

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) JLBaseTextField *textField;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *doneBtn;

@property (nonatomic, strong) MASConstraint *centerYConstraint;

@property (nonatomic, copy) JLCashAccountPasswordAuthorizeViewCompleteBlock completeBlock;

@property (nonatomic, copy) JLCashAccountPasswordAuthorizeViewCancelBlock cancelBlock;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *passwords;

@end

@implementation JLCashAccountPasswordAuthorizeView

- (instancetype)initWithFrame:(CGRect)frame title: (NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _title = title;
        _passwords = @"";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = JL_color_black;
    _maskView.alpha = 0;
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = JL_color_white_ffffff;
    _bgView.alpha = 0;
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.masksToBounds = YES;
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        self.centerYConstraint = make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(301, 286));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = _title;
    _titleLabel.textColor = JL_color_gray_333333;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = kFontPingFangSCSCSemibold(17);
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(32);
        make.left.right.equalTo(self.bgView);
    }];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"icon_common_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.bgView);
        make.width.height.mas_equalTo(@45);
    }];
    
    _textField = [[JLBaseTextField alloc] init];
    _textField.secureTextEntry = YES;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.backgroundColor = [UIColor clearColor];
    _textField.textColor = JL_color_gray_101010;
    _textField.font = kFontPingFangSCRegular(17);
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{ NSForegroundColorAttributeName: JL_color_gray_BEBEBE }];
    _textField.textFieldType = TextFieldType_withdrawAmout;
    [_textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [_bgView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(25);
        make.top.equalTo(self.bgView).offset(95);
        make.right.equalTo(self.bgView).offset(-72);
        make.height.mas_equalTo(@52);
    }];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.text = @"0/6";
    _numLabel.textColor = JL_color_gray_BEBEBE;
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.font = kFontPingFangSCRegular(17);
    [_bgView addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-22);
        make.centerY.equalTo(self.textField);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_DDDDDD;
    [_bgView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(22);
        make.right.equalTo(self.bgView).offset(-17);
        make.top.equalTo(self.textField.mas_bottom);
        make.height.mas_equalTo(@1);
    }];
    
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneBtn.backgroundColor = JL_color_black;
    [_doneBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_doneBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
    _doneBtn.titleLabel.font = kFontPingFangSCSCSemibold(16);
    [_doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_doneBtn];
    [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(27);
        make.right.equalTo(self.bgView).offset(-27);
        make.bottom.equalTo(self.bgView).offset(-37);
        make.height.mas_equalTo(@43);
    }];
    
    [self.bgView layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.5;
        self.bgView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.textField becomeFirstResponder];
    }];
}

#pragma mark - NSNotification
- (void)keyboardWillShow: (NSNotification *)notification {
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat bgViewBottomHeight = kScreenHeight / 2 + 286 / 2;
    CGFloat kbTopHeight = kScreenHeight - bgViewBottomHeight - 25;
    if (kbTopHeight < keyboardFrame.size.height) { // 视图在键盘下
        [self.centerYConstraint uninstall];
        [UIView animateWithDuration:duration animations:^{
            [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                self.centerYConstraint = make.centerY.equalTo(self).offset(-(keyboardFrame.size.height - kbTopHeight));
            }];
            [self layoutIfNeeded];
        } completion:nil];
    }
}

- (void)keboardWillHidden: (NSNotification *)notification {
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self.centerYConstraint uninstall];
    [UIView animateWithDuration:duration animations:^{
        if (self.bgView) {
            [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                self.centerYConstraint = make.centerY.equalTo(self);
            }];
            [self layoutIfNeeded];
        }
    } completion:nil];
}

#pragma mark - event respone
- (void)textFieldValueChanged: (UITextField *)textField {
    
    if (textField.text.length > 6) {
        textField.text = self.passwords;
        return;
    }
    
    if ([self isNum:textField.text]) {
        self.passwords = textField.text;
    }else {
        textField.text = self.passwords;
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入数字！" hideTime:KToastDismissDelayTimeInterval];
    }
    
    _numLabel.text = [NSString stringWithFormat:@"%ld/6", self.passwords.length];
}

- (void)doneBtnClick: (UIButton *)sender {
    [self.textField resignFirstResponder];
    
    if (self.passwords.length == 0) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入密码！" hideTime:KToastDismissDelayTimeInterval];
        return;
    }

    if (self.completeBlock) {
        self.completeBlock(self.passwords);
    }
    
    [self dismiss];
}

- (void)closeBtnClick: (UIButton *)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self dismiss];
}

#pragma mark - public methods
+ (void)showWithTitle: (NSString *)title complete: (JLCashAccountPasswordAuthorizeViewCompleteBlock)complete cancel: (JLCashAccountPasswordAuthorizeViewCancelBlock)cancel {
    
    authorizeView = [[JLCashAccountPasswordAuthorizeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) title:title];
    
    authorizeView.completeBlock = complete;
    authorizeView.cancelBlock = cancel;
    
    [[UIApplication sharedApplication].keyWindow addSubview:authorizeView];
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
        authorizeView = nil;
    }];
}

- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

- (void)dealloc
{
    NSLog(@"释放了: %@", self.class);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
