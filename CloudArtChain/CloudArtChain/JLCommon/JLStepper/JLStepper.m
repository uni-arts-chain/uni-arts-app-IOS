//
//  JLStepper.m
//  Miner_Pow
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//
#import "JLStepper.h"

@interface JLStepper()<UITextFieldDelegate>
@property(nonatomic,copy) UIButton *minusBtn;
@property(nonatomic,copy) UIButton *plusBtn;
@property(nonatomic,copy) UITextField *valueTF;
@end

@implementation JLStepper
- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
        [self initData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initData];
        [self setupUI];
    }
    return self;
}

- (void)initData {
    _isValueEditable = true;
    _stepValue = 1;
    _minValue = 0;
    _maxValue = 100;
    
    self.value = 0;
}

- (void)setupUI {
    [self addSubview: self.minusBtn];
    [self addSubview: self.plusBtn];
    [self addSubview: self.valueTF];
    
    [self setupLayout];
}

- (void)setupLayout {
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(self.minusBtn.mas_height);
    }];
    [self.plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.equalTo(self.plusBtn.mas_height);
    }];
    [self.valueTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.minusBtn.mas_right);
        make.right.equalTo(self.plusBtn.mas_left);
    }];
}

#pragma mark - action
- (void)actionForButtonClicked: (UIButton*)sender {
    if ([sender isEqual:_minusBtn]) {
        self.value = _value - _stepValue;
    }
    else if([sender isEqual:_plusBtn]){
        self.value = _value + _stepValue;
    }
}

- (void)actionForTextFieldValueChanged:(UITextField*)sender {
    if ([sender isEqual:_valueTF]) {
        self.value = [sender.text doubleValue];
    }
}

- (void)actionForTextFieldValueEndEdit:(UITextField *)sender {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    double value = [textField.text doubleValue];
    if (value < _minValue) {
        value = _minValue;
    }
    self.value = value;
}


#pragma mark - setters
-(void)setValue:(double)value {
//    if (value < _minValue) {
//        value = _minValue;
//    }
//    else
    if (value > _maxValue) {
        value = _maxValue;
    }
    
    _minusBtn.enabled = value > _minValue;
    _plusBtn.enabled = value < _maxValue;
    _valueTF.text = [NSString stringWithFormat:@"%.0f",value];
        
    _value = value;
    
    _valueChanged ? _valueChanged(_value) : nil;
}

- (void)setMaxValue:(double)maxValue {
    if (maxValue < _minValue) {
        maxValue = _minValue;
    }
    _maxValue = maxValue;
    [self textFieldDidEndEditing:self.valueTF];
}

- (void)setMinValue:(double)minValue {
    if (minValue > _maxValue) {
        minValue = _maxValue;
    }
    _minValue = minValue;
    [self textFieldDidEndEditing:self.valueTF];
}

- (void)setIsValueEditable:(BOOL)isValueEditable {
    _isValueEditable = isValueEditable;
    _valueTF.enabled = _isValueEditable;
}

#pragma mark - private
- (UIButton*)actionButtonWithTitle: (NSString*)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = JL_color_white_ffffff;
    btn.titleLabel.font = kFontPingFangSCRegular(13.0f);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:JL_color_gray_333333 forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionForButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    ViewBorderRadius(btn, 4.0f, 1.0f, JL_color_gray_999999);
    return btn;
}

#pragma mark - getters
- (UITextField *)valueTF {
    if (!_valueTF) {
        UITextField *tf = [UITextField new];
        tf.font = kFontPingFangSCRegular(13.0f);
        tf.textColor = JL_color_gray_333333;
        [tf addTarget:self action:@selector(actionForTextFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [tf addTarget:self action:@selector(actionForTextFieldValueEndEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        tf.borderStyle = UITextBorderStyleNone;
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.textAlignment = NSTextAlignmentCenter;
        tf.enabled = self.isValueEditable;
        tf.translatesAutoresizingMaskIntoConstraints = false;
        tf.text = [NSString stringWithFormat:@"%.0f",self.value];
        tf.delegate = self;
        _valueTF = tf;
    }
    return _valueTF;
}

- (UIButton *)minusBtn {
    if (!_minusBtn) {
        UIButton *btn = [self actionButtonWithTitle:@"-"];
        btn.translatesAutoresizingMaskIntoConstraints = false;
        btn.contentEdgeInsets = UIEdgeInsetsMake(-1.0f, 0.0f, 1.0f, 0.0f);
        _minusBtn = btn;
    }
    return _minusBtn;
}

- (UIButton *)plusBtn {
    if (!_plusBtn) {
        UIButton *btn = [self actionButtonWithTitle:@"+"];
        btn.contentEdgeInsets = UIEdgeInsetsMake(-1.0f, 0.0f, 1.0f, 0.0f);
        btn.translatesAutoresizingMaskIntoConstraints = false;

        _plusBtn = btn;
    }
    return _plusBtn;
}
@end
