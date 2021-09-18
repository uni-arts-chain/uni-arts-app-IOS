//
//  JLMultiChainWalletInfoViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletInfoViewController.h"

@interface JLMultiChainWalletInfoViewController ()

@end

@implementation JLMultiChainWalletInfoViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _walletInfo.symbol;
    [self addBackItem];
    
}


@end
