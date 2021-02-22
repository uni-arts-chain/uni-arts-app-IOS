//
//  JLSearchBarView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLSearchBarView.h"

@interface JLSearchBarView()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UIButton *cancleButton;
@end

@implementation JLSearchBarView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createView];
    }
    return self;
}

#pragma mark - UI
- (void)createView {
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width - 48.0f, self.frame.size.height)];
    _searchField.delegate = self;
    _searchField.textColor = JL_color_gray_101010;
    ViewBorderRadius(_searchField, self.frameHeight * 0.5f, 0.0f, JL_color_clear);
    _searchField.backgroundColor = JL_color_gray_F3F3F3;
    _searchField.font = kFontPingFangSCRegular(16.0f);
    _searchField.tintColor =  JL_color_gray_101010;
    _searchField.keyboardType = UIKeyboardTypeASCIICapable;
    _searchField.returnKeyType = UIReturnKeySearch;
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView * paddView  = [self createImageView];
    _searchField.leftView = paddView;
    _searchField.leftViewMode = UITextFieldViewModeAlways;
    [_searchField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [_searchField addTarget:self action:@selector(textChangeEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self addSubview:_searchField];
    
    self.cancleButton.frame = CGRectMake(CGRectGetMaxX(_searchField.frame) + 8.0f, 0.0f, 40.0f, self.frame.size.height);
    [self addSubview:self.cancleButton];
}

#pragma mark - private
- (void)textChange:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textEditChange:)]) {
        [self.delegate textEditChange:textField.text];
    }
}

- (void)textChangeEnd:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textEndEditChange:)]) {
        [self.delegate textEndEditChange:textField.text];
    }
}

- (void)setSearchPlaceholder:(NSString *)text{
    _searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: JL_color_gray_909090}];
}

- (void)setSearchText:(NSString *)text {
    _searchField.text = text;
}

- (void)clickCancleButton:(UIButton*)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRightItemJumpPage)]) {
        [self.delegate didRightItemJumpPage];
    }
}

- (void)becomeResponder {
    [_searchField becomeFirstResponder];
}

- (void)resignResponder {
    [_searchField resignFirstResponder];
}

- (UIView *)createImageView {
    UIView * paddView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 38.0f, self.frame.size.height)];
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.0f, (self.frame.size.height - 14.0f) / 2, 14.0f, 14.0f)];
    leftImageView.image = [UIImage imageNamed:@"icon_common_search"];
    [paddView addSubview:leftImageView];
    return paddView;
}

#pragma mark - 懒加载
- (UIButton*)cancleButton {
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = kFontPingFangSCRegular(13.0f);
        [_cancleButton setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(clickCancleButton:) forControlEvents:UIControlEventTouchUpInside];
        _cancleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _cancleButton;
}
@end
