//
//  JLProtocolViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/5/17.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLProtocolViewController.h"

@interface JLProtocolViewController ()
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) Model_members_user_agreement_Data *protocolData;
@end

@implementation JLProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"《萌易》测试版服务及隐私条款";
    [self addBackItem];
    // 请求隐私协议
    [self requestProtocol];
}

- (void)requestProtocol {
    WS(weakSelf)
    Model_members_user_agreement_Req *request = [[Model_members_user_agreement_Req alloc] init];
    Model_members_user_agreement_Rsp *response = [[Model_members_user_agreement_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            weakSelf.protocolData = response.body;
            [weakSelf createSubViews];
        } else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

- (void)createSubViews {
    [self.view addSubview:self.contentTextView];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(9.0f);
        make.right.mas_equalTo(-16.0f);
        make.top.mas_equalTo(12.0f);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
    }];
}

- (UITextView*)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc]init];
        _contentTextView.layer.cornerRadius = 8.0f;
        _contentTextView.editable = NO;
        _contentTextView.selectable = NO;
        _contentTextView.scrollEnabled = YES;
        _contentTextView.showsVerticalScrollIndicator = NO;
        _contentTextView.showsHorizontalScrollIndicator = NO;
        //内容缩进为零（去除左右边距）
        _contentTextView.textContainer.lineFragmentPadding = 0.0f;
        //去除上下边距
        _contentTextView.textContainerInset = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f);
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 3.0f;       //字体的行间距
        paragraphStyle.paragraphSpacing = 6.0f; //段落间距
        NSDictionary *attributes = @{
            NSFontAttributeName: kFontPingFangSCRegular(14.0f),
                                     NSParagraphStyleAttributeName: paragraphStyle,
                                     NSForegroundColorAttributeName: JL_color_black_101220,
                                     };
        _contentTextView.typingAttributes = attributes;
        _contentTextView.textColor = JL_color_black_101220;
        _contentTextView.font = kFontPingFangSCRegular(14.0f);
//        NSData *data = [self.protocolData.user_agreement dataUsingEncoding:NSUnicodeStringEncoding];
//        NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
//        NSAttributedString *html = [[NSAttributedString alloc] initWithData:data
//                                                                   options:options
//                                                        documentAttributes:nil
//                                                                     error:nil];
//        _contentTextView.attributedText = html;
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:[NSString strToAttriWithStr:self.protocolData.user_agreement]];
        [attr addAttributes:@{NSFontAttributeName: kFontPingFangSCRegular(14.0f), NSForegroundColorAttributeName: JL_color_black_101220} range:NSMakeRange(0, [NSString strToAttriWithStr:self.protocolData.user_agreement].length)];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, [NSString strToAttriWithStr:self.protocolData.user_agreement].length)];
        _contentTextView.attributedText = attr;
    }
    return _contentTextView;
}

@end
