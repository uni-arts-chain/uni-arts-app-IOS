//
//  JLDappSearchContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/28.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappSearchContentView.h"
#import "JLDappSearchNavigationBar.h"
#import "JLDappSearchHotView.h"
#import "JLDappSearchResultView.h"

@interface JLDappSearchContentView ()<JLDappSearchNavigationBarDelegate, JLDappSearchHotViewdelegate, JLDappSearchResultViewdelegate>

@property (nonatomic, strong) JLDappSearchNavigationBar *navigationBar;
@property (nonatomic, strong) JLDappSearchHotView *hotView;
@property (nonatomic, strong) JLDappSearchResultView *resultView;

@property (nonatomic, copy) NSString *searchText;

@end

@implementation JLDappSearchContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.navigationBar];
    [self addSubview:self.hotView];
    [self addSubview:self.resultView];
}

#pragma mark - JLDappSearchNavigationBarDelegate
- (void)searchWithSearchText: (NSString *)searchText {
    if (![NSString stringIsEmpty:searchText]) {
        self.hotView.hidden = YES;
        self.resultView.hidden = NO;
        
        self.searchText = searchText;
        
        self.resultView.isSearching = YES;
        
        if (_delegate && [_delegate respondsToSelector:@selector(searchWithSearchText:)]) {
            [_delegate searchWithSearchText:searchText];
        }
    }else {
        self.hotView.hidden = NO;
        self.resultView.hidden = YES;
        
        self.resultView.isSearching = NO;
    }
}

- (void)cancel {
    if (_delegate && [_delegate respondsToSelector:@selector(cancel)]) {
        [_delegate cancel];
    }
}

#pragma mark - JLDappSearchHotViewdelegate
- (void)lookDappWithDappData: (Model_dapp_Data *)dappData {
    if (_delegate && [_delegate respondsToSelector:@selector(lookDappWithDappData:)]) {
        [_delegate lookDappWithDappData:dappData];
    }
}

#pragma mark - JLDappSearchResultViewdelegate
- (void)didSelect: (Model_dapp_Data *)dappData {
    if (_delegate && [_delegate respondsToSelector:@selector(lookDappWithDappData:)]) {
        [_delegate lookDappWithDappData:dappData];
    }
}

#pragma mark - setters and getters
- (JLDappSearchNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[JLDappSearchNavigationBar alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 35)];
        _navigationBar.delegate = self;
    }
    return _navigationBar;
}

- (JLDappSearchHotView *)hotView {
    if (!_hotView) {
        _hotView = [[JLDappSearchHotView alloc] initWithFrame:CGRectMake(0, self.navigationBar.frameBottom + 18, self.frameWidth, self.frameHeight - (self.navigationBar.frameBottom + 18))];
        _hotView.delegate = self;
    }
    return _hotView;
}

- (JLDappSearchResultView *)resultView {
    if (!_resultView) {
        _resultView = [[JLDappSearchResultView alloc] initWithFrame:CGRectMake(0, self.navigationBar.frameBottom + 18, self.frameWidth, self.frameHeight - (self.navigationBar.frameBottom + 18))];
        _resultView.hidden = YES;
        _resultView.delegate = self;
    }
    return _resultView;
}

- (void)setHotSearchArray:(NSArray *)hotSearchArray {
    _hotSearchArray = hotSearchArray;
    
    self.hotView.hotSearchArray = _hotSearchArray;
}

- (void)setSearchResultArray:(NSArray *)searchResultArray {
    _searchResultArray = searchResultArray;
    
    self.resultView.isSearching = NO;
    
    self.resultView.searchResultArray = _searchResultArray;
}

@end
