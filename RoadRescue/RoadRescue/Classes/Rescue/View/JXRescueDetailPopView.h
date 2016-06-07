//
//  JXRescueDetailPopView.h
//  RoadRescue
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 mac. All rights reserved.
//  救援明细弹出view

#import <UIKit/UIKit.h>
@class JXOrderDetail;

@protocol JXRescueDetailPopViewDelegate <NSObject>

@optional
- (void)rescueDetailPopViewDidClickedConfirmButton;

@end

@interface JXRescueDetailPopView : UIView

+ (instancetype)popView;

- (void)show;

- (void)dismiss;
/** 订单详情 */
@property (nonatomic, strong) JXOrderDetail *orderDetail;

@property (nonatomic, weak) id<JXRescueDetailPopViewDelegate> delegate;

@end
