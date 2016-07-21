//
//  JXComplaintListViewController.h
//  RoadRescue
//
//  Created by mac on 16/7/20.
//  Copyright © 2016年 mac. All rights reserved.
//  投诉表单

#import <UIKit/UIKit.h>
@class JXOrderDetail;

@protocol JXComplaintListViewControllerDelegate <NSObject>

@optional
- (void)complaintListViewControllerDidFinishSelectOrderDetail:(JXOrderDetail *)orderDetail;

@end

@interface JXComplaintListViewController : UITableViewController

@property (nonatomic, weak) id<JXComplaintListViewControllerDelegate> delegate;

@end
