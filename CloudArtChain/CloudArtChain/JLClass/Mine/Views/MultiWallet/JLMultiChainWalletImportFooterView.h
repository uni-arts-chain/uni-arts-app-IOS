//
//  JLMultiChainWalletImportFooterView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^JLMultiChainWalletImportFooterViewChangeTextBlock)(NSString *text);

@interface JLMultiChainWalletImportFooterView : UIView

@property (nonatomic, copy) JLMultiChainWalletImportFooterViewChangeTextBlock changeTextBlock;

@property (nonatomic, assign) JLMultiChainImportType importType;
@property (nonatomic, copy) NSString *sourceText;

@end

NS_ASSUME_NONNULL_END
