//
//  JLHomeAppView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLHomeAppView : UIView
@property (nonatomic, copy) void(^selectAppBlock)(NSInteger index);
@end

