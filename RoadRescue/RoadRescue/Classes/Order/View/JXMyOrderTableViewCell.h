//
//  JXMyOrderTableViewCell.h
//  RoadRescue
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//  我的订单cell

#import <UIKit/UIKit.h>

@protocol JXMyOrderTableViewCellDelegate <NSObject>

@optional
#warning 测试 看后期接口怎么给
- (void)myOrderTableViewCellDidClickedSeeButton;

@end

@interface JXMyOrderTableViewCell : UITableViewCell

+ (NSString *)reuseIdentifier;

@property (nonatomic, weak) id<JXMyOrderTableViewCellDelegate> delegate;

@end
