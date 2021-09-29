//
//  JLDappBrowserNavigationBar.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/28.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^JLDappBrowserNavigationBarManagerBlock)(void);
typedef void(^JLDappBrowserNavigationBarCloseBlock)(void);

@interface JLDappBrowserNavigationBar : UIView

@property (nonatomic, copy) NSString *title;

- (instancetype)initWithFrame:(CGRect)frame
                        title: (NSString *)title
                      manager: (JLDappBrowserNavigationBarManagerBlock)manager
                        close: (JLDappBrowserNavigationBarCloseBlock)close;

@end

NS_ASSUME_NONNULL_END
