//
//  JLDappNavigationBar.h
//  CloudArtChain
//
//  Created by jielian on 2021/10/25.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLDappNavigationBarChooseBlock)(void);

@interface JLDappNavigationBar : UIView

@property (nonatomic, copy) JLDappNavigationBarChooseBlock chooseBlock;

@property (nonatomic, copy) NSString *chainServerName;

@end

NS_ASSUME_NONNULL_END
