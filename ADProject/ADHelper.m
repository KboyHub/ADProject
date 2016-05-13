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

#define ADUrlString @"http://img4.duitang.com/uploads/item/201409/23/20140923093648_JaPhH.jpeg"//广告接口

@implementation ADHelper

- (void)getTheAdInformation {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd";
    NSString *timeStr = [formater stringFromDate:[NSDate date]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"time"]=timeStr;
//    [self adInfoUrl:ADUrlString params:dic success:^(NSDictionary *responseObject) {
//        NSDictionary *dict = responseObject;
    
//        NSString *cataId = [dic objectForKey:@"id"];
//        NSString *mainTitle = [dic objectForKey:@"name"];
//        NSString *infoTitle = [dic objectForKey:@"description"];
//        NSString *imageUrl = [dict objectForKey:@"url"];
        NSString *imageUrl = ADUrlString;
        NSString *downId = @"1";//下载获取Id
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:downId forKey:@"kUDEgyptAdDownload"];
//        [ud setObject:mainTitle forKey:@"kUDEgyptAdMainTitle"];
//        [ud setObject:infoTitle forKey:@"kUDEgyptAdInfoTitle"];
        [ud setObject:imageUrl forKey:@"kUDEgyptAdImageUrl"];
        
        [ud synchronize];
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        NSString *lastVersion=[userDefaults objectForKey:@"CFBundleVersion"];
        
        NSDictionary *infoDict=[NSBundle mainBundle].infoDictionary;
        //    NSLog(@"%@",infoDict);
        NSString*currentVersion=infoDict[@"CFBundleVersion"];
        
        if ([lastVersion isEqualToString: currentVersion]) {
            [ADViewController show];  //广告页面展示
        }
        else{
            //第一次进入应用
            [userDefaults setObject:currentVersion forKey:@"CFBundleVersion"];
            [userDefaults synchronize];
        }

//        //ad 为是否第二次启动应用
//        NSString *ad = [ud objectForKey:@"kUDEgyptAdPageShow"];
//        if (ad.length > 0) {
//            //显示广告这里加入图片存在的判断？
//            //如果cataId传空，则广告不显示
//            if (cataId.length > 3) {
//                [ADViewController show];  //广告页面展示
//            }
//        }
        
        // 下载新广告图
        DownLoadADImageInfo *downInfo = [[DownLoadADImageInfo alloc]init];
        [downInfo downloadAdImageWhenPossible];
//    }];
}

- (void)adInfoUrl:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(NSDictionary *))success
{
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:urlString parameters:newParams error:nil];
    
    /* 最终继承自 NSOperation，也就是利用 NSOperation 来做的同步请求 */
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    
    [requestOperation setResponseSerializer:responseSerializer];
    
    [requestOperation start];
    
    [requestOperation waitUntilFinished];
    
    /* 请求结果 */
    NSDictionary *result = (NSDictionary *)[requestOperation responseObject];
    
    if (result != nil) {
        
        success(result);
    }else{
        NSLog(@"%@",result);
    }
}

@end
