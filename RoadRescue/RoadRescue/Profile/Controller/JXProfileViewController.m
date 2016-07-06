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

@interface JXProfileViewController ()

/** 账号信息 */
@property (nonatomic, strong) JXAccount *account;

/** 更换主题控制器 */
@property (nonatomic, strong) JXSkinViewController *skinVC;

@end

@implementation JXProfileViewController
#pragma mark - lazy
- (JXAccount *)account {
    if (_account == nil) {
        _account = [JXAccountTool account];
    }
    return _account;
}

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
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { // 个人header
            JXProfileHeaderViewCell *headerCell = [JXProfileHeaderViewCell headerViewCell];
            headerCell.account = self.account;
            return headerCell;
        }
        else { // 红包
            JXProfileViewCell *profileCell = [tableView dequeueReusableCellWithIdentifier:[JXProfileViewCell reuseIdentifier] forIndexPath:indexPath];
            profileCell.type = JXProfileViewCellTypeRedbag;
//            profileCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return profileCell;
        }
    }
    else {
        JXProfileViewCell *profileCell = [tableView dequeueReusableCellWithIdentifier:[JXProfileViewCell reuseIdentifier] forIndexPath:indexPath];
        profileCell.accessoryType = UITableViewCellAccessoryNone;
        switch (indexPath.row) {
            case 0: // 设置
                profileCell.type = JXProfileViewCellTypeSetting;
                break;
                
            case 1: // 帮助
                profileCell.type = JXProfileViewCellTypeHelp;
                break;
                
            case 2: // 换肤
                profileCell.type = JXProfileViewCellTypeChangeSkin;
                break;
                
            default:
                break;
        }
        return profileCell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) wSelf = self;
    if (indexPath.section == 0) {
        
    }
    else {
        switch (indexPath.row) {
            case 0: { // 设置
                
                break;
            }
                
            case 1: // 帮助
                
                break;
                
            case 2:  { // 换肤
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.skinVC];
                [self presentViewController:nav animated:YES completion:nil];
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
