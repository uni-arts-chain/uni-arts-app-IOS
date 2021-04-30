//
//  JLArtDetailViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/1.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"
#import <GLKit/GLKit.h>
#import "AppDelegate.h"

typedef NS_ENUM(NSUInteger, JLArtDetailType) {
    JLArtDetailTypeDetail = 1, /** 普通用户 - 可以购买 */
    JLArtDetailTypeSelfOrOffShelf, /** 用户自己的作品 或者 下架的作品 */
};

NS_ASSUME_NONNULL_BEGIN

@interface JLArtDetailViewController : JLBaseViewController
@property (nonatomic, assign) JLArtDetailType artDetailType;
@property (nonatomic, strong) Model_art_Detail_Data *artDetailData;
@property (nonatomic, copy) void(^cancelFavorateBlock)(void);
@property (nonatomic, copy) void(^backBlock)(Model_art_Detail_Data *artDetailData);
@property (nonatomic, copy) void(^buySuccessDeleteBlock)(void);
@end

NS_ASSUME_NONNULL_END
