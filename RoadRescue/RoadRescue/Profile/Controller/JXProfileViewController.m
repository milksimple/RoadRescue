//
//  JXProfileViewController.m
//  RoadRescue
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXProfileViewController.h"
#import "JXProfileHeaderViewCell.h"
#import "JXIncomeViewCell.h"
#import "JXProfileViewCell.h"
#import "JXSkinViewController.h"
#import "JXAccountTool.h"
#import "JXNavigationController.h"
#import "JXLoginViewController.h"
#import "EMSDK.h"
#import "MBProgressHUD+MJ.h"

@interface JXProfileViewController ()

/** 更换主题控制器 */
@property (nonatomic, strong) JXSkinViewController *skinVC;

@end

@implementation JXProfileViewController
#pragma mark - lazy
- (JXSkinViewController *)skinVC {
    if (_skinVC == nil) {
        _skinVC = [[JXSkinViewController alloc] init];
    }
    return _skinVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人设置";
    self.tableView.backgroundColor = JXGlobalBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JXProfileViewCell class]) bundle:nil] forCellReuseIdentifier:[JXProfileViewCell reuseIdentifier]];
    
    // 设置背景
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = self.view.bounds;
    bgView.image = [JXSkinTool skinToolImageWithImageName:@"complete_bg.jpg"];
    self.tableView.backgroundView = bgView;
    // 监听修改皮肤的通知
    [JXNotificationCenter addObserver:self selector:@selector(skinChanged) name:JXChangedSkinNotification object:nil];
    
    // 监听登录成功的通知
    [JXNotificationCenter addObserver:self selector:@selector(userSuccessedLogin) name:JXSuccessLoginNotification object:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (JXMyAccount.telephone.length) { // 已登录
        return 4;
    }
    else {
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) { // 个人header
        JXProfileHeaderViewCell *headerCell = [JXProfileHeaderViewCell headerViewCell];
        headerCell.account = JXMyAccount;
        return headerCell;
    }
    else {
        JXProfileViewCell *profileCell = [tableView dequeueReusableCellWithIdentifier:[JXProfileViewCell reuseIdentifier] forIndexPath:indexPath];
        profileCell.accessoryType = UITableViewCellAccessoryNone;
        switch (indexPath.row) {
            case 1: // 换肤
                profileCell.type = JXProfileViewCellTypeChangeSkin;
                break;
                
            case 2: // 帮助
                profileCell.type = JXProfileViewCellTypeHelp;
                break;
                
            case 3: // 注销登录
                
                profileCell.type = JXProfileViewCellTypeLogout; // 注销
                break;
                
            default:
                break;
        }
        
        return profileCell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selected = NO;
    });
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 1: { // 换肤
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.skinVC];
                [self presentViewController:nav animated:YES completion:nil];
                break;
                
            }
                
            case 2: // 帮助
                
                break;
                
            case 3:  { // 注销
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
                break;
            }
                
            default:
                break;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor clearColor];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [JXProfileHeaderViewCell rowHeight];
        }
        else {
            return [JXProfileViewCell rowHeight];
        }
    }
    else {
        return [JXProfileViewCell rowHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    else {
        return 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)logout {
    __weak typeof(self) wSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在注销"];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    [[EMClient sharedClient] asyncLogout:YES success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            
            [JXAccountTool saveAccount:nil];
            [wSelf.tableView reloadData];
            
            // 发送注销成功通知
            [JXNotificationCenter postNotificationName:JXSuccessLogoutNotification object:nil];
        });
        
    } failure:^(EMError *aError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"注销成功!"];
        });
    }];
}

#pragma mark - 通知 JXChangedSkinNotification
- (void)skinChanged {
    [self.tableView reloadData];
    
    UIImageView *bgView = (UIImageView *)self.tableView.backgroundView;
    bgView.image = [JXSkinTool skinToolImageWithImageName:@"complete_bg.jpg"];
}


#pragma mark - 通知 JXSuccessLoginNotification
- (void)userSuccessedLogin {
    [self.tableView reloadData];
}

- (void)dealloc {
    [JXNotificationCenter removeObserver:self];
    
    [JXMyAccount removeObserver:self forKeyPath:@"telephone"];
}


@end
