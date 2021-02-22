//
//  JLBaseViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLBaseViewController : UIViewController
@property (nonatomic, strong) NSString * customUMLogPageName;

//添加返回按钮
- (void)addBackItem;
- (void)addBackItemImage:(NSString *)imageStr;
- (void)backClick;
- (void)addRightItemImage:(NSString *)imageStr;
- (void)rightItemClick;
@end

NS_ASSUME_NONNULL_END
