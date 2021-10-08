//
//  JLDappCell.h
//  CloudArtChain
//
//  Created by jielian on 2021/10/8.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^JLDappCellMoreBlock)(Model_chain_category_Data *dappData);
typedef void(^JLDappCellLookDappBlock)(Model_dapp_Data *dappData);

@interface JLDappCell : UITableViewCell

@property (nonatomic, copy) JLDappCellMoreBlock moreBlock;
@property (nonatomic, copy) JLDappCellLookDappBlock lookDappBlock;

@property (nonatomic, strong) Model_chain_category_Data *chainCategoryData;

@end

NS_ASSUME_NONNULL_END
