//
//  JLDappSearchNavigationBar.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/28.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappSearchNavigationBar.h"

@interface JLDappSearchNavigationBar ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation JLDappSearchNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _searchBar.layer.cornerRadius = self.frameHeight / 2;
}

- (void)setupUI {
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.backgroundColor = JL_color_gray_F3F3F3;
    _searchBar.backgroundImage = [UIImage new];
    _searchBar.layer.cornerRadius = 17.5;
    _searchBar.layer.masksToBounds = YES;
    [_searchBar setImage:[UIImage imageNamed:@"icon_dapp_search_logo"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [_searchBar setPositionAdjustment:UIOffsetMake(-2, 0) forSearchBarIcon:UISearchBarIconSearch];
    [_searchBar setPositionAdjustment:UIOffsetMake(2, 0) forSearchBarIcon:UISearchBarIconClear];
    _searchBar.tintColor = JL_color_gray_101010;
    if (@available(iOS 13.0, *)) {
        _searchBar.searchTextField.textColor = JL_color_gray_101010;
        _searchBar.searchTextField.font = kFontPingFangSCRegular(14);
        _searchBar.searchTextField.backgroundColor = JL_color_clear;
        _searchBar.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索或输入 Dapp 网址" attributes:@{ NSForegroundColorAttributeName: JL_color_gray_BEBEBE, NSFontAttributeName: kFontPingFangSCRegular(14) }];
    } else {
        UITextField *textField = [_searchBar valueForKey:@"searchBarTextField"];
        if (textField) {
            textField.textColor = JL_color_gray_101010;
            textField.backgroundColor = JL_color_clear;
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索或输入 Dapp 网址" attributes:@{ NSForegroundColorAttributeName: JL_color_gray_BEBEBE, NSFontAttributeName: kFontPingFangSCRegular(14) }];
            textField.font = kFontPingFangSCRegular(14);
        }
    }
    _searchBar.delegate = self;
    _searchBar.userInteractionEnabled = YES;
    [self addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-62);
    }];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:JL_color_gray_666666 forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = kFontPingFangSCRegular(14);
    _cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.bottom.equalTo(self.searchBar);
        make.width.mas_equalTo(@62);
    }];
    
    [_searchBar becomeFirstResponder];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self endEditing:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(searchWithSearchText:)]) {
        [_delegate searchWithSearchText:searchBar.text];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (_delegate && [_delegate respondsToSelector:@selector(searchWithSearchText:)]) {
        [_delegate searchWithSearchText:searchText];
    }
}

#pragma mark - event response
- (void)cancelBtnClick: (UIButton *)sender {
    [self endEditing:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(cancel)]) {
        [_delegate cancel];
    }
}

#pragma mark - setters and getters
- (void)setSelectSearchText:(NSString *)selectSearchText {
    _selectSearchText = selectSearchText;
    
    _searchBar.text = _selectSearchText;
}

@end
