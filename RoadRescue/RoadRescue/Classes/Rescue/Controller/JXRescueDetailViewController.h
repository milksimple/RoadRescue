//
//  JXRescueDetailViewController.h
//  RoadRescue
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXOrderDetail.h"

@interface JXRescueDetailViewController : UIViewController

- (instancetype)initWithOrderDetail:(JXOrderDetail *)orderDetail;

@property (nonatomic, strong) JXOrderDetail *orderDetail;

@end
