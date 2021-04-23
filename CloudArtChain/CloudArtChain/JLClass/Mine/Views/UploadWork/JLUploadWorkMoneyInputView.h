//
//  JLUploadWorkMoneyInputView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/18.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLUploadWorkMoneyInputView : JLBaseView
@property (nonatomic, strong) NSString *inputContent;
@property (nonatomic, copy) void(^inputContentChangeBlock)(void);
- (instancetype)initWithTitle:(NSString *)title;
- (void)refreshWithTitle:(NSString *)title showUnit:(BOOL)showUnit;
@end

NS_ASSUME_NONNULL_END
