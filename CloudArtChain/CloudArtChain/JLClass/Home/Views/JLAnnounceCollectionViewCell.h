//
//  JLAnnounceCollectionViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/28.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLAnnounceCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSArray *announceArray;
@property (nonatomic, copy) void(^announceBlock)(NSInteger subIndex);
@end

NS_ASSUME_NONNULL_END
