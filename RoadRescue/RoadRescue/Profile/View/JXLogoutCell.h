//
//  JXLogoutCell.h
//  RoadRescue
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXLogoutCellDelegate <NSObject>

@optional
- (void)logoutCellDidClickedLogoutButton;

@end

@interface JXLogoutCell : UITableViewCell

+ (instancetype)logoutCell;

+ (NSString *)reuseIdentifier;

+ (CGFloat)rowHeight;

@property (nonatomic, weak) id<JXLogoutCellDelegate> delegate;

@end
