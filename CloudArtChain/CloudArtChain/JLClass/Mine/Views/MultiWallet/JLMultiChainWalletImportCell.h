//
//  JLMultiChainWalletImportCell.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLMultiChainWalletImportCellStyle) {
    JLMultiChainWalletImportCellStyleDefault,
    JLMultiChainWalletImportCellStylePaste,
    JLMultiChainWalletImportCellStyleEdit
};

typedef NS_ENUM(NSUInteger, JLMultiChainWalletImportCellEditType) {
    JLMultiChainWalletImportCellEditTypeWalletName,
    JLMultiChainWalletImportCellEditTypePassword
};

typedef void(^JLMultiChainWalletImportCellEditBlock)(NSString *inputText);

@interface JLMultiChainWalletImportCell : UITableViewCell

@property (nonatomic, copy) JLMultiChainWalletImportCellEditBlock editBlock;

- (void)setTitle: (NSString *)title placeholder: (NSString *)placeholder defaultText: (NSString * _Nullable)defaultText style: (JLMultiChainWalletImportCellStyle)style eidtType: (JLMultiChainWalletImportCellEditType)editType;

@end

NS_ASSUME_NONNULL_END
