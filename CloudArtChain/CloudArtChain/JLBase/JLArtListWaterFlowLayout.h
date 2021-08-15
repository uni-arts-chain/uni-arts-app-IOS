//
//  JLArtListWaterFlowLayout.h
//  CloudArtChain
//
//  Created by jielian on 2021/8/13.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLArtListWaterFlowLayout : UICollectionViewFlowLayout

/** 列数 */
@property (nonatomic, assign) int colunms;
@property (nonatomic, strong) NSArray *iconArray;
@property (nonatomic, assign) BOOL isAuction;

+ (instancetype)layoutWithColoumn:(int)coloumn data:(NSArray *)dataA verticleMin:(float)minv horizonMin:(float)minh leftMargin:(float)leftMargin rightMargin:(float)rightMargin isAuction: (BOOL)isAuction;

@end

NS_ASSUME_NONNULL_END
