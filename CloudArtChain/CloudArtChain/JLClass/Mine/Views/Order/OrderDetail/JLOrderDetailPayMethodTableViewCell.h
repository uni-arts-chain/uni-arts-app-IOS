//
//  JLOrderDetailPayMethodTableViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/15.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLOrderPayType) {
    JLOrderPayTypeWeChat,
    JLOrderPayTypeAlipay,
};

@interface JLOrderDetailPayMethodTableViewCell : UITableViewCell
@property (nonatomic, copy) void(^selectedMethodBlock)(JLOrderPayType payType);
@end

NS_ASSUME_NONNULL_END
