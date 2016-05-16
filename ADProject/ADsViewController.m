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

@end

@implementation ADsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToADDetail) name:@"kUDEgyptAdResponse" object:nil];
    
}

- (void)pushToADDetail{
    ADDetailViewController *adDetailVC = [[ADDetailViewController alloc]init];
    [self.navigationController pushViewController:adDetailVC animated:YES];
}

@end
