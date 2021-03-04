//
//  JLDescriptionContentView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLDescriptionContentView : UIView
@property (nonatomic, strong) NSString *inputContent;
- (instancetype)initWithMax:(NSInteger)maxInput placeholder:(NSString *)placeholder content:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
