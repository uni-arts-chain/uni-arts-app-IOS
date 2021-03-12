//
//  JLCreatorTableViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLCreatorTableViewCell : UITableViewCell
@property (nonatomic, strong) Model_members_pre_artist_topic_Data *preTopicData;
@property (nonatomic, strong) UIViewController *viewController;
@end

NS_ASSUME_NONNULL_END
