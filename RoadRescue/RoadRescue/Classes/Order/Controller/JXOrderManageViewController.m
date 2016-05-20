//
//  JXOrderManageViewController.m
//  RoadRescue
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXOrderManageViewController.h"
#import "JXMyOrderTableViewCell.h"
#import "JXOrderPopView.h"
#import "JXMyOrderCompletePopView.h"

@interface JXOrderManageViewController () <JXMyOrderTableViewCellDelegate>

@end

@implementation JXOrderManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的订单";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JXMyOrderTableViewCell class]) bundle:nil] forCellReuseIdentifier:[JXMyOrderTableViewCell reuseIdentifier]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JXMyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[JXMyOrderTableViewCell reuseIdentifier] forIndexPath:indexPath];
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 208;
}

#pragma mark - JXMyOrderTableViewCellDelegate
- (void)myOrderTableViewCellDidClickedSeeButton {
    // 判断该订单是否完成
//    JXOrderPopView *popView = [JXOrderPopView popView];
//    [popView show];
    
    JXMyOrderCompletePopView *orderCompletePopView = [JXMyOrderCompletePopView completePopView];
    [orderCompletePopView show];
}


@end
