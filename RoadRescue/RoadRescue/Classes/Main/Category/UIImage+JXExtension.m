//
//  UIImage+JXExtension.m
//  RoadRescue
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "UIImage+JXExtension.h"

@implementation UIImage (JXExtension)

- (UIImage *)circleImage {
    // 开启透明上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 画入一个圆形
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    // 裁剪
    CGContextClip(ctx);
    // 将图片画上去
    [self drawInRect:rect];
    // 从当前上下文获得图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end
