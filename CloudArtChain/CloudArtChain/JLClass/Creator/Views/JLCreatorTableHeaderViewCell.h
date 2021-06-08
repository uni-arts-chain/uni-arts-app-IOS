//
//  JLCreatorTableHeaderViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/6/8.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLCreatorTableHeaderViewCell : UITableViewCell
- (void)setAuthorData:(Model_art_author_Data *)authorData indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
