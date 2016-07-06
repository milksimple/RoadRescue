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
#import "EMSDK.h"
#import "EMCDDeviceManager+Remind.h"
#import "JXHttpTool.h"
#import <MJRefresh.h>
#import "JXOrderDetail.h"
#import <MJExtension.h>
#import "JXOrderDetailViewController.h"
#import "MBProgressHUD+MJ.h"
#import "JXConst.h"
#import "JXAccountTool.h"
#import "JXLoadTipView.h"

@interface JXOrderManageViewController () <JXMyOrderTableViewCellDelegate, EMChatManagerDelegate, JXLoadTipViewDelegate>

@property (nonatomic, weak) JXMyOrderCompletePopView *orderCompletePopView;

/** 有人接单提示view */
@property (nonatomic, weak) JXOrderPopView *orderPopView;

@property (nonatomic, strong) NSMutableArray *orderDetails;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *paras;

@property (nonatomic, strong) JXAccount *account;

/** 加载提示view */
@property (nonatomic, weak) JXLoadTipView *tipView;

@end

@implementation JXOrderManageViewController
#pragma mark - lazy
- (JXMyOrderCompletePopView *)orderCompletePopView {
    if (_orderCompletePopView == nil) {
        _orderCompletePopView = [JXMyOrderCompletePopView completePopView];
    }
    return _orderCompletePopView;
}

- (JXOrderPopView *)orderPopView {
    if (_orderPopView == nil) {
        _orderPopView = [JXOrderPopView popView];
    }
    return _orderPopView;
}

- (NSMutableArray *)orderDetails {
    if (_orderDetails == nil) {
        _orderDetails = [NSMutableArray array];
    }
    return _orderDetails;
}

- (JXAccount *)account {
    if (_account == nil) {
        _account = [JXAccountTool account];
    }
    return _account;
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
    
    self.navigationItem.title = @"我的订单";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JXMyOrderTableViewCell class]) bundle:nil] forCellReuseIdentifier:[JXMyOrderTableViewCell reuseIdentifier]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupRefresh];
    [self loadNewOrder];
    
    // 监听消息
    //消息回调:EMChatManagerChatDelegate
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    // 监听新订单的通知
    [JXNotificationCenter addObserver:self selector:@selector(placedAnNewOrder:) name:JXPlaceAnOrderNotification object:nil];
    
    // 设置背景
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = self.view.bounds;
    bgView.image = [JXSkinTool skinToolImageWithImageName:@"complete_bg.jpg"];
    self.tableView.backgroundView = bgView;
    // 监听修改皮肤的通知
    [JXNotificationCenter addObserver:self selector:@selector(skinChanged) name:JXChangedSkinNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    [self.tableView.mj_footer setAutomaticallyHidden:YES];
}

/**
 *  加载新订单
 */
- (void)loadNewOrder {
    if (self.account.telephone.length == 0 || self.account.token.length == 0) {
        [self.tableView.mj_header endRefreshing];
        self.tipView.type = JXLoadTipViewTypeNoReloadButton;
        self.tipView.tipTitle = @"您还没有任何订单哦，快去试试下单吧！";
        [self.tipView showTipViewToView:self.view];
        return;
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"mobile"] = self.account.telephone;
    paras[@"token"] = self.account.token;
    paras[@"orderType"] = @1;
    paras[@"start"] = @0;
    paras[@"pageSize"] = @8;
    self.paras = paras;
    
    [JXHttpTool post:[NSString stringWithFormat:@"%@/order/list", JXServerName] params:paras success:^(id json) {
        [self.tableView.mj_header endRefreshing];
        JXLog(@"新订单请求成功 - %@", json);
        if (paras != self.paras) {
            return;
        }
        BOOL success = [json[@"success"] boolValue];
        if (success) {
            self.orderDetails = [JXOrderDetail mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [self.tableView reloadData];
            
            if (self.orderDetails.count == 0) {
                self.tipView.type = JXLoadTipViewTypeNoReloadButton;
                self.tipView.tipTitle = @"您还没有任何订单哦，快去试试下单吧！";
                [self.tipView showTipViewToView:self.view];
            }
            else {
                [self.tipView removeFromSuperview];
            }
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (self.orderDetails.count == 0) {
            self.tipView.type = JXLoadTipViewTypeHasReloadButton;
            self.tipView.tipTitle = @"啊哦，网络不给力";
            [self.tipView showTipViewToView:self.view];
        }
        else {
            [MBProgressHUD showError:@"网络连接失败"];
        }
        JXLog(@"新订单请求失败 - %@", error);
    }];
}

- (void)loadMoreOrder {
    if (self.account.telephone.length == 0 || self.account.token.length == 0) {
        return;
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"mobile"] = self.account.telephone;
    paras[@"token"] = self.account.token;
    paras[@"orderType"] = @1;
    paras[@"start"] = @(self.orderDetails.count);
    paras[@"pageSize"] = @8;
    self.paras = paras;
    
    [JXHttpTool post:[NSString stringWithFormat:@"%@/order/list", JXServerName] params:paras success:^(id json) {
        [self.tableView.mj_footer endRefreshing];
        JXLog(@"新订单请求成功 - %@", json);
        if (paras != self.paras) {
            return;
        }
        BOOL success = [json[@"success"] boolValue];
        if (success) {
            NSArray *moreOrderDetails = [JXOrderDetail mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [self.orderDetails addObjectsFromArray:moreOrderDetails];
            [self.tableView reloadData];
            
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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JXMyOrderTableViewCell rowHeight];
}

#pragma mark - JXMyOrderTableViewCellDelegate
- (void)myOrderTableViewCellDidClickedSeeButtonWithOrderNum:(NSString *)orderNum {
    JXOrderDetailViewController *orderDetailVC = [[JXOrderDetailViewController alloc] initWithOrderNum:orderNum];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#warning 测试接受消息
#pragma mark - EMChatManagerDelegate
// 收到消息的回调，带有附件类型的消息可以用 SDK 提供的下载附件方法下载（后面会讲到）
- (void)didReceiveMessages:(NSArray *)aMessages
{
    for (EMMessage *message in aMessages) {
        EMMessageBody *msgBody = message.body;
        switch (msgBody.type) {
            case EMMessageBodyTypeText:
            {
                // 收到的文字消息
                EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                NSString *txt = textBody.text;
                NSLog(@"收到的文字是 txt -- %@",txt);
                
                // 弹出有救援队接单提醒
                [self.orderCompletePopView show];
//                [self.orderPopView show];
                
                // 判断是否在后台
                if (JXApplication.applicationState == UIApplicationStateBackground) {
                    [JXApplication setApplicationIconBadgeNumber:1];
                }
                
                // 播放提示音
                EMCDDeviceManager *manager = [EMCDDeviceManager sharedInstance];
                [manager playNewMessageSound];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages{
    for (EMMessage *message in aCmdMessages) {
        EMCmdMessageBody *body = (EMCmdMessageBody *)message.body;
        JXLog(@"收到的action是 -- %@",body.action);
    }
}

#pragma mark - 通知 JXPlaceAnOrderNotification
- (void)placedAnNewOrder:(NSNotification *)noti {
    JXOrderDetail *orderDetail = noti.userInfo[JXNewOrderDetailKey];
    [self.orderDetails insertObject:orderDetail atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
}

#pragma mark - 通知 JXCancelAnOrderNotification
- (void)cancelAnOrder:(NSNotification *)noti {
    JXOrderDetail *orderDetail = noti.userInfo[JXCancelOrderDetailKey];
    NSInteger row = [self.orderDetails indexOfObject:orderDetail];
    [self.orderDetails removeObject:orderDetail];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark - 通知 JXChangedSkinNotification
- (void)skinChanged {
    [self.tableView reloadData];
    
    UIImageView *bgView = (UIImageView *)self.tableView.backgroundView;
    bgView.image = [JXSkinTool skinToolImageWithImageName:@"complete_bg.jpg"];
}

#pragma mark - JXLoadTipViewDelegate
- (void)loadTipViewDidClickedReloadButton {
    [self loadNewOrder];
}

- (void)dealloc {
    [JXNotificationCenter removeObserver:self];
}

@end
