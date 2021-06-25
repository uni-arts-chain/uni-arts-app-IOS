//
//  JLUploadWorkSelectView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/18.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLUploadWorkSelectView : JLBaseView
@property (nonatomic, assign) BOOL isHiddenBottomLine;
@property (nonatomic, assign) BOOL isSecondLevelView; // 是否是展开的二级视图
- (instancetype)initWithPlaceHolder:(NSString *)placeHolder selectBlock:(void(^)(void))selectBlock;
- (instancetype)initWithTitle:(NSString *)title selectBlock:(void(^)(void))selectBlock;
- (void)setSelectContent:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
