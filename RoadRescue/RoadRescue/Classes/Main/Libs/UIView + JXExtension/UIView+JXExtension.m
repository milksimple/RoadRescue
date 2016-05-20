//
//  UIView+JXExtension.m
//  新浪微博
//
//  Created by 张盼盼 on 15/8/25.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "UIView+JXExtension.h"

@implementation UIView (JXExtension)

- (void)setJx_x:(CGFloat)jx_x
{
    CGRect frame = self.frame;
    frame.origin.x = jx_x;
    self.frame = frame;
}

- (void)setJx_y:(CGFloat)jx_y
{
    CGRect frame = self.frame;
    frame.origin.y = jx_y;
    self.frame = frame;
}

- (CGFloat)jx_x
{
    return self.frame.origin.x;
}

- (CGFloat)jx_y
{
    return self.frame.origin.y;
}

- (void)setJx_centerX:(CGFloat)jx_centerX
{
    CGPoint center = self.center;
    center.x = jx_centerX;
    self.center = center;
}

- (CGFloat)jx_centerX
{
    return self.center.x;
}

- (void)setJx_centerY:(CGFloat)jx_centerY
{
    CGPoint center = self.center;
    center.y = jx_centerY;
    self.center = center;
}

- (CGFloat)jx_centerY
{
    return self.center.y;
}

- (void)setJx_width:(CGFloat)jx_width
{
    CGRect frame = self.frame;
    frame.size.width = jx_width;
    self.frame = frame;
}

- (void)setJx_height:(CGFloat)jx_height
{
    CGRect frame = self.frame;
    frame.size.height = jx_height;
    self.frame = frame;
}

- (CGFloat)jx_height
{
    return self.frame.size.height;
}

- (CGFloat)jx_width
{
    return self.frame.size.width;
}

- (void)setJx_size:(CGSize)jx_size
{
    CGRect frame = self.frame;
    frame.size = jx_size;
    self.frame = frame;
}

- (CGSize)jx_size
{
    return self.frame.size;
}

- (void)setJx_origin:(CGPoint)jx_origin
{
    CGRect frame = self.frame;
    frame.origin = jx_origin;
    self.frame = frame;
}

- (CGPoint)jx_origin
{
    return self.frame.origin;
}

@end
