
//
//  LZPickTopView.m
//  smart_small
//
//  Created by LZ on 2017/7/5.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import "LZPickTopView.h"
#import "LZPickViewDefine.h"
#define default_height 50.0
@interface LZPickTopView()
//取消、完成按钮
@property(nonatomic,strong)UIButton * leftButton,*rightButton;
//标题label
@property(nonatomic,strong)UILabel * mainTitleLabel;

@end

@implementation LZPickTopView

+ (instancetype)pickTopView
{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, kPICKVIEW_SCREEN_WIDTH, 44)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:239 / 255.0f green:239 / 255.0f blue:239 / 255.0f alpha:1.0f];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    [self addSubview:self.mainTitleLabel];
}

#pragma lazy loading
- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setTitle:@"取消" forState:UIControlStateNormal];
        _leftButton.titleLabel.font = PickFont(14);
        [_leftButton setTitleColor:[UIColor colorWithRed:179 / 255.0f green:179 / 255.0f blue:179 / 255.0f alpha:1.0f] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(isClickLeft) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:@"确定" forState:UIControlStateNormal];
        _rightButton.titleLabel.font = PickFont(14);
        [_rightButton setTitleColor:[UIColor colorWithRed:0.0f green:121 / 255.0f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(isClickRight) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UILabel *)mainTitleLabel
{
    if (!_mainTitleLabel) {
        _mainTitleLabel = [[UILabel alloc]init];
        _mainTitleLabel.text = @"";
        _mainTitleLabel.textColor = [UIColor colorWithRed:51 / 255.0f green:51 / 255.0f blue:51 / 255.0f alpha:1.0f]; 
        _mainTitleLabel.font = PickFont(15);
        [_mainTitleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _mainTitleLabel;
}

#pragma mark 按钮点击事件
- (void)isClickLeft
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickButtonHandel:)]) {
        [_delegate clickButtonHandel:ClickTopViewTypeWithLeft];
    }
    if (self.LZPickTopViewClickHandle) {
        self.LZPickTopViewClickHandle(ClickTopViewTypeWithLeft);
    }
}

- (void)isClickRight
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickButtonHandel:)]) {
        [_delegate clickButtonHandel:ClickTopViewTypeWithRight];
    }
    if (self.LZPickTopViewClickHandle) {
        self.LZPickTopViewClickHandle(ClickTopViewTypeWithRight);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.leftButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.rightButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.mainTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary * views = NSDictionaryOfVariableBindings(_leftButton,_mainTitleLabel,_rightButton);
    
    
    NSDictionary * spaceMetrics = @{
                                    @"space":@10.0f
                                    };
    //leftButton AutoLayout
    NSString * hVFL = @"H:|-space-[_leftButton(60)]";
    NSArray * hLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:kNilOptions metrics:spaceMetrics views:views];
    [self addConstraints:hLayoutConstraint];
    
    NSString * vVFL = @"V:|-0-[_leftButton]-0-|";
    
    NSArray * vLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:kNilOptions metrics:nil views:views];
    
    [self addConstraints:vLayoutConstraint];
    
    //rightButton AutoLayout
    NSString * hrightButtonVFL = @"H:[_rightButton(60)]-space-|";
    NSArray * hrightButtonLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:hrightButtonVFL options:kNilOptions metrics:spaceMetrics views:views];
    [self addConstraints:hrightButtonLayoutConstraint];
    
    NSString * vrightButtonVFL = @"V:|-0-[_rightButton]-0-|";
    
    NSArray * vrightButtonLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:vrightButtonVFL options:kNilOptions metrics:nil views:views];
    
    [self addConstraints:vrightButtonLayoutConstraint];
    
    //标题 AutoLayout
    NSString * hMainTitleLabelVFL = @"H:|-0-[_mainTitleLabel]-0-|";
    NSArray * hMainTitleLabelLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:hMainTitleLabelVFL options:kNilOptions metrics:spaceMetrics views:views];
    [self addConstraints:hMainTitleLabelLayoutConstraint];
    
    NSString * vMainTitleLabelVFL = @"V:|-0-[_mainTitleLabel]-0-|";
    
    NSArray * vMainTitleLabelLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:vMainTitleLabelVFL options:kNilOptions metrics:nil views:views];
    
    [self addConstraints:vMainTitleLabelLayoutConstraint];
}

#pragma setter/getter method
- (void)setLeftTitle:(NSString *)leftTitle
{
    if (self.leftButton) {
        [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
    }else{
        NSLog(@"come setLeftTitle");
    }
}

- (void)setRightTitle:(NSString *)rightTitle
{
    if (self.rightButton) {
        [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
    }
}

- (void)setMainTitle:(NSString *)mainTitle
{
    if (self.mainTitleLabel) {
        self.mainTitleLabel.text = mainTitle;
    }
}

- (void)setLeftTitleColor:(UIColor *)leftTitleColor
{
    if (self.leftButton) {
        [self.leftButton setTitleColor:leftTitleColor forState:UIControlStateNormal];
    }
}

- (void)setRightTitleColor:(UIColor *)rightTitleColor
{
    if (self.rightButton) {
        [self.rightButton setTitleColor:rightTitleColor forState:UIControlStateNormal];
    }
}

- (void)setMainTitleColor:(UIColor *)mainTitleColor
{
    if (self.mainTitleLabel) {
        self.mainTitleLabel.textColor = mainTitleColor;
    }
}

- (void)setBgColor:(UIColor *)bgColor
{
    self.backgroundColor = bgColor;
}

- (void)setTopHeight:(CGFloat)topHeight
{
    self.frame = CGRectMake(0, 0, kPICKVIEW_SCREEN_WIDTH, topHeight);
}

@end
