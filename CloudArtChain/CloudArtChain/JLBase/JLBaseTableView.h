//
//  JLBaseTableView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^EndEditBlock)(void);

@interface JLBaseTableView : UITableView

@property (nonatomic, copy) EndEditBlock endEditBlock;
@end

NS_ASSUME_NONNULL_END
