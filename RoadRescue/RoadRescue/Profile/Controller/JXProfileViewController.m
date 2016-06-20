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

@interface JXProfileViewController ()

@end

@implementation JXProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人设置";
    self.tableView.backgroundColor = JXGlobalBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JXProfileViewCell class]) bundle:nil] forCellReuseIdentifier:[JXProfileViewCell reuseIdentifier]];
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
            return headerCell;
        }
        else { // 红包
            JXProfileViewCell *profileCell = [tableView dequeueReusableCellWithIdentifier:[JXProfileViewCell reuseIdentifier] forIndexPath:indexPath];
            profileCell.type = JXProfileViewCellTypeRedbag;
            profileCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
            case 0: // 设置
                
                break;
                
            case 1: // 帮助
                
                break;
                
            case 2:  { // 换肤
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"切换皮肤" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *originAction = [UIAlertAction actionWithTitle:@"普通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [JXSkinTool setSkinType:JXSkinTypeOriginStr];
                    [wSelf.tableView reloadData];
                }];
                UIAlertAction *brickAction = [UIAlertAction actionWithTitle:@"碳纤维" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [JXSkinTool setSkinType:JXSkinTypeBrickStr];
                    [wSelf.tableView reloadData];
                }];
                UIAlertAction *woodAction = [UIAlertAction actionWithTitle:@"木纹" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [JXSkinTool setSkinType:JXSkinTypeWoodStr];
                    [wSelf.tableView reloadData];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertVC addAction:originAction];
                [alertVC addAction:brickAction];
                [alertVC addAction:woodAction];
                [alertVC addAction:cancelAction];
                
                [self presentViewController:alertVC animated:YES completion:nil];
                break;
            }
                
            default:
                break;
        }
    }
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

@end
