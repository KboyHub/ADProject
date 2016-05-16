//
//  ADDetailViewController.m
//  shiandianping2.0
//
//  Created by 闫康 on 16/5/16.
//  Copyright © 2016年 程宏愿. All rights reserved.
//

#import "ADDetailViewController.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
@interface ADDetailViewController ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView *bannerWebView;


@end

@implementation ADDetailViewController

- (void)viewDidLoad {
    //创建HTML图文详情视图webviewd
    self.title = @"广告详情";
    
     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.bannerUrlStr = [ud objectForKey:@"kUDEgyptAdDetailShow"];

    self.bannerWebView = [[UIWebView alloc]init];
    self.bannerWebView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    self.bannerWebView.delegate = self;
    self.bannerWebView.scrollView.bounces = NO;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.bannerUrlStr]];
    [self.bannerWebView loadRequest:request];
    [self.view addSubview:self.bannerWebView];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
//    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    self.hud.mode = MBProgressHUDModeIndeterminate;
//    self.hud.labelText = @"正在加载中...";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
