//
//  JLColorManager.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JL_COLOR_MAG [JLColorManager share]

#define JL_color_bgmain     JL_COLOR_MAG.bgcolorMain
#define JL_color_black      JL_COLOR_MAG.blackColor
#define JL_color_darkgray   JL_COLOR_MAG.darkgrayColor
#define JL_color_gray       JL_COLOR_MAG.grayColor
#define JL_color_green      JL_COLOR_MAG.greenColor
#define JL_color_red        JL_COLOR_MAG.redColor
#define JL_color_orange     JL_COLOR_MAG.orangeColor
#define JL_color_blue       JL_COLOR_MAG.blueColor
#define JL_color_fontdeep   JL_COLOR_MAG.fontDeep
#define JL_color_clear      JL_COLOR_MAG.clearColor

#define JL_color_gray_030303 JL_COLOR_MAG.gray_030303
#define JL_color_gray_101010 JL_COLOR_MAG.gray_101010
#define JL_color_gray_1A1A1A JL_COLOR_MAG.gray_1A1A1A
#define JL_color_gray_212121 JL_COLOR_MAG.gray_212121
#define JL_color_gray_333333 JL_COLOR_MAG.gray_333333
#define JL_color_gray_606060 JL_COLOR_MAG.gray_606060
#define JL_color_gray_666666 JL_COLOR_MAG.gray_666666
#define JL_color_gray_8D8D8D JL_COLOR_MAG.gray_8D8D8D
#define JL_color_gray_909090 JL_COLOR_MAG.gray_909090
#define JL_color_gray_999999 JL_COLOR_MAG.gray_999999
#define JL_color_gray_A4A4A4 JL_COLOR_MAG.gray_A4A4A4
#define JL_color_gray_ADADAD JL_COLOR_MAG.gray_ADADAD
#define JL_color_gray_BBBBBB JL_COLOR_MAG.gray_BBBBBB
#define JL_color_gray_BEBEBE JL_COLOR_MAG.gray_BEBEBE
#define JL_color_gray_C5C5C5 JL_COLOR_MAG.gray_C5C5C5
#define JL_color_gray_CBCBCB JL_COLOR_MAG.gray_CBCBCB
#define JL_color_gray_CCCCCC JL_COLOR_MAG.gray_CCCCCC
#define JL_color_gray_E2E2E2 JL_COLOR_MAG.gray_E2E2E2
#define JL_color_gray_E6E6E6 JL_COLOR_MAG.gray_E6E6E6
#define JL_color_gray_EBEBEB JL_COLOR_MAG.gray_EBEBEB
#define JL_color_gray_EEEEEE JL_COLOR_MAG.gray_EEEEEE
#define JL_color_gray_EFEFEF JL_COLOR_MAG.gray_EFEFEF
#define JL_color_gray_F3F3F3 JL_COLOR_MAG.gray_F3F3F3
#define JL_color_gray_F5F5F5 JL_COLOR_MAG.gray_F5F5F5
#define JL_color_gray_F6F6F6 JL_COLOR_MAG.gray_F6F6F6
#define JL_color_gray_414141 JL_COLOR_MAG.gray_414141
#define JL_color_gray_4D4D4D JL_COLOR_MAG.gray_4D4D4D
#define JL_color_gray_B3B3B3 JL_COLOR_MAG.gray_B3B3B3
#define JL_color_gray_D4D4D4 JL_COLOR_MAG.gray_D4D4D4
#define JL_color_gray_DDDDDD JL_COLOR_MAG.gray_DDDDDD
#define JL_color_gray_777575 JL_COLOR_MAG.gray_777575

#define JL_color_white_ffffff JL_COLOR_MAG.white_ffffff

#define JL_color_green_00DEBC JL_COLOR_MAG.green_00DEBC
#define JL_color_green_2EA496 JL_COLOR_MAG.green_2EA496
#define JL_color_green_9DDC81 JL_COLOR_MAG.green_9DDC81
#define JL_color_green_48B422 JL_COLOR_MAG.green_48B422

#define JL_color_blue_4FBCF9 JL_COLOR_MAG.blue_4FBCF9
#define JL_color_blue_018FFF JL_COLOR_MAG.blue_018FFF
#define JL_color_blue_5FB9EB JL_COLOR_MAG.blue_5FB9EB
#define JL_color_blue_165B7F JL_COLOR_MAG.blue_165B7F
#define JL_color_blue_337FFF JL_COLOR_MAG.blue_337FFF
#define JL_color_blue_38B2F1 JL_COLOR_MAG.blue_38B2F1
#define JL_color_blue_50C3FF JL_COLOR_MAG.blue_50C3FF
#define JL_color_blue_7ed4ff JL_COLOR_MAG.blue_7ed4ff
#define JL_color_blue_88D6FF JL_COLOR_MAG.blue_88D6FF
#define JL_color_blue_C7ECFF JL_COLOR_MAG.blue_C7ECFF
#define JL_color_blue_CFEFFF JL_COLOR_MAG.blue_CFEFFF
#define JL_color_blue_E1F5FF JL_COLOR_MAG.blue_E1F5FF
#define JL_color_blue_EAF8FF JL_COLOR_MAG.blue_EAF8FF
#define JL_color_blue_99DCFF JL_COLOR_MAG.blue_99DCFF
#define JL_color_blue_3D75ED JL_COLOR_MAG.blue_3D75ED
#define JL_color_blue_78A7FF JL_COLOR_MAG.blue_78A7FF
#define JL_color_blue_B2CDFF JL_COLOR_MAG.blue_B2CDFF
#define JL_color_blue_6077DF JL_COLOR_MAG.blue_6077DF

#define JL_color_purple_F0F5FF JL_COLOR_MAG.purple_F0F5FF
#define JL_color_purple_CADEFF JL_COLOR_MAG.purple_CADEFF

#define JL_color_red_D70000 JL_COLOR_MAG.red_D70000

#define JL_color_orange_FF8150     JL_COLOR_MAG.orange_FF8150
#define JL_color_orange_FFEBD4     JL_COLOR_MAG.orange_FFEBD4
#define JL_color_orange_FFB432     JL_COLOR_MAG.orange_FFB432
#define JL_color_orange_FF8650     JL_COLOR_MAG.orange_FF8650
#define JL_color_orange_FF7F1F     JL_COLOR_MAG.orange_FF7F1F
#define JL_color_orange_FFC63D    JL_COLOR_MAG.orange_FFC63D
#define JL_color_orange_FF9E2C     JL_COLOR_MAG.orange_FF9E2C

#define JL_color_yellow_FFCA50     JL_COLOR_MAG.yellow_FFCA50
#define JL_color_yellow_FFCC5E     JL_COLOR_MAG.yellow_FFCC5E

#define JL_color_black_010034     JL_COLOR_MAG.black_010034
#define JL_color_black_1E1D1E     JL_COLOR_MAG.black_1E1D1E
#define JL_color_black_34394C     JL_COLOR_MAG.black_34394C

#define JL_color_other_D2D4DC      JL_COLOR_MAG.other_D2D4DC
#define JL_color_other_4C5B86      JL_COLOR_MAG.other_4C5B86
#define JL_color_other_B25F00      JL_COLOR_MAG.other_B25F00

//tableview group
#define JL_color_groupTableBG  JL_COLOR_MAG.groupTableBackground
#define JL_color_bgGreen       JL_COLOR_MAG.bgGreenColor
#define JL_color_bgRed         JL_COLOR_MAG.bgRedColor

#define JL_color_bgInterval    JL_COLOR_MAG.bgIntervalColor
#define JL_color_gridLine      JL_COLOR_MAG.gridLineColor

#define JL_color_shadow        JL_COLOR_MAG.shadowColor
#define JL_color_bgPop         JL_COLOR_MAG.bgPopColor
#define JL_color_bgBlock       JL_COLOR_MAG.bgBlockColor
#define JL_color_bgBorder      JL_COLOR_MAG.bgBorderColor

@interface JLColorManager : NSObject
@property (nonatomic, strong) UIColor *bgcolorMain;
@property (nonatomic, strong) UIColor *blackColor;
@property (nonatomic, strong) UIColor *darkgrayColor;
@property (nonatomic, strong) UIColor *grayColor;
@property (nonatomic, strong) UIColor *greenColor;
@property (nonatomic, strong) UIColor *redColor;
@property (nonatomic, strong) UIColor *orangeColor;
@property (nonatomic, strong) UIColor *blueColor;
@property (nonatomic, strong) UIColor *fontDeep;
@property (nonatomic, strong) UIColor *clearColor;

@property (nonatomic, strong) UIColor *gray_030303;
@property (nonatomic, strong) UIColor *gray_101010;
@property (nonatomic, strong) UIColor *gray_1A1A1A;
@property (nonatomic, strong) UIColor *gray_212121;
@property (nonatomic, strong) UIColor *gray_333333;
@property (nonatomic, strong) UIColor *gray_666666;
@property (nonatomic, strong) UIColor *gray_606060;
@property (nonatomic, strong) UIColor *gray_8D8D8D;
@property (nonatomic, strong) UIColor *gray_909090;
@property (nonatomic, strong) UIColor *gray_999999;
@property (nonatomic, strong) UIColor *gray_A4A4A4;
@property (nonatomic, strong) UIColor *gray_ADADAD;
@property (nonatomic, strong) UIColor *gray_BBBBBB;
@property (nonatomic, strong) UIColor *gray_BEBEBE;
@property (nonatomic, strong) UIColor *gray_C5C5C5;
@property (nonatomic, strong) UIColor *gray_CBCBCB;
@property (nonatomic, strong) UIColor *gray_CCCCCC;
@property (nonatomic, strong) UIColor *gray_E2E2E2;
@property (nonatomic, strong) UIColor *gray_E6E6E6;
@property (nonatomic, strong) UIColor *gray_EBEBEB;
@property (nonatomic, strong) UIColor *gray_EEEEEE;
@property (nonatomic, strong) UIColor *gray_EFEFEF;
@property (nonatomic, strong) UIColor *gray_F5F5F5;
@property (nonatomic, strong) UIColor *gray_F6F6F6;
@property (nonatomic, strong) UIColor *gray_F3F3F3;
@property (nonatomic, strong) UIColor *gray_414141;
@property (nonatomic, strong) UIColor *gray_4D4D4D;
@property (nonatomic, strong) UIColor *gray_B3B3B3;
@property (nonatomic, strong) UIColor *gray_D4D4D4;
@property (nonatomic, strong) UIColor *gray_DDDDDD;
@property (nonatomic, strong) UIColor *gray_777575;

@property (nonatomic, strong) UIColor *white_ffffff;

@property (nonatomic, strong) UIColor *green_00DEBC;
@property (nonatomic, strong) UIColor *green_00A7B6;
@property (nonatomic, strong) UIColor *green_2EA496;
@property (nonatomic, strong) UIColor *green_9DDC81;
@property (nonatomic, strong) UIColor *green_48B422;

@property (nonatomic, strong) UIColor *blue_4FBCF9;
@property (nonatomic, strong) UIColor *blue_018FFF;
@property (nonatomic, strong) UIColor *blue_165B7F;
@property (nonatomic, strong) UIColor *blue_5FB9EB;
@property (nonatomic, strong) UIColor *blue_337FFF;
@property (nonatomic, strong) UIColor *blue_38B2F1;
@property (nonatomic, strong) UIColor *blue_50C3FF;
@property (nonatomic, strong) UIColor *blue_7ed4ff;
@property (nonatomic, strong) UIColor *blue_88D6FF;
@property (nonatomic, strong) UIColor *blue_C7ECFF;
@property (nonatomic, strong) UIColor *blue_CFEFFF;
@property (nonatomic, strong) UIColor *blue_E1F5FF;
@property (nonatomic, strong) UIColor *blue_EAF8FF;
@property (nonatomic, strong) UIColor *blue_99DCFF;
@property (nonatomic, strong) UIColor *blue_3D75ED;
@property (nonatomic, strong) UIColor *blue_78A7FF;
@property (nonatomic, strong) UIColor *blue_B2CDFF;
@property (nonatomic, strong) UIColor *blue_6077DF;

@property (nonatomic, strong) UIColor *purple_F0F5FF;
@property (nonatomic, strong) UIColor *purple_CADEFF;

@property (nonatomic, strong) UIColor *red_D70000;

@property (nonatomic, strong) UIColor *orange_FF8150;
@property (nonatomic, strong) UIColor *orange_FFEBD4;
@property (nonatomic, strong) UIColor *orange_FFB432;
@property (nonatomic, strong) UIColor *orange_FF8650;
@property (nonatomic, strong) UIColor *orange_FF7F1F;
@property (nonatomic, strong) UIColor *orange_FFC63D;
@property (nonatomic, strong) UIColor *orange_FF9E2C;

@property (nonatomic, strong) UIColor *yellow_FFCA50;
@property (nonatomic, strong) UIColor *yellow_FFCC5E;

@property (nonatomic, strong) UIColor *black_010034;
@property (nonatomic, strong) UIColor *black_1E1D1E;
@property (nonatomic, strong) UIColor *black_34394C;

@property (nonatomic, strong) UIColor *other_D2D4DC;
@property (nonatomic, strong) UIColor *other_4C5B86;
@property (nonatomic, strong) UIColor *other_B25F00;

@property (nonatomic, strong) UIColor *groupTableBackground;
@property (nonatomic, strong) UIColor *bgGreenColor;
@property (nonatomic, strong) UIColor *bgRedColor;

//间隔的颜色
@property (nonatomic, strong) UIColor *bgIntervalColor;
//线的颜色
@property (nonatomic, strong) UIColor *gridLineColor;


@property (nonatomic, strong) UIColor *shadowColor;
//pop 弹框的背景颜色
@property (nonatomic, strong) UIColor *bgPopColor;
//pop 弹框的背景颜色
@property (nonatomic, strong) UIColor *bgBlockColor;
//边框的颜色
@property (nonatomic, strong) UIColor *bgBorderColor;

+ (instancetype)share;
@end
