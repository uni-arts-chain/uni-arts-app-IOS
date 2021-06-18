//
//  JLSearchBarView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLSearchBarView.h"

@interface JLSearchBarView()<UITextFieldDelegate>
@property (nonatomic, strong) JLTextField *searchField;
@property (nonatomic, strong) UIButton *cancleButton;
@end

@implementation JLSearchBarView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

#pragma mark - UI
- (void)createView {
    _searchField = [[JLTextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width - 48.0f, self.frame.size.height)];
    _searchField.delegate = self;
    _searchField.textColor = JL_color_black_101220;
    ViewBorderRadius(_searchField, self.frameHeight * 0.5f, 0.0f, JL_color_clear);
    _searchField.backgroundColor = JL_color_gray_F5F5F5;
    _searchField.font = kFontPingFangSCMedium(14.0f);
    _searchField.tintColor =  JL_color_mainColor;
//    _searchField.keyboardType = UIKeyboardTypeASCIICapable;
    _searchField.returnKeyType = UIReturnKeySearch;
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchField.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchField.spellCheckingType = UITextSpellCheckingTypeNo;
    UIButton *clearBtn = [_searchField valueForKey:@"_clearButton"];
    if (clearBtn) {
        [clearBtn setImage:[UIImage imageNamed:@"search_icon_clear_red"] forState:UIControlStateNormal];
    }
    _searchField.jl_insets = UIEdgeInsetsMake(0, 0, 0, 2);
    UIView * paddView  = [self createImageView];
    _searchField.leftView = paddView;
    _searchField.leftViewMode = UITextFieldViewModeAlways;
    [_searchField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [_searchField addTarget:self action:@selector(textChangeEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self addSubview:_searchField];
    
    self.cancleButton.frame = CGRectMake(CGRectGetMaxX(_searchField.frame), 0.0f, 57.0f, self.frame.size.height);
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
    _searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: JL_color_gray_87888F, NSFontAttributeName: kFontPingFangSCRegular(14)}];
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
    leftImageView.image = [UIImage imageNamed:@"icon_common_search_red"];
    [paddView addSubview:leftImageView];
    return paddView;
}

#pragma mark - 懒加载
- (UIButton*)cancleButton {
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = kFontPingFangSCMedium(14.0f);
        [_cancleButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(clickCancleButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}
@end
