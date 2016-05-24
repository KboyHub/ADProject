//
//  ADHelper.m
//  ADProject
//
//  Created by 闫康 on 16/5/12.
//  Copyright © 2016年 yankang. All rights reserved.
//

#import "ADHelper.h"
#import "DownLoadADImageInfo.h"
#import "ADViewController.h"

#define ADUrlString @"http://192.168.0.2:8011/api/sourceIOSDianPing/v1.0/StartPageInfo"//广告接口

@implementation ADHelper

- (void)getTheAdInformation {
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *lastVersion=[userDefaults objectForKey:@"CFBundleVersion"];
    
    NSDictionary *infoDict=[NSBundle mainBundle].infoDictionary;
    //    NSLog(@"%@",infoDict);
    NSString*currentVersion=infoDict[@"CFBundleVersion"];
    
    if ([lastVersion isEqualToString: currentVersion]) {
        //本地读取
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"loading.png"]];
        BOOL isDir = FALSE;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isExit = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
        if (isExit) {
            NSLog(@"存在");
            [ADViewController show];  //广告页面展示
        }
    }
    else{
        //第一次进入应用
        [userDefaults setObject:currentVersion forKey:@"CFBundleVersion"];
        [userDefaults synchronize];
    }
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd";
    NSString *timeStr = [formater stringFromDate:[NSDate date]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"time"]=timeStr;
    [self get:dict];
}

- (void)get:(NSDictionary *)timeStr {
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"GET" URLString:ADUrlString parameters:timeStr error:nil];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:requestOperation.responseObject
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if ([dic[@"Status"] integerValue]== 1) {
        //
        NSString *imageUrl = dic[@"Data"];
        NSString *downId = @"1";//下载获取Id
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:downId forKey:@"kUDEgyptAdDownload"];
        [ud setObject:@"0" forKey:@"kUDEgyptAdCatagoryId"];
        [ud setObject:imageUrl forKey:@"kUDEgyptAdImageUrl"];
        [ud synchronize];
        // 下载新广告图
        DownLoadADImageInfo *downInfo = [[DownLoadADImageInfo alloc]init];
        [downInfo downloadAdImageWhenPossible];
    }
}

@end
