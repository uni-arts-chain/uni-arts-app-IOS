//
//  JLCustomerServiceViewController.m
//  CloudArtChain
//
//  Created by 花田半亩 on 2020/9/6.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCustomerServiceViewController.h"
#import "JLCustomerServiceContentView.h"

@interface JLCustomerServiceViewController ()

@property (nonatomic, strong) JLCustomerServiceContentView *contentView;

@end

@implementation JLCustomerServiceViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"客服";
    [self addBackItem];
    
    [self.view addSubview:self.contentView];
}

#pragma mark - setters and getters
- (JLCustomerServiceContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLCustomerServiceContentView alloc] initWithFrame:self.view.bounds];
    }
    return _contentView;
}

@end
