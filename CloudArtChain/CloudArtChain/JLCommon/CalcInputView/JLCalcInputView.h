//
//  JLCalcInputView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLCalcInputView : UIView
@property (nonatomic, strong) NSString *inputContent;
- (instancetype)initWithMaxInput:(NSInteger)maxInput placeholder:(NSString *)placeHolder content:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
