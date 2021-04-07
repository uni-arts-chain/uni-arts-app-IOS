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
};

NS_ASSUME_NONNULL_BEGIN

@interface JLWorksListViewController : UIViewController
@property (nonatomic, assign) JLWorkListType workListType;
@property (nonatomic, strong) JLPagetableView *tableView;
@property (nonatomic, copy) void(^addToListBlock)(Model_art_Detail_Data *artDetailData);
@property (nonatomic, copy) void(^offFromListBlock)(Model_art_Detail_Data *artDetailData);
@property (nonatomic, copy) void(^applyAddCertBlock)(Model_art_Detail_Data *artDetailData);
@property (nonatomic, copy) void(^artDetailBlock)(Model_art_Detail_Data *artDetailData);
@property (nonatomic, copy) void(^launchAuctionBlock)(Model_art_Detail_Data *artDetailData, NSIndexPath *indexPath);
- (void)addToBiddingList:(Model_art_Detail_Data *)artDetailData;
- (void)offFromBiddingList:(Model_art_Detail_Data *)artDetailData;
- (void)launchAuctionFromNotList:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
