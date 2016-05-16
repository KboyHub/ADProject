//
//  ADViewController.m
//  ADProject
//
//  Created by 闫康 on 16/5/12.
//  Copyright © 2016年 yankang. All rights reserved.
//

#import "ADViewController.h"
#import "AppDelegate.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width

@interface ADViewController ()

@property (strong, nonatomic) UIButton *timeBtn;
@property (strong, nonatomic) dispatch_source_t timer;

@end

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
    [self.view setBackgroundColor:[UIColor redColor]];
    [self initWithAdsView];
  //  [self performSelector:@selector(goToHomePage) withObject:nil afterDelay:3];//2秒消失
    
}

- (void)initWithAdsView
{
    
    self.adsImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.timeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.timeBtn.frame = CGRectMake(kScreenW-40, 25, 30, 30);
    self.timeBtn.titleLabel.font=[UIFont systemFontOfSize:21.0];
    self.timeBtn.tintColor = [UIColor whiteColor];
    [self.timeBtn setBackgroundImage:[UIImage imageNamed:@"倒计时bg"] forState:UIControlStateNormal];
    [self.view addSubview:self.adsImageView];
    [self.view addSubview:self.timeBtn];
    //本地读取
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"loading.png"]];
    
    [self.adsImageView setImage:[UIImage imageWithContentsOfFile:filePath]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextADDetailTap:)];
    [self.adsImageView addGestureRecognizer:tap];
    [self startTime];
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.adsImageView.userInteractionEnabled = YES;
    
    //布局。。。。
    
}

#pragma mark - Event

- (void)nextADDetailTap:(UITapGestureRecognizer *)tap
{
    NSLog(@"已点击");
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(goToHomePage) object:nil];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"http://www.baidu.com" forKey:@"kUDEgyptAdDetailShow"];//存储广告链接
    [ud synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kUDEgyptAdResponse" object:nil];//创建通知，监听广告点击
    
    [UIView animateWithDuration:0.5 animations:^{
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
    [self endTime];
    [UIView animateWithDuration:1 animations:^{
        CGRect frame = CGRectZero;
        self.view.frame = frame;
        self.view.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        self.window = nil;
    }];
}

-(void)startTime{
    
    __block int timeout=3; //倒计时时间
    [self.timeBtn setTitle:@"03" forState:UIControlStateNormal];
    NSTimeInterval period = 1.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 2*period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
               
                [self.timeBtn setTitle:@"00" forState:UIControlStateNormal];
                [self goToHomePage];
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout ;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.timeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.timeBtn.userInteractionEnabled = NO;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}
-(void)endTime
{
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        dispatch_source_cancel(_timer);
        dispatch_async(dispatch_get_main_queue(), ^{
            //设置界面的按钮显示 根据自己需求设置
            [self.timeBtn setTitle:@"00" forState:UIControlStateNormal];
            self.timeBtn.userInteractionEnabled = YES;
        });
    });
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
