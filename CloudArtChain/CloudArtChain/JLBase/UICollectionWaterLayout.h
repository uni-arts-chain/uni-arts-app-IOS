//
//  UICollectionWaterLayout.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UICollectionWaterLayout : UICollectionViewFlowLayout
/** 列数 */
@property (nonatomic, assign) int colunms;
@property (nonatomic, strong) NSMutableArray *iconArray;
@property (nonatomic, assign) BOOL isAuction;

+ (instancetype)layoutWithColoumn:(int)coloumn data:(NSMutableArray *)dataA verticleMin:(float)minv horizonMin:(float)minh leftMargin:(float)leftMargin rightMargin:(float)rightMargin isAuction: (BOOL)isAuction;
@end

NS_ASSUME_NONNULL_END
