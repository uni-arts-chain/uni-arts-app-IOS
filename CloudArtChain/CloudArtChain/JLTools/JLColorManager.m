//
//  JLColorManager.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLColorManager.h"

static id inst = nil;

@implementation JLColorManager
+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[self alloc] init];
    });
    return inst;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupColor];
    }
    return self;
}

- (void)setupColor {
    _bgcolorMain = [UIColor colorWithHexString:@"#F2F2F7"];
    _blackColor = [UIColor colorWithHexString:@"#000000"];
    _darkgrayColor = [UIColor colorWithHexString:@"#7a7d80"];
    _grayColor = [UIColor colorWithHexString:@"#c4c8cc"];
    _greenColor = [UIColor colorWithHexString:@"#00ae77"];
    _redColor = [UIColor colorWithHexString:@"#e24e60"];
    _orangeColor = [UIColor colorWithHexString:@"#ee7f11"];
    _blueColor = [UIColor colorWithHexString:@"#0079ff"];
    _fontDeep = [UIColor colorWithHexString:@"#303133"];
    _clearColor = [UIColor clearColor];
    
    _gray_101010 = [UIColor colorWithHexString:@"#101010"];
    _gray_212121 = [UIColor colorWithHexString:@"#212121"];
    _gray_333333 = [UIColor colorWithHexString:@"#333333"];
    _gray_666666 = [UIColor colorWithHexString:@"#666666"];
    _gray_606060 = [UIColor colorWithHexString:@"#606060"];
    _gray_8D8D8D = [UIColor colorWithHexString:@"#8D8D8D"];
    _gray_909090 = [UIColor colorWithHexString:@"#909090"];
    _gray_999999 = [UIColor colorWithHexString:@"#999999"];
    _gray_A4A4A4 = [UIColor colorWithHexString:@"#A4A4A4"];
    _gray_ADADAD = [UIColor colorWithHexString:@"#ADADAD"];
    _gray_BBBBBB = [UIColor colorWithHexString:@"#BBBBBB"];
    _gray_BEBEBE = [UIColor colorWithHexString:@"#BEBEBE"];
    _gray_C5C5C5 = [UIColor colorWithHexString:@"#C5C5C5"];
    _gray_CBCBCB = [UIColor colorWithHexString:@"#CBCBCB"];
    _gray_CCCCCC = [UIColor colorWithHexString:@"#CCCCCC"];
    _gray_E2E2E2 = [UIColor colorWithHexString:@"#E2E2E2"];
    _gray_E6E6E6 = [UIColor colorWithHexString:@"#E6E6E6"];
    _gray_EBEBEB = [UIColor colorWithHexString:@"#EBEBEB"];
    _gray_EEEEEE = [UIColor colorWithHexString:@"#EEEEEE"];
    _gray_EFEFEF = [UIColor colorWithHexString:@"#EFEFEF"];
    _gray_F5F5F5 = [UIColor colorWithHexString:@"#F5F5F5"];
    _gray_F3F3F3 = [UIColor colorWithHexString:@"#F3F3F3"];
    _gray_F6F6F6 = [UIColor colorWithHexString:@"#F6F6F6"];
    _gray_414141 = [UIColor colorWithHexString:@"#414141"];
    _gray_4D4D4D = [UIColor colorWithHexString:@"#4D4D4D"];
    _gray_B3B3B3 = [UIColor colorWithHexString:@"#B3B3B3"];
    _gray_D4D4D4 = [UIColor colorWithHexString:@"#D4D4D4"];
    _gray_DDDDDD = [UIColor colorWithHexString:@"#DDDDDD"];
    
    _white_ffffff = [UIColor colorWithHexString:@"#FFFFFF"];
    
    _green_00A7B6 = [UIColor colorWithHexString:@"#00A7B6"];
    _green_2EA496 = [UIColor colorWithHexString:@"#2EA496"];
    _green_9DDC81 = [UIColor colorWithHexString:@"#9DDC81"];
    _green_48B422 = [UIColor colorWithHexString:@"#48B422"];
    
    _blue_4FBCF9 = [UIColor colorWithHexString:@"#4FBCF9"];
    _blue_018FFF = [UIColor colorWithHexString:@"#018FFF"];
    _blue_5FB9EB = [UIColor colorWithHexString:@"#5FB9EB"];
    _blue_38B2F1 = [UIColor colorWithHexString:@"#38B2F1"];
    _blue_50C3FF = [UIColor colorWithHexString:@"#50C3FF"];
    _blue_7ed4ff = [UIColor colorWithHexString:@"#7ed4ff"];
    _blue_88D6FF = [UIColor colorWithHexString:@"#88D6FF"];
    _blue_C7ECFF = [UIColor colorWithHexString:@"#C7ECFF"];
    _blue_CFEFFF = [UIColor colorWithHexString:@"#CFEFFF"];
    _blue_165B7F = [UIColor colorWithHexString:@"#165B7F"];
    _blue_E1F5FF = [UIColor colorWithHexString:@"#E1F5FF"];
    _blue_EAF8FF = [UIColor colorWithHexString:@"#EAF8FF"];
    _blue_99DCFF = [UIColor colorWithHexString:@"#99DCFF"];
    
    _red_D70000 = [UIColor colorWithHexString:@"#D70000"];
    
    _orange_FF8150 = [UIColor colorWithHexString:@"#FF8150"];
    _orange_FFEBD4 = [UIColor colorWithHexString:@"#FFEBD4"];
    _orange_FF8650 = [UIColor colorWithHexString:@"#FF8650"];
    _orange_FF7F1F = [UIColor colorWithHexString:@"#FF7F1F"];
    
    _yellow_FFCA50 = [UIColor colorWithHexString:@"#FFCA50"];
    
    _black_1E1D1E = [UIColor colorWithHexString:@"#1E1D1E"];
    _black_34394C = [UIColor colorWithHexString:@"#34394C"];
    
    _other_D2D4DC = [UIColor colorWithHexString:@"#D2D4DC"];
    _other_4C5B86 = [UIColor colorWithHexString:@"#4C5B86"];
    _other_B25F00 = [UIColor colorWithHexString:@"#B25F00"];
    
    _groupTableBackground = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:247.0/255 alpha:1.0];
    _bgGreenColor = [UIColor colorWithHexString:@"#d9f3eb"];
    _bgRedColor = [UIColor colorWithHexString:@"#fbe5e7"];
    
    _bgIntervalColor = [UIColor colorWithHexString:@"#f6f7fa"];
    _gridLineColor = [UIColor colorWithHexString:@"#ebebeb"];
    
    _shadowColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _bgPopColor = [UIColor colorWithHexString:@"#ffffff"];
    _bgBlockColor = [UIColor colorWithHexString:@"#f2f3f5"];
    _bgBorderColor = [UIColor colorWithHexString:@"#D1D9E6"];
    
    if (@available(iOS 13.0, *)){
        [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDarkContent) animated:YES];
    }else {
        [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault) animated:YES];
    }
}
@end
