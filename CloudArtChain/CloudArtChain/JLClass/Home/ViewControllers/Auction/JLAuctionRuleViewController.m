//
//  JLAuctionRuleViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/21.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionRuleViewController.h"

@interface JLAuctionRuleViewController ()

@property (nonatomic, strong) UITextView *contentTextView;

@end

@implementation JLAuctionRuleViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"竞拍须知";
    [self addBackItem];
    
    [self.view addSubview:self.contentTextView];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(10.0f);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
    }];
}

#pragma mark - setters and getters
- (UITextView*)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc]init];
        _contentTextView.editable = NO;
        _contentTextView.scrollEnabled = YES;
        _contentTextView.showsVerticalScrollIndicator = NO;
        _contentTextView.showsHorizontalScrollIndicator = NO;
        //内容缩进为零（去除左右边距）
        _contentTextView.textContainer.lineFragmentPadding = 0.0f;
        //去除上下边距
        _contentTextView.textContainerInset = UIEdgeInsetsZero;
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 6.0f;       //字体的行间距
        paragraphStyle.paragraphSpacing = 6.0f; //段落间距
        NSDictionary *attributes = @{
            NSFontAttributeName: kFontPingFangSCRegular(15.0f),
                                     NSParagraphStyleAttributeName: paragraphStyle,
                                     NSForegroundColorAttributeName: JL_color_gray_101010,
                                     };
        _contentTextView.typingAttributes = attributes;
        _contentTextView.textColor = JL_color_gray_101010;
        _contentTextView.font = kFontPingFangSCRegular(15.0f);
        
        if (![NSString stringIsEmpty:_contentText]) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_contentText];
            [attr addAttributes:@{NSFontAttributeName: kFontPingFangSCRegular(15.0f), NSForegroundColorAttributeName: JL_color_gray_101010} range:NSMakeRange(0, _contentText.length)];
            [attr addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, _contentText.length)];
            _contentTextView.attributedText = attr;
        }
    }
    return _contentTextView;
}

- (void)setContentText:(NSString *)contentText {
    _contentText = contentText;
    
    if (![NSString stringIsEmpty:_contentText] && _contentTextView) {
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 6.0f;       //字体的行间距
        paragraphStyle.paragraphSpacing = 6.0f; //段落间距
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_contentText];
        [attr addAttributes:@{NSFontAttributeName: kFontPingFangSCRegular(15.0f), NSForegroundColorAttributeName: JL_color_gray_101010} range:NSMakeRange(0, _contentText.length)];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, _contentText.length)];
        _contentTextView.attributedText = attr;
    }
}

@end
