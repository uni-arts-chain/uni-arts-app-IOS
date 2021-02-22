//
//  JLEditWalletCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/4.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLEditWalletCell : UITableViewCell
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic,   copy) NSString *title;
@property (nonatomic,   copy) NSString *statusText;
@property (nonatomic, strong) NSString *editContent;
@end

NS_ASSUME_NONNULL_END
