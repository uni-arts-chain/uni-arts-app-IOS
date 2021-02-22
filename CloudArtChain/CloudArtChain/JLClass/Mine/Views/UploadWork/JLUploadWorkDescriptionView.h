//
//  JLUploadWorkDescriptionView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/18.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

@interface JLUploadWorkDescriptionView : JLBaseView
@property (nonatomic, strong) NSString *inputContent;

- (instancetype)initWithMax:(NSInteger)maxInput placeholder:(NSString *)placeholder placeHolderColor:(UIColor *)placeHolderColor textFont:(UIFont *)textFont textColor:(UIColor *)textColor;
@end
