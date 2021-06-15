//
//  QGYAnimationEasingHelper.h
//
//  Created by fyzq on 2020/12/8.
//

#import <Foundation/Foundation.h>
#import "QGYEasing.h"

NS_ASSUME_NONNULL_BEGIN

@interface QGYAnimationEasingHelper : NSObject

+ (NSMutableArray *)interpolateValues: (QGYEasingFunction)function
                            fromValue:(NSValue *)fromValue
                              toValue:(NSValue *)toValue;

+ (NSMutableArray *)interpolateValues: (QGYEasingFunction)function
                            fromValue:(NSValue *)fromValue
                              toValue:(NSValue *)toValue
                        keyframeCount: (NSInteger)keyframeCount;

@end

NS_ASSUME_NONNULL_END
