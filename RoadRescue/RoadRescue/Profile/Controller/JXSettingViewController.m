//
//  JXSettingViewController.m
//  RoadRescue
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXSettingViewController.h"
#import "JXLogoutCell.h"
#import "JXAccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "EMSDK.h"

@interface JXSettingViewController () <JXLogoutCellDelegate>

@end

@implementation JXSettingViewController
- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBg];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupBg {
    // 设置背景
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = self.view.bounds;
    bgView.image = [JXSkinTool skinToolImageWithImageName:@"complete_bg.jpg"];
    self.tableView.backgroundView = bgView;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (JXMyAccount.telephone.length) { // 已登录
        return 1;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JXLogoutCell *cell = [JXLogoutCell logoutCell];
    
    cell.delegate = self;
    
    return cell;
}

#pragma mark - JXLogoutCellDelegate

- (void)logoutCellDidClickedLogoutButton {
    
    __weak typeof(self) wSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要注销吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 注销
        [wSelf logout];

    }];
    [alertVC addAction:cancel];
    [alertVC addAction:confirm];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)logout {
    __weak typeof(self) wSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在注销"];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    [[EMClient sharedClient] asyncLogout:YES success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"注销成功！"];
            
            [JXAccountTool saveAccount:nil];
            
            // 发送注销成功通知
            [JXNotificationCenter postNotificationName:JXSuccessLogoutNotification object:nil];
            
            [wSelf.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(EMError *aError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"注销失败"];
        });
    }];
}


@end
