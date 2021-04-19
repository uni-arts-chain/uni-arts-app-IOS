//
//  JLStepper.h
//  Miner_Pow
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JLStepperCallback)(double value);

@interface JLStepper : UIView

@property(nonatomic)BOOL isValueEditable;
@property(nonatomic)double minValue;
@property(nonatomic)double maxValue;
@property(nonatomic)double value;
@property(nonatomic)double stepValue;

@property(nonatomic,copy)JLStepperCallback valueChanged;

@end
