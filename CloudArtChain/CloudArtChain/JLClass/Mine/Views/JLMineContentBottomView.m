//
//  JLMineContentBottomView.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/21.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMineContentBottomView.h"

@interface JLMineContentBottomView ()

@property (nonatomic, copy) NSArray *titleArray;

@property (nonatomic, copy) NSArray *imageArray;

@end

@implementation JLMineContentBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JL_color_white_ffffff;
        self.layer.cornerRadius = 10;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    CGFloat itemH = 51;
    for (int i = 0; i < self.titleArray.count; i++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.tag = 100 + i;
        itemView.userInteractionEnabled = YES;
        [itemView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemViewDidTap:)]];
        [self addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(i * itemH);
            make.height.mas_equalTo(@(itemH));
            if (i == self.titleArray.count - 1) {
                make.bottom.equalTo(self);
            }
        }];
        
        UIView *itemBgView = [[UIView alloc] init];
        [itemView addSubview:itemBgView];
        [itemBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.centerY.equalTo(itemView).offset(5);
            }else if (i == self.titleArray.count - 1) {
                make.centerY.equalTo(itemView).offset(-6);
            }else {
                make.centerY.equalTo(itemView).offset(-1);
            }
            make.left.right.equalTo(itemView);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:self.imageArray[i]];
        [itemBgView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemBgView).offset(12);
            make.top.bottom.equalTo(itemBgView);
            make.width.height.mas_equalTo(@20);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = self.titleArray[i];
        titleLabel.textColor = JL_color_black_101220;
        titleLabel.font = kFontPingFangSCRegular(14);
        [itemBgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(11);
            make.centerY.equalTo(imgView);
        }];
        
        UIImageView *arrowImgView = [[UIImageView alloc] init];
        arrowImgView.image = [UIImage imageNamed:@"mine_arrow_icon"];
        [itemBgView addSubview:arrowImgView];
        [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(itemBgView).offset(-12);
            make.centerY.equalTo(imgView);
            make.size.mas_equalTo(CGSizeMake(7, 12));
        }];
    }
}

#pragma mark - event response
- (void)itemViewDidTap: (UITapGestureRecognizer *)ges {
    if (_selectItemBlock) {
        _selectItemBlock(ges.view.tag - 100);
    }
}

#pragma mark - setters and getters
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"我的主页",@"上传作品",@"作品收藏"];
    }
    return _titleArray;
}

- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = @[@"icon_mine_app_homepage",
                        @"icon_mine_app_work_upload",
                        @"icon_mine_app_collect"];
    }
    return _imageArray;
}


@end
