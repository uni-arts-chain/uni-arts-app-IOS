//
//  JLSettingTableViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/15.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLSettingTableViewCell : UITableViewCell
- (void)setTitle:(NSString *)title status:(NSString *)status isAvatar:(BOOL)isAvatar showLine:(BOOL)showLine showArrow:(BOOL)showArrow;
- (void)setAvatarImage:(UIImage *)avatarImage;
@end

NS_ASSUME_NONNULL_END
