//
//  JLDappModel.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/27.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLDappModel : NSObject

@end

//////////////////////////////////////////////////////////////////////////
#pragma mark dapp 信息
@protocol Model_dapp_Data @end
@interface Model_dapp_Data : Model_Interface
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *img;
@end

