//
//  JLDappChooseChainServerContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/10/25.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLDappChooseChainServerContentViewDelegate <NSObject>

- (void)chooseEthRPCServerData: (Model_eth_rpc_server_data *)ethRPCServerData;

@end

@interface JLDappChooseChainServerContentView : UIView

@property (nonatomic, weak) id<JLDappChooseChainServerContentViewDelegate> delegate;

@property (nonatomic, copy) NSArray *dataArray;

@end

NS_ASSUME_NONNULL_END
