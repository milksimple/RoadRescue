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
- (void)myOrderTableViewCellDidClickedSeeButtonWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface JXMyOrderTableViewCell : UITableViewCell

+ (NSString *)reuseIdentifier;

@property (nonatomic, weak) id<JXMyOrderTableViewCellDelegate> delegate;
/** 订单模型 */
@property (nonatomic, strong) JXOrderDetail *orderDetail;

/** 在列表中的位置 */
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (CGFloat)rowHeight;

@end
