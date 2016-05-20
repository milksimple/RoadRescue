//
//  JXMyOrderCompletePopView.h
//  RoadRescue
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 mac. All rights reserved.
//  我的订单弹出框（确认付费）

#import <UIKit/UIKit.h>

@interface JXMyOrderCompletePopView : UIView

+ (instancetype)completePopView;

- (void)show;

- (void)dismiss;

@end
