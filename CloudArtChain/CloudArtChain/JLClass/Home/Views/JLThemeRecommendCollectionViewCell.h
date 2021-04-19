//
//  JLThemeRecommendCollectionViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/15.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLThemeRecommendCollectionViewCell : UICollectionViewCell
- (void)setThemeArtData:(Model_art_Detail_Data *)themeArtData totalCount:(NSInteger)totalCount index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
