//
//  JLDappTrackCell.h
//  CloudArtChain
//
//  Created by jielian on 2021/10/8.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLDappTrackCellLookDappBlock)(Model_dapp_Data *dappData);

@interface JLDappTrackCell : UITableViewCell

@property (nonatomic, copy) JLDappTrackCellLookDappBlock lookDappBlock;

@property (nonatomic, copy) NSArray *trackArray;

@end

NS_ASSUME_NONNULL_END
