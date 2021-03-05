//
//  JLSelectWorksViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

typedef NS_ENUM(NSUInteger, JLSelectWorksType) {
    JLSelectWorksTypeSelfSign = 1, /** 自签名 */
    JLSelectWorksTypeMechanismAddSign, /** 机构加签 */
};

NS_ASSUME_NONNULL_BEGIN

@interface JLSelectWorksViewController : JLBaseViewController
@property (nonatomic, assign) JLSelectWorksType selectType;
@property (nonatomic,   copy) void(^selectWorkBlock)(Model_art_Detail_Data *artData);
@property (nonatomic, strong) Model_organizations_Data *organizationData;
@end

NS_ASSUME_NONNULL_END
