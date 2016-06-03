//
//  JXOrderDetailViewController.h
//  RoadRescueTeam
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXOrderDetailViewController : UIViewController

- (instancetype)initWithOrderNum:(NSString *)orderNum;

/** 该订单Id */
@property (nonatomic, copy) NSString *orderNum;

@end
