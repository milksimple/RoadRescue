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

/** 加载提示view */
@property (nonatomic, weak) JXLoadTipView *tipView;

/** 标识：是否接收到聊天消息，代表是否有人接单 或者 是否请求付款 */
@property (nonatomic, assign) BOOL receiveIM;

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
    
    // 监听消息
    //消息回调:EMChatManagerChatDelegate
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    [self setupNotification];

    // 设置背景
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = self.view.bounds;
    bgView.image = [JXSkinTool skinToolImageWithImageName:@"complete_bg.jpg"];
    self.tableView.backgroundView = bgView;
    
}

- (void)setupNotification {
    // 监听新订单的通知
    [JXNotificationCenter addObserver:self selector:@selector(placedAnNewOrder:) name:JXPlaceAnOrderNotification object:nil];
    // 监听取消订单的通知
    [JXNotificationCenter addObserver:self selector:@selector(cancelAnOrder:) name:JXCancelAnOrderNotification object:nil];
    // 监听修改皮肤的通知
    [JXNotificationCenter addObserver:self selector:@selector(skinChanged) name:JXChangedSkinNotification object:nil];
    // 监听成功完成订单的通知
    [JXNotificationCenter addObserver:self selector:@selector(orderSuccessFinished:) name:JXOrderSuccessFinishedNotification object:nil];
    // 监听注销成功的通知
    [JXNotificationCenter addObserver:self selector:@selector(userSuccessedLogout) name:JXSuccessLogoutNotification object:nil];
    // 监听登录成功的通知
    [JXNotificationCenter addObserver:self selector:@selector(userSuccessedLogin) name:JXSuccessLoginNotification object:nil];
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
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
    [self.tableView.mj_footer setAutomaticallyHidden:YES];
    
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  加载新订单
 */
- (void)loadNewOrder {
    if (JXMyAccount.telephone.length == 0 || JXMyAccount.token.length == 0) {
        [self.tableView.mj_header endRefreshing];
        self.orderDetails = nil;
        [self.tableView reloadData];
        self.tipView.type = JXLoadTipViewTypeNoReloadButton;
        self.tipView.tipTitle = @"您还没有任何订单哦，\n快去试试下单吧！";
        [self.tipView showTipViewToView:self.view];
        return;
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"mobile"] = JXMyAccount.telephone;
    paras[@"token"] = JXMyAccount.token;
    paras[@"orderType"] = @1;
    paras[@"start"] = @0;
    paras[@"pageSize"] = @3;
    self.paras = paras;
    
    __weak typeof(self) wSelf = self;
    [JXHttpTool post:[NSString stringWithFormat:@"%@/order/list", JXServerName] params:paras success:^(id json) {
        [wSelf.tableView.mj_header endRefreshing];
        if (paras != wSelf.paras) {
            return;
        }
        
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
                
                if (wSelf.receiveIM) { // 接收到IM消息才进行此步骤
                    // 3.获得最新订单的状态，以显示不同的popView
                    JXOrderDetail *latestOrderDetail = wSelf.orderDetails[0];
                    // <-1-订单已取消,  0-已下单,1-已接单,2-完成等待付款,9-完成>
                    if (latestOrderDetail.orderStatus == 1) { // 已接单
                        wSelf.orderPopView.orderDetail = latestOrderDetail;
                        [wSelf.orderPopView show];
                    }
                    else if (latestOrderDetail.orderStatus == 2) { // 完成等待付款
                        wSelf.orderCompletePopView.orderDetail = latestOrderDetail;
                        [wSelf.orderPopView dismiss];
                        [wSelf.orderCompletePopView show];
                    }
                    
                    wSelf.receiveIM = NO;
                }
                
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
    
    [JXHttpTool post:[NSString stringWithFormat:@"%@/order/list", JXServerName] params:paras success:^(id json) {
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JXOrderDetail *orderDetail = self.orderDetails[indexPath.row];
    JXOrderDetailViewController *orderDetailVC = [[JXOrderDetailViewController alloc] init];
    orderDetailVC.defaultOrderDetail = orderDetail;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JXMyOrderTableViewCell rowHeight];
}

#pragma mark - JXMyOrderTableViewCellDelegate
- (void)myOrderTableViewCellDidClickedSeeButtonWithIndexPath:(NSIndexPath *)indexPath {
    JXOrderDetail *orderDetail = self.orderDetails[indexPath.row];
    JXOrderDetailViewController *orderDetailVC = [[JXOrderDetailViewController alloc] init];
    orderDetailVC.defaultOrderDetail = orderDetail;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

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
                
                // 判断是否在后台
                if (JXApplication.applicationState == UIApplicationStateBackground) {
                    [JXApplication setApplicationIconBadgeNumber:1];
                }
                
                // 播放提示音
                EMCDDeviceManager *manager = [EMCDDeviceManager sharedInstance];
                [manager playNewMessageSound];
                
                if ([txt isEqualToString:@"救援队已接单"] || [txt isEqualToString:@"救援队申请付款"]) {
                    // 接受到IM标识为YES
                    self.receiveIM = YES;
                    // 发送请求刷新订单列表，以获得救援队的信息
                    [self loadNewOrder];
                }
                
            }
                break;
                
            default:
                break;
        }
    }
}

//- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages{
//    for (EMMessage *message in aCmdMessages) {
//        EMCmdMessageBody *body = (EMCmdMessageBody *)message.body;
//        JXLog(@"收到的action是 -- %@",body.action);
//        [self.orderPopView show];
//    }
//}

#pragma mark - 通知 JXPlaceAnOrderNotification
- (void)placedAnNewOrder:(NSNotification *)noti {
    JXOrderDetail *orderDetail = noti.userInfo[JXOrderDetailKey];
    [self.orderDetails insertObject:orderDetail atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
}

#pragma mark - 通知 JXCancelAnOrderNotification
- (void)cancelAnOrder:(NSNotification *)noti {
    JXLog(@"%@", noti.userInfo);
    JXOrderDetail *orderDetail = noti.userInfo[JXCancelOrderDetailKey];
    
    for (JXOrderDetail *selfOrderDetail in self.orderDetails) {
        if ([selfOrderDetail.orderNum isEqualToString:orderDetail.orderNum]) {
            selfOrderDetail.orderStatus = -1;
            [self.tableView reloadData];
        }
    }
}

#pragma mark - 通知 JXChangedSkinNotification
- (void)skinChanged {
    [self.tableView reloadData];
    
    UIImageView *bgView = (UIImageView *)self.tableView.backgroundView;
    bgView.image = [JXSkinTool skinToolImageWithImageName:@"complete_bg.jpg"];
}

#pragma mark - JXLoadTipViewDelegate
- (void)loadTipViewDidClickedReloadButton {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - JXOrderSuccessFinishedNotification
- (void)orderSuccessFinished:(NSNotification *)noti {
    JXOrderDetail *orderDetail = noti.userInfo[JXOrderDetailKey];
    for (JXOrderDetail *selfOrderDetail in self.orderDetails) {
        if ([selfOrderDetail.orderNum isEqualToString:orderDetail.orderNum]) {
            selfOrderDetail.orderStatus = 9;
            // 由于后台字段把时间和救援队名称设计为一个字段，此处非常坑
            selfOrderDetail.title = nil;
            [self.tableView reloadData];
            
            return;
        }
    }
}

#pragma mark - 登录注销成功的通知
- (void)userSuccessedLogin {
    [self.tableView.mj_header beginRefreshing];
}

- (void)userSuccessedLogout {
    [self.tableView.mj_header beginRefreshing];
}

- (void)dealloc {
    [JXNotificationCenter removeObserver:self];
}

@end
