//
//  JLBaseTextField.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TextFieldType) {
    TextFieldType_tagName = 0,
    TextFieldType_withdrawAmout,
};

@interface JLBaseTextField : UITextField
@property (nonatomic, assign) TextFieldType textFieldType;
@property (nonatomic, strong) void (^isFullBlock)(void);
@end
