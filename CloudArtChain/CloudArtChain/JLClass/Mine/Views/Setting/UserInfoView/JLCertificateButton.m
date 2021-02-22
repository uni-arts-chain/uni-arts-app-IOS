//
//  JLCertificateButton.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCertificateButton.h"

@interface JLCertificateButton()

@end

@implementation JLCertificateButton
- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:247.0f / 255.0f green:249.0f / 255.0f blue:250.0f / 255.0f alpha:1.0f];
        self.layer.cornerRadius = 5.0f;
        [self createView];
    }
    return self;
}

- (void)createView {
    [self addSubview:self.topLeftImage];
    [self addSubview:self.topRightImage];
    [self addSubview:self.botLeftImage];
    [self addSubview:self.botRightImage];
    [self addSubview:self.centerImage];
    [self.centerImage addSubview:self.addIamge];
    [self.topLeftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20.0f);
        make.left.mas_equalTo(50.0f);
        make.size.mas_equalTo(15.0f);
    }];
    [self.topRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20.0f);
        make.right.mas_equalTo(-50.0f);
        make.size.mas_equalTo(15.0f);
    }];
    [self.botLeftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20.0f);
        make.left.mas_equalTo(50.0f);
        make.size.mas_equalTo(15.0f);
    }];
    [self.botRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20.0f);
        make.right.mas_equalTo(-50.0f);
        make.size.mas_equalTo(15.0f);
    }];
    [self.centerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.topLeftImage).offset(3.0f);
        make.right.bottom.mas_equalTo(self.botRightImage).offset(-3.0f);
    }];
    [self.addIamge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0.0f);
        make.width.height.mas_equalTo(60.0f);
    }];
}

- (UIImageView *)topLeftImage {
    if (!_topLeftImage) {
        _topLeftImage = [[UIImageView alloc] init];
        _topLeftImage.image = [UIImage imageNamed:@"icon_mine_realname_topleft"];
    }
    return _topLeftImage;
}

- (UIImageView *)topRightImage {
    if (!_topRightImage) {
        _topRightImage = [[UIImageView alloc] init];
        _topRightImage.image = [UIImage imageNamed:@"icon_mine_realname_topright"];
    }
    return _topRightImage;
}

- (UIImageView *)botLeftImage {
    if (!_botLeftImage) {
        _botLeftImage = [[UIImageView alloc] init];
        _botLeftImage.image = [UIImage imageNamed:@"icon_mine_realname_bottomleft"];
    }
    return _botLeftImage;
}

- (UIImageView *)botRightImage {
    if (!_botRightImage) {
        _botRightImage = [[UIImageView alloc] init];
        _botRightImage.image = [UIImage imageNamed:@"icon_mine_realname_bottomright"];
    }
    return _botRightImage;
}

- (UIImageView *)addIamge {
    if (!_addIamge) {
        _addIamge = [[UIImageView alloc] init];
        _addIamge.image = [UIImage imageNamed:@"添加"];
    }
    return _addIamge;
}

- (UIImageView *)centerImage {
    if (!_centerImage) {
        _centerImage = [[UIImageView alloc] init];
        _centerImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _centerImage;
}

- (void)setDefauleImageName:(NSString *)defauleImageName {
    _defauleImageName = defauleImageName;
    self.centerImage.image = [UIImage imageNamed:defauleImageName];
}

- (void)updateDisplayImage {
    self.isUploadSuccess = YES;
    self.centerImage.image = self.uploadImage;
    self.addIamge.hidden = YES;
    self.centerImage.contentMode = UIViewContentModeScaleToFill;
}

- (void)removeDisplayImage {
    self.isUploadSuccess = NO;
    self.uploadImage = nil;
    self.addIamge.hidden = NO;
    self.centerImage.image = [UIImage imageNamed:self.defauleImageName];
    self.centerImage.contentMode = UIViewContentModeScaleAspectFit;
}
@end
