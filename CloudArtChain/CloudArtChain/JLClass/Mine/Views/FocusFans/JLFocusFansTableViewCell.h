//
//  JLFocusFansTableViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/4.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLFocusFansTableViewCell : UITableViewCell
@property (nonatomic, copy) void(^focusBlock)(Model_art_author_Data *authorData);
@property (nonatomic, copy) void(^cancleFocusBlock)(Model_art_author_Data *authorData);

- (void)setAuthor:(Model_art_author_Data *)authorData isLastCell:(BOOL)isLast;

@end

NS_ASSUME_NONNULL_END
