//
//  JLCertificateButton.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLCertificateButton : UIControl
@property (nonatomic,   copy) NSString *defauleImageName;
@property (nullable, nonatomic, strong) UIImage *uploadImage;
@property (nonatomic,   copy) NSString *uploadName;
@property (nonatomic, assign) BOOL isUploadSuccess;

@property (nonatomic, strong) UIImageView *topLeftImage;
@property (nonatomic, strong) UIImageView *topRightImage;
@property (nonatomic, strong) UIImageView *botLeftImage;
@property (nonatomic, strong) UIImageView *botRightImage;
@property (nonatomic, strong) UIImageView *centerImage;
@property (nonatomic, strong) UIImageView *addIamge;

//上传成功后更新图片
- (void)updateDisplayImage;
//删除当前图片
- (void)removeDisplayImage;
@end

NS_ASSUME_NONNULL_END
