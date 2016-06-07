//
//  JXMyOrderTableViewCell.h
//  RoadRescue
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//  我的订单cell

#import <UIKit/UIKit.h>
@class JXOrderDetail;

@protocol JXMyOrderTableViewCellDelegate <NSObject>

@optional
#warning 测试 看后期接口怎么给
- (void)myOrderTableViewCellDidClickedSeeButtonWithOrderNum:(NSString *)orderNum;

@end

@interface JXMyOrderTableViewCell : UITableViewCell

+ (NSString *)reuseIdentifier;

@property (nonatomic, weak) id<JXMyOrderTableViewCellDelegate> delegate;
/** 订单模型 */
@property (nonatomic, strong) JXOrderDetail *orderDetail;

@end
