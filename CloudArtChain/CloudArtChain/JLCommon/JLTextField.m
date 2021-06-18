//
//  JLTextField.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLTextField.h"

@implementation JLTextField

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + bounds.size.width - (bounds.size.height - _jl_insets.top - _jl_insets.bottom) - _jl_insets.right, _jl_insets.top, bounds.size.height - _jl_insets.top - _jl_insets.bottom, bounds.size.height - _jl_insets.top - _jl_insets.bottom);
}

@end
