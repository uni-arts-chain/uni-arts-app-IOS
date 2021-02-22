//
//  JLSearchHIstoryTableViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLSearchHIstoryTableViewCell : UITableViewCell
@property (nonatomic, copy) void(^deleteBlock)(void);
@property (nonatomic, copy) NSString *historyContent;
@end

NS_ASSUME_NONNULL_END
