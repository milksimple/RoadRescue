//
//  JXComplaintViewController.m
//  RoadRescue
//
//  Created by mac on 16/7/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXComplaintViewController.h"
#import "JXTextView.h"
#import "JXComplaintListViewController.h"
#import "JXOrderDetail.h"
#import "JXHttpTool.h"
#import "MBProgressHUD+MJ.h"

@interface JXComplaintViewController () <JXComplaintListViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *selectTeamLabel;
@property (weak, nonatomic) IBOutlet JXTextView *complaintDesVeiw;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *labelContainer;

@property (nonatomic, strong) JXOrderDetail *orderDetail;

@end

@implementation JXComplaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"用户投诉";
    
    // 设置背景
    self.bgView.image = [JXSkinTool skinToolImageWithImageName:@"complete_bg.jpg"];
    self.labelContainer.backgroundColor = self.complaintDesVeiw.backgroundColor = [JXSkinTool skinToolColorWithKey:@"profile_cell_bg"];
    
    self.complaintDesVeiw.placeholder = @"请您描述详细投诉内容(不超过500字)";
    
    self.complaintDesVeiw.placeholderColor = [JXSkinTool skinToolColorWithKey:@"rescue_content_text"];
    self.selectTeamLabel.textColor = self.titleLabel.textColor = self.complaintDesVeiw.textColor = [JXSkinTool skinToolColorWithKey:@"profile_title_text"];
}

- (IBAction)selectTeamButtonClicked {
    JXComplaintListViewController *complaintListVC = [[JXComplaintListViewController alloc] init];
    complaintListVC.delegate = self;
    [self.navigationController pushViewController:complaintListVC animated:YES];
}


- (IBAction)submitButtonClicked {
    if (self.selectTeamLabel.text.length == 0) {
        // 提示没有定位到
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择投诉表单" message:@"选择您要投诉的表单" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cfmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:cfmAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    if (self.complaintDesVeiw.text.length == 0) {
        // 提示没有定位到
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"投诉内容不能为空" message:@"请填写详细投诉内容" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cfmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:cfmAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在提交"];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"mobile"] = JXMyAccount.telephone;
    paras[@"token"] = JXMyAccount.token;
    paras[@"orderNum"] = self.orderDetail.orderNum;
    paras[@"des"] = self.complaintDesVeiw.text;
    [JXHttpTool post:[NSString stringWithFormat:@"%@/complain/save", JXServerName] params:paras success:^(id json) {
        [MBProgressHUD hideHUD];
        JXLog(@"提交投诉请求成功 - %@", json);
        BOOL success = [json[@"success"] boolValue];
        if (success) {
            [MBProgressHUD showSuccess:@"提交成功！"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络连接失败"];
        JXLog(@"提交投诉请求失败 - %@", error);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - JXComplaintListViewControllerDelegate
- (void)complaintListViewControllerDidFinishSelectOrderDetail:(JXOrderDetail *)orderDetail {
    self.orderDetail = orderDetail;
    self.selectTeamLabel.text = [NSString stringWithFormat:@"%@ 救援组 燃油耗尽", orderDetail.title];
}

@end
