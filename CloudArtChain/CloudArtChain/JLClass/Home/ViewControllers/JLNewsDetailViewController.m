//
//  JLNewsDetailViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/26.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLNewsDetailViewController.h"

@interface JLNewsDetailViewController ()
@property (nonatomic, strong) UITextView *contentTextView;
@end

@implementation JLNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.newsData.title;
    [self addBackItem];
    
    [self.view addSubview:self.contentTextView];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(10.0f);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
    }];
}

- (UITextView*)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc]init];
        _contentTextView.editable = NO;
        _contentTextView.selectable = NO;
        _contentTextView.scrollEnabled = YES;
        _contentTextView.showsVerticalScrollIndicator = NO;
        _contentTextView.showsHorizontalScrollIndicator = NO;
        //内容缩进为零（去除左右边距）
        _contentTextView.textContainer.lineFragmentPadding = 0.0f;
        //去除上下边距
        _contentTextView.textContainerInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 3.0f;       //字体的行间距
        paragraphStyle.paragraphSpacing = 6.0f; //段落间距
        NSDictionary *attributes = @{
            NSFontAttributeName: kFontPingFangSCRegular(15.0f),
                                     NSParagraphStyleAttributeName: paragraphStyle,
                                     NSForegroundColorAttributeName: JL_color_gray_101010,
                                     };
        _contentTextView.typingAttributes = attributes;
        _contentTextView.textColor = JL_color_gray_101010;
        _contentTextView.font = kFontPingFangSCRegular(15.0f);
//        NSData *data = [self.newsData.content dataUsingEncoding:NSUnicodeStringEncoding];
//        NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
//        NSAttributedString *html = [[NSAttributedString alloc] initWithData:data
//                                                                   options:options
//                                                        documentAttributes:nil
//                                                                     error:nil];
//        _contentTextView.attributedText = html;
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:[NSString strToAttriWithStr:self.newsData.content]];
        [attr addAttributes:@{NSFontAttributeName: kFontPingFangSCRegular(15.0f), NSForegroundColorAttributeName: JL_color_gray_101010} range:NSMakeRange(0, [NSString strToAttriWithStr:self.newsData.content].length)];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, [NSString strToAttriWithStr:self.newsData.content].length)];
        _contentTextView.attributedText = attr;
    }
    return _contentTextView;
}

@end
