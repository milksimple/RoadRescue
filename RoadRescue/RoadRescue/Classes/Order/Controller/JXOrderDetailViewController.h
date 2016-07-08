//
//  JXOrderDetailViewController.h
//  RoadRescueTeam
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JXOrderDetail;

@interface JXOrderDetailViewController : UIViewController

/** 默认orderDetail，从列表传过来的 */
@property (nonatomic, strong) JXOrderDetail *defaultOrderDetail;
@end
