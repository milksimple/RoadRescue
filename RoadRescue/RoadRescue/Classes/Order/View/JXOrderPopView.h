//
//  JXOrderPopView.h
//  RoadRescue
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//  点击订单查看弹出的框

#import <UIKit/UIKit.h>
@class JXOrderDetail;

@interface JXOrderPopView : UIView

+ (instancetype)popView;

/** 救援队信息模型 */
@property (nonatomic, strong) JXOrderDetail *orderDetail;

- (void)show;

- (void)dismiss;

@end
