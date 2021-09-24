//
//  JLMultiChainWalletImportChooseTypeView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/24.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLMultiChainWalletImportChooseTypeViewCompleteBlock)(JLMultiChainImportType selectType);

@interface JLMultiChainWalletImportChooseTypeView : UIView

+ (void)showWithTitle:(NSString *)title
          sourceArray: (NSArray *)sourceArray
    defaultImportType: (JLMultiChainImportType)defaultImportType
           completion: (JLMultiChainWalletImportChooseTypeViewCompleteBlock)completion;

@end

NS_ASSUME_NONNULL_END
