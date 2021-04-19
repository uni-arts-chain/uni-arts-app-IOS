//
//  JLPagetableCollectionView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/16.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLPagetableCollectionView.h"
#import "MJRefresh.h"

static NSString * const pageIndex = @"pageIndex";//获取第几页的根据自己的需求替换
@interface JLPagetableCollectionView ()
{
    /**纪录当前页数*/
    NSInteger _pageNumber;
    /**出现网络失败*/
    BOOL _hasNetError;
}
@end

@implementation JLPagetableCollectionView
+ (void)load
{
    Method originalMethod = class_getInstanceMethod(self, @selector(reloadData));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(mc_reloadData));
    BOOL didAddMethod =
    class_addMethod(self,
                    @selector(reloadData),
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(self,
                            @selector(mc_reloadData),
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initCollectionView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self initCollectionView];
    }
    return self;
}

- (void)initCollectionView{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];

    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _hasNetError = NO;
    self.canResponseMutiGesture = NO;
}

- (void)mc_reloadData
{
    [self mc_reloadData];
    if (self.getTotal == 0 && _hasNetError) {
        //这里是网络出错的数据为空
        
    } else if (self.getTotal == 0 ){
        //就是数据为空
        
    } else {
        
    }
}

- (NSInteger)getTotal {
    NSInteger sections = 0;
    sections = [self numberOfSections];
    NSInteger items = 0;
    for (NSInteger section = 0; section < sections; section++) {
        items += [self numberOfItemsInSection:section];
    }
    return items;
}

- (void)setUpWithUrl:(NSString *)url Parameters:(NSDictionary *)Parameters formController:(UIViewController *)controler
{
    _requestUrl = url;
    _TempController = controler;
    _requestParam= Parameters.mutableCopy;
    if ([Parameters.allKeys containsObject:pageIndex]) {
        self.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    }
    [self.mj_header beginRefreshing];
}

//**请求方法*/
- (void)SetUpNetWorkParamters:(NSDictionary *)paramters isPullDown:(BOOL)isPullDown
{
    //暂时是模仿数据请求h返回数据 替换下面的数据请求 这里就可以删除
    if ([self.RequestDelegate respondsToSelector:@selector(JLPagetableCollectionView:isPullDown:SuccessData:)]) {
        [self.RequestDelegate JLPagetableCollectionView:self isPullDown:isPullDown SuccessData:@[]];
    }
    self->_hasNetError = NO;
    [self EndRefrseh];
}

- (void)setIsHasHeaderRefresh:(BOOL)isHasHeaderRefresh
{
    if (!isHasHeaderRefresh) {
        self.mj_header = nil;
    }else{
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    }
}
- (void)requestData
{
    if (_requestUrl.length ==0) {
        NSLog(@"JLPagetableView:请输入下载网址");
        [self.mj_header endRefreshing];
        return;
    }
    if ([_requestParam.allKeys containsObject:pageIndex]) {
        [self changeIndexWithStatus:1];
    }
    [self SetUpNetWorkParamters:_requestParam isPullDown:YES];
}

- (void)footerRefresh
{
    [self changeIndexWithStatus:2];
    [self SetUpNetWorkParamters:_requestParam isPullDown:NO];
}

- (void)changeIndexWithStatus:(NSInteger)Status//1  下拉  2上拉  3减一
{
    _pageNumber = [_requestParam[pageIndex] integerValue];
    if (Status == 1) {
        _pageNumber = 1;
    }else if (Status == 2){
        _pageNumber ++;
    }else{
        _pageNumber --;
    }
    [_requestParam setObject:[NSNumber numberWithInteger:_pageNumber] forKey:pageIndex];
}

- (void)EndRefrseh
{
    [self.mj_footer endRefreshing];
    [self.mj_header endRefreshing];
}

- (void)setRequestParam:(NSDictionary *)requestParam
{
    if (_requestParam) {
        [_requestParam addEntriesFromDictionary:requestParam];
        return;
    }
    _requestParam = requestParam.mutableCopy;
}

- (void)setRequestUrl:(NSString *)requestUrl
{
    _requestUrl = requestUrl;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.canResponseMutiGesture;
}
@end
