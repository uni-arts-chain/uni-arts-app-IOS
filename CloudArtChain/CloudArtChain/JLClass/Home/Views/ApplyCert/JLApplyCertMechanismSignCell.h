//
//  JLApplyCertMechanismSignCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLApplyCertMechanismSignCell : UITableViewCell
- (void)setIndex:(NSInteger)index total:(NSInteger)total organizationData:(Model_organizations_Data *)organizationData;
@end

NS_ASSUME_NONNULL_END
