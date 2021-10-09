//
//  JLDappSearchContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/28.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JLDappSearchContentViewDelegate <NSObject>

- (void)searchWithSearchText: (NSString *)searchText;

- (void)cancel;

- (void)lookDappWithDappData: (Model_dapp_Data *)dappData;

@end


@interface JLDappSearchContentView : UIView

@property (nonatomic, weak) id<JLDappSearchContentViewDelegate> delegate;

@property (nonatomic, copy) NSArray *hotSearchArray;

@property (nonatomic, copy) NSArray *searchResultArray;


@end
