//
//  JLDappSearchNavigationBar.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/28.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JLDappSearchNavigationBarDelegate <NSObject>

- (void)searchWithSearchText: (NSString *)searchText;

- (void)cancel;

@end

@interface JLDappSearchNavigationBar : UIView

@property (nonatomic, weak) id<JLDappSearchNavigationBarDelegate> delegate;

@property (nonatomic, copy) NSString *selectSearchText;

@end

