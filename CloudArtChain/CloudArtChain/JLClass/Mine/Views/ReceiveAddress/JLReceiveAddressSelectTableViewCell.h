//
//  JLReceiveAddressSelectTableViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/28.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLReceiveAddressSelectTableViewCell : UITableViewCell
@property (nonatomic, copy) void(^selectedBlock)(void);
@property (nonatomic, copy) NSString *inputContent;

- (void)setTitle:(NSString *)title placeholder:(NSString *)placeholder;
- (void)setSelectedContent:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
