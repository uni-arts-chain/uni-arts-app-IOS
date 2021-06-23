//
//  JLGuidePageScrollView.h
//  CloudArtChain
//
//  Created by jielian on 2021/6/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JLGuidePageScrollViewCompleteBlock)(void);

@interface JLGuidePageScrollView : UIView

+ (void)showWithComplete: (JLGuidePageScrollViewCompleteBlock)complete;

@end
