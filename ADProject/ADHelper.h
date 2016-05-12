//
//  ADHelper.h
//  ADProject
//
//  Created by 闫康 on 16/5/12.
//  Copyright © 2016年 yankang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ADHelper : NSObject

- (void)adInfoUrl:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(NSDictionary *))success;

//获取广告信息
- (void)getTheAdInformation;

@end
