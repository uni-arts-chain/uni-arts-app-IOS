//
//  JLApplyCertWorksMechanismSignCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLApplyCertWorksMechanismSignCell : UITableViewCell
@property (nonatomic, strong) Model_art_Detail_Data *artDetailData;
- (void)worksSelected:(BOOL)selected;
@end

NS_ASSUME_NONNULL_END
