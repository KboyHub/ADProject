//
//  DownLoadADImageInfo.m
//  ADProject
//
//  Created by 闫康 on 16/5/12.
//  Copyright © 2016年 yankang. All rights reserved.
//

#import "DownLoadADImageInfo.h"
#import "AFNetworking.h"

@implementation DownLoadADImageInfo

//下载新广告页
- (void)downloadAdImageWhenPossible
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *adDownloadId = [ud objectForKey:@"kUDEgyptAdDownload"];
    NSString *adCatagoryId = [ud objectForKey:@"kUDEgyptAdCatagoryId"];
    NSLog(@"%@  %@",adDownloadId,adCatagoryId);
    if (![adDownloadId isEqualToString:adCatagoryId]&& adCatagoryId.length > 0) {
        [ud setObject:adCatagoryId forKey:@"kUDEgyptAdDownload"];
        
        [ud synchronize];
        NSString *urlString = [ud objectForKey:@"kUDEgyptAdImageUrl"];
        AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
        mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
        [mgr GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSData *data = responseObject;
            //删除原图片
            [self deleteCacheAdImageData];
            //存储新图片
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [UIImage imageWithData:data];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"loading.png"]];   // 保存文件的名称
                //    BOOL result = [UIImagePNGRepresentation() writeToFile: filePath    atomically:YES]; // 保存成功会返回YES
                NSLog(@"paths:%@    %@",paths,filePath);
                [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
                
            });
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //
        }];
    }else {
        NSLog(@"不需要下载广告图片");
    }
}
//删除本地广告页原数据
- (void)deleteCacheAdImageData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"loading.png"]];
    BOOL isDir = FALSE;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
    if (result) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

@end
