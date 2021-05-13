//
//  JLDocumentPickerViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/5/11.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLDocumentPickerViewController.h"

@interface JLDocumentPickerViewController ()

@end

@implementation JLDocumentPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UITabBar appearance] setTranslucent:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UITabBar appearance] setTranslucent:NO];
}

- (void)dealloc {
    [[UITabBar appearance] setTranslucent:NO];
}

@end
