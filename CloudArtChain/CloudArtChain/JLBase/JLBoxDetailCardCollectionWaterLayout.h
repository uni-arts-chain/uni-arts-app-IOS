//
//  JLBoxDetailCardCollectionWaterLayout.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLBoxDetailCardCollectionWaterLayout : UICollectionViewFlowLayout
/** 列数 */
@property (nonatomic, assign) int colunms;
@property (nonatomic, strong) NSMutableArray *iconArray;

+ (instancetype)layoutWithColoumn:(int)coloumn data:(NSMutableArray *)dataA verticleMin:(float)minv horizonMin:(float)minh leftMargin:(float)leftMargin rightMargin:(float)rightMargin;
@end

NS_ASSUME_NONNULL_END
