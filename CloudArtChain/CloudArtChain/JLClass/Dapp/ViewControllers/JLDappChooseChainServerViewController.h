//
//  JLDappChooseChainServerViewController.h
//  CloudArtChain
//
//  Created by jielian on 2021/10/25.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLDappChooseChainServerViewControllerChooseBlock)(Model_eth_rpc_server_data *rpcServerData);

@interface JLDappChooseChainServerViewController : JLBaseViewController

@property (nonatomic, copy) JLDappChooseChainServerViewControllerChooseBlock chooseBlock;

@end

NS_ASSUME_NONNULL_END
