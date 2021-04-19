//
//  JLPagetableCollectionView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/16.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLPageEmptyView.h"

@class JLPagetableCollectionView, JLPageEmptyView;
@protocol JLPagetableCollectionViewRequestDelegate <NSObject>
@optional
/**
 返回请求到的数据
 @param JLPagetableView 返回自己
 @param PullDown   返回bool 表明  YES－－下拉刷新  NO －－－ 上拉记载
 @param SuccessData         返回的数据
 */
- (void)JLPagetableCollectionView:(JLPagetableCollectionView *)JLPagetableView isPullDown:(BOOL)PullDown SuccessData:(id)SuccessData;

/**
 返回网络错误的状态

 @param JLPagetableView self
 @param error 错误error
 */
@optional
- (void)JLPagetableCollectionView:(JLPagetableCollectionView *)JLPagetableView requestFailed:(NSError *)error;

@end

@interface JLPagetableCollectionView : UICollectionView<UIGestureRecognizerDelegate>
@property (assign,nonatomic) id<JLPagetableCollectionViewRequestDelegate> RequestDelegate;
//配合MCHoveringView使用的属性/
//**获取tableView偏移量的Block*/
@property (nonatomic , copy) void(^scrollViewDidScroll)(UIScrollView * scrollView);

//配合MCHoveringView使用的属性/
/**是否同时响应多个手势 默认NO*/
@property (nonatomic , assign) BOOL  canResponseMutiGesture;

/*传递controller进来展示loadding状态只能是weak不会引用*/
@property (weak, nonatomic)UIViewController *TempController;

/**
 是否有头部刷新  默认YES
 */
@property (nonatomic,assign) BOOL isHasHeaderRefresh;

/**
 获取总的Item
 */
@property (nonatomic , assign) NSInteger  getTotal;

/**
 请求的网址
 */
@property (nonatomic , copy) NSString * requestUrl;

/**
 请求的参数
 */
@property (nonatomic , strong) NSMutableDictionary * requestParam;

/**
 刷新 无下拉动作
 */
- (void)requestData;

/**
 开始下载任务  网络数据用此开始  本地数据则不用使用本方法

 @param url        请求的网址
 @param Parameters 携带的参数 （一定要把分页参数放在这里）
 */
- (void)setUpWithUrl:(NSString *)url Parameters:(NSDictionary *)Parameters formController:(UIViewController *)controler;
@end
