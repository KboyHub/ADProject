//
//  UIImage+ImageSize.h
//  LBLaunchImageAd
//
//  Created by 闫康 on 16/6/15.
//  Copyright © 2016年 Bison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageSize)

#pragma mark - 指定宽度按比例缩放
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

@end
