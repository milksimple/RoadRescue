//
//  JXMyOrderCompletePopView.h
//  RoadRescue
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 mac. All rights reserved.
//  我的订单弹出框（确认付费）

#import <UIKit/UIKit.h>
@class JXOrderDetail;

@protocol JXMyOrderCompletePopViewDelegate <NSObject>

@optional
/** 订单成功完成 */
- (void)myOrderCompletePopViewSuccessCompleteOrder;

@end

@interface JXMyOrderCompletePopView : UIView

+ (instancetype)completePopView;

/** 救援队模型 */
@property (nonatomic, strong) JXOrderDetail *orderDetail;

- (void)show;

- (void)dismiss;

@property (nonatomic, weak) id<JXMyOrderCompletePopViewDelegate> delegate;

@end
