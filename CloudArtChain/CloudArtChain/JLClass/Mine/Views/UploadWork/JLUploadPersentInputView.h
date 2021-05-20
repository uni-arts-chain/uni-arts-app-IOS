//
//  JLUploadPersentInputView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/5/19.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLUploadPersentInputView : JLBaseView
@property (nonatomic, strong) NSString *inputContent;

- (instancetype)initWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
