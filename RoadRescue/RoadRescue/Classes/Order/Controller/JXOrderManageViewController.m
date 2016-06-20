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

@interface JXOrderManageViewController () <JXMyOrderTableViewCellDelegate, EMChatManagerDelegate>

@property (nonatomic, strong) JXMyOrderCompletePopView *orderCompletePopView;

@property (nonatomic, strong) NSMutableArray *orderDetails;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *paras;

@property (nonatomic, strong) JXAccount *account;

@end

@implementation JXOrderManageViewController
#pragma mark - lazy
- (JXMyOrderCompletePopView *)orderCompletePopView {
    if (_orderCompletePopView == nil) {
        _orderCompletePopView = [JXMyOrderCompletePopView completePopView];
    }
    return _orderCompletePopView;
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
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewOrder)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreOrder)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];
}

/**
 *  加载新订单
 */
- (void)loadNewOrder {
    if (self.account.telephone.length == 0 || self.account.token.length == 0) {
        return;
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
#warning 测试
    paras[@"mobile"] = self.account.telephone;
    paras[@"token"] = self.account.token;
    paras[@"mobile"] = @"13888650223";
    paras[@"token"] = @"7F9D459A";
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
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络连接失败"];
        JXLog(@"新订单请求失败 - %@", error);
    }];
}

- (void)loadMoreOrder {
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderDetails.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JXMyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[JXMyOrderTableViewCell reuseIdentifier] forIndexPath:indexPath];
    cell.delegate = self;
    cell.orderDetail = self.orderDetails[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 208;
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

#pragma mark - 通知 JXPlaceAnOrderNotification
- (void)placedAnNewOrder:(NSNotification *)noti {
    JXOrderDetail *orderDetail = noti.userInfo[JXNewOrderDetailKey];
    [self.orderDetails insertObject:orderDetail atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
}

#pragma mark - 通知 JXChangedSkinNotification
- (void)skinChanged {
    [self.tableView reloadData];
    
    UIImageView *bgView = (UIImageView *)self.tableView.backgroundView;
    bgView.image = [JXSkinTool skinToolImageWithImageName:@"complete_bg.jpg"];
}

- (void)dealloc {
    [JXNotificationCenter removeObserver:self];
}

@end
