//
//  JLChainQRCodeView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/13.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLChainQRCodeView.h"
#import <SGQRCode/SGQRCode.h>

@interface JLChainQRCodeView()
@property (nonatomic, strong) UIImageView *qrcodeImageView;
@end

@implementation JLChainQRCodeView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.qrcodeImageView];
    [self.qrcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f));
    }];
}

- (UIImageView *)qrcodeImageView {
    if (!_qrcodeImageView) {
        _qrcodeImageView = [[UIImageView alloc] init];
        UIImage *qrcodeImage = [SGQRCodeObtain generateQRCodeWithData:@"https://www.baidu.com" size:self.frameWidth];
        _qrcodeImageView.image = qrcodeImage;
    }
    return _qrcodeImageView;
}

@end
