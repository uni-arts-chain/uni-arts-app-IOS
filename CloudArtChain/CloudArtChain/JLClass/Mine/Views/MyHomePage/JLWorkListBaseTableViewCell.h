//
//  JLWorkListBaseTableViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/26.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLWorkListBaseTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) Model_art_Detail_Data *artDetailData;
@end

NS_ASSUME_NONNULL_END
