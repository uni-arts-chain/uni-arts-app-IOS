//
//  JLScanViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLScanType) {
    JLScanTypeChainQuery = 1,
    JLScanTypeImportWallet,
    JLScanTypeOther,
    JLScanTypeAddress,
};

typedef void(^ScanResultBlock)(NSString *scanResult);

@interface JLScanViewController : UIViewController
@property (nonatomic, assign) JLScanType scanType;
@property (nonatomic, assign) BOOL qrCode;
@property (nonatomic,   copy) ScanResultBlock resultBlock;
@end

NS_ASSUME_NONNULL_END
