//
//  JLWorkListListedCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/17.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLWorkListBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLWorkListListedCell : JLWorkListBaseTableViewCell
@property (nonatomic, copy) void(^offFromListBlock)(Model_art_Detail_Data *artDetailData);
@property (nonatomic, copy) void(^applyAddCertBlock)(Model_art_Detail_Data *artDetailData);
@end

NS_ASSUME_NONNULL_END
