//
//  ADsViewController.m
//  ADProject
//
//  Created by 闫康 on 16/5/13.
//  Copyright © 2016年 yankang. All rights reserved.
//

#import "ADsViewController.h"
#import "ADDetailViewController.h"

@interface ADsViewController ()
{
    NSTimer *countDownTimer;
}
@property (assign, nonatomic) NSInteger secondsCountDown; //倒计时总时长
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;

@end

@implementation ADsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _secondsCountDown = 4;
    
}

- (void)onTimer {
    
   
    if (_secondsCountDown >=1) {
        _secondsCountDown--;
        [self.skipBtn setTitle:[NSString stringWithFormat:@"%.2ld跳过",(long)_secondsCountDown] forState:UIControlStateNormal];
    }else{
        
        [countDownTimer invalidate];
        countDownTimer = nil;
        
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToADDetail) name:@"kUDEgyptAdResponse" object:nil];
    
}

- (void)pushToADDetail{
    ADDetailViewController *adDetailVC = [[ADDetailViewController alloc]init];
    [self.navigationController pushViewController:adDetailVC animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kUDEgyptAdResponse" object:nil];
}


@end
