//
//  JLDappChooseChainServerCell.h
//  CloudArtChain
//
//  Created by jielian on 2021/10/25.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLDappChooseChainServerCell : UITableViewCell

@property (nonatomic, assign) BOOL isChoosed;

@property (nonatomic, strong) Model_eth_rpc_server_data *rpcServerData;

@end

NS_ASSUME_NONNULL_END
