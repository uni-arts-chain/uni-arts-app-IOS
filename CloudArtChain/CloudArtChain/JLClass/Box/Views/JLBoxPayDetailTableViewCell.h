//
//  JLBoxPayDetailTableViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/21.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLBoxOpenPayViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLBoxPayDetailTableViewCell : UITableViewCell
- (void)setBoxData:(Model_blind_boxes_Data *)boxData boxOpenPayType:(JLBoxOpenPayType)boxOpenPayType;
@end

NS_ASSUME_NONNULL_END
