//
//  ADViewController.m
//  ADProject
//
//  Created by 闫康 on 16/5/12.
//  Copyright © 2016年 yankang. All rights reserved.
//

#import "ADViewController.h"
#import "AppDelegate.h"

@implementation ADViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

+ (void)show {
    ADViewController *ads = [[ADViewController alloc] init];
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.windowLevel = UIWindowLevelStatusBar;
    window.backgroundColor = [UIColor clearColor];
    window.rootViewController = ads;
    ads.window = window;
    [window makeKeyAndVisible];
    
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithAdsView];
    [self performSelector:@selector(goToHomePage) withObject:nil afterDelay:3];
    
}

- (void)initWithAdsView
{
    
    self.adsImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.adsImageView];
    //本地读取
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"loading.png"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isExit = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if (isExit) {
        NSLog(@"the imagePath is ==========%@", filePath);
        NSLog(@"存在");
        [self.adsImageView setImage:[UIImage imageWithContentsOfFile:filePath]];
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    self.adsImageView.userInteractionEnabled = YES;
    
    //布局。。。。
    
}

#pragma mark - Event

- (void)nextButtonClicked:(UIButton *)sender
{
    NSLog(@"已点击");
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(goToHomePage) object:nil];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"www.iqixue.com" forKey:@"kUDEgyptAdDetailShow"];
    [ud synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kUDEgyptAdResponse" object:nil];
    
    [UIView animateWithDuration:1 animations:^{
        //
        CGRect frame = CGRectZero;
        self.view.frame = frame;
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        
        //
        self.window = nil;
    }];
}
// 主页显示 || 跳过广告
- (void)goToHomePage
{
    [UIView animateWithDuration:1 animations:^{
        CGRect frame = CGRectZero;
        self.view.frame = frame;
        self.view.alpha = 0.f;
    } completion:^(BOOL finished) {
        self.window = nil;
    }];
}


@end
