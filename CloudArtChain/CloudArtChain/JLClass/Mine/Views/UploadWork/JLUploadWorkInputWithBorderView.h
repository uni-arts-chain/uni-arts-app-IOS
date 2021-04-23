//
//  JLUploadWorkInputWithBorderView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLUploadWorkInputWithBorderView : JLBaseView
@property (nonatomic, strong) NSString *inputContent;

- (instancetype)initWithMaxInput:(NSInteger)maxInput placeholder:(NSString *)placeHolder;
@property (nonatomic, copy) void(^inputContentChangeBlock)(void);
@end

NS_ASSUME_NONNULL_END
