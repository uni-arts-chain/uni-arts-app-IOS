//
//  JLWorksListViewController.h
//  CloudArtChain
//
//  Created by 花田半亩 on 2020/9/6.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLPagetableView.h"

typedef NS_ENUM(NSUInteger, JLWorkListType) {
    JLWorkListTypeListed, /** 已上架 */
    JLWorkListTypeNotList, /** 未上架 */
    JLWorkListTypeSelfBuy, /** 我买入的 */
    JLWorkListTypeSelfSell, /** 我卖出的 */
};

NS_ASSUME_NONNULL_BEGIN

@interface JLWorksListViewController : UIViewController
@property (nonatomic, assign) JLWorkListType workListType;
@property (nonatomic, strong) JLPagetableView *tableView;
@end

NS_ASSUME_NONNULL_END
