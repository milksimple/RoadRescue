//
//  JXComplaintListViewController.m
//  RoadRescue
//
//  Created by mac on 16/7/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXComplaintListViewController.h"
#import "JXHttpTool.h"
#import "JXOrderDetail.h"
#import <MJExtension.h>
#import "JXLoadTipView.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "JXMyOrderTableViewCell.h"

@interface JXComplaintListViewController () <JXLoadTipViewDelegate, JXMyOrderTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *orderDetails;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *paras;

/** 加载提示view */
@property (nonatomic, weak) JXLoadTipView *tipView;

@end

@implementation JXComplaintListViewController
#pragma mark - lazy
- (NSMutableArray *)orderDetails {
    if (_orderDetails == nil) {
        _orderDetails = [NSMutableArray array];
    }
    return _orderDetails;
}

- (JXLoadTipView *)tipView {
    if (_tipView == nil) {
        _tipView = [JXLoadTipView loadTipView];
        _tipView.delegate = self;
    }
    return _tipView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"投诉表单";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JXMyOrderTableViewCell class]) bundle:nil] forCellReuseIdentifier:[JXMyOrderTableViewCell reuseIdentifier]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置背景
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = self.view.bounds;
    bgView.image = [JXSkinTool skinToolImageWithImageName:@"complete_bg.jpg"];
    self.tableView.backgroundView = bgView;
    
    [self setupRefresh];
}

- (void)setupRefresh {
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewOrder)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    header.automaticallyChangeAlpha = YES;
    
    // Set the ordinary state of animated images
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i = 1; i < 13; i ++) {
        [idleImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d", i]]];
    }
    [header setImages:idleImages forState:MJRefreshStateIdle];
    
    // Set the pulling state of animated images（Enter the status of refreshing as soon as loosen）
    NSMutableArray *pullingImages = [NSMutableArray array];
    for (int i = 1; i < 13; i ++) {
        [pullingImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d", i]]];
    }
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    
    // Set the refreshing state of animated images
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i < 13; i ++) {
        [refreshingImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d", i]]];
    }
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreOrder)];
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
    [self.tableView.mj_footer setAutomaticallyHidden:YES];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadNewOrder {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"mobile"] = JXMyAccount.telephone;
    paras[@"token"] = JXMyAccount.token;
    paras[@"start"] = @0;
    paras[@"pageSize"] = @3;
    JXLog(@"投诉表单 - paras = %@", paras);
    self.paras = paras;
    
    __weak typeof(self) wSelf = self;
    [JXHttpTool post:[NSString stringWithFormat:@"%@/complain/list4User", JXServerName] params:paras success:^(id json) {
        [wSelf.tableView.mj_header endRefreshing];
        if (paras != wSelf.paras) {
            return;
        }
        
        JXLog(@"投诉表单 - json = %@", json);
        
        BOOL success = [json[@"success"] boolValue];
        if (success) {
            // 1.刷新列表
            wSelf.orderDetails = [JXOrderDetail mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [wSelf.tableView reloadData];
            
            // 2.显示提示view
            if (wSelf.orderDetails.count == 0) {
                wSelf.tipView.type = JXLoadTipViewTypeNoReloadButton;
                wSelf.tipView.tipTitle = @"您还没有任何订单哦，\n快去试试下单吧！";
                [wSelf.tipView showTipViewToView:wSelf.view];
            }
            else {
                [wSelf.tipView removeFromSuperview];
            }
            
        }
    } failure:^(NSError *error) {
        [wSelf.tableView.mj_header endRefreshing];
        if (wSelf.orderDetails.count == 0) {
            wSelf.tipView.type = JXLoadTipViewTypeHasReloadButton;
            wSelf.tipView.tipTitle = @"啊哦，网络不给力";
            [wSelf.tipView showTipViewToView:wSelf.view];
        }
        else {
            [MBProgressHUD showError:@"网络连接失败"];
        }
        JXLog(@"新订单请求失败 - %@", error);
    }];
}

- (void)loadMoreOrder {
    if (JXMyAccount.telephone.length == 0 || JXMyAccount.token.length == 0) {
        return;
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"mobile"] = JXMyAccount.telephone;
    paras[@"token"] = JXMyAccount.token;
    paras[@"orderType"] = @1;
    paras[@"start"] = @(self.orderDetails.count);
    paras[@"pageSize"] = @3;
    self.paras = paras;
    
    [JXHttpTool post:[NSString stringWithFormat:@"%@/complain/list4User", JXServerName] params:paras success:^(id json) {
        JXLog(@"新订单请求成功 - %@", json);
        [self.tableView.mj_footer endRefreshing];
        
        if (paras != self.paras) {
            return;
        }
        
        BOOL success = [json[@"success"] boolValue];
        if (success) {
            NSArray *moreOrderDetails = [JXOrderDetail mj_objectArrayWithKeyValuesArray:json[@"data"]];
            if (moreOrderDetails.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [self.orderDetails addObjectsFromArray:moreOrderDetails];
                [self.tableView reloadData];
            }
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:@"网络连接失败"];
        JXLog(@"新订单请求失败 - %@", error);
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orderDetails.count > 0) {
        [self.tipView removeFromSuperview];
    }
    
    return self.orderDetails.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JXMyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[JXMyOrderTableViewCell reuseIdentifier] forIndexPath:indexPath];
    cell.delegate = self;
    cell.orderDetail = self.orderDetails[indexPath.row];
    cell.indexPath = indexPath;
    cell.hideSeeButton = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(complaintListViewControllerDidFinishSelectOrderDetail:)]) {
        JXOrderDetail *orderDetail = self.orderDetails[indexPath.row];
        [self.delegate complaintListViewControllerDidFinishSelectOrderDetail:orderDetail];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JXMyOrderTableViewCell rowHeight];
}


#pragma mark - JXLoadTipViewDelegate
- (void)loadTipViewDidClickedReloadButton {
    [self.tableView.mj_header beginRefreshing];
}

@end
