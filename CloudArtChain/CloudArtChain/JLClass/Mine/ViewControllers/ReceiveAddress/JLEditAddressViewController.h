//
//  JLEditAddressViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/21.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLEidtAddressType) {
    JLEidtAddressTypeAdd, /** 新增地址 */
    JLEidtAddressTypeEdit, /** 编辑地址 */
};

@interface JLEditAddressViewController : JLBaseViewController
@property (nonatomic, assign) JLEidtAddressType editAdressType;
@end

NS_ASSUME_NONNULL_END
