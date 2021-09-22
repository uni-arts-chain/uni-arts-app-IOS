//
//  JLMultiChainWalletViewController.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLMultiChainWalletViewController : JLBaseViewController

@property (nonatomic, assign) JLMultiChainSymbol chainSymbol;
@property (nonatomic, assign) JLMultiChainName chainName;
@property (nonatomic, copy) NSString *imageNamed;

@end

NS_ASSUME_NONNULL_END
