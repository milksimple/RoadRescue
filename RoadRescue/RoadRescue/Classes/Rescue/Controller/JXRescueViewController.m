//
//  JXRescueViewController.m
//  RoadRescue
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXRescueViewController.h"
#import "JXVerticalButton.h"
#import "UIView+JXExtension.h"
#import "JXTextView.h"
#import "JXRescueDetailViewController.h"

@interface JXRescueViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet JXTextView *accidentDesView;

@end

@implementation JXRescueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    self.accidentDesView.placeholder = @"添加详细事故描述（可选）";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.contentView.jx_height = CGRectGetMaxY(self.nextButton.frame) + 20;
    self.scrollView.contentSize = CGSizeMake(self.view.jx_width, self.contentView.jx_height + 10);
}

- (void)setupNav {
    self.navigationItem.title = @"发布救援申请";
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.textColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    self.navigationController.navigationBar.barTintColor = JXMiOrangeColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)oilButtonClicked:(JXVerticalButton *)sender {
    sender.selected = !sender.isSelected;
    
}

- (IBAction)fixButtonClicked:(JXVerticalButton *)sender {
    sender.selected = !sender.isSelected;
    
}

/**
 *  点击了下一步
 */
- (IBAction)nextButtonClicked {
    JXRescueDetailViewController *rescueDetailVC = [[JXRescueDetailViewController alloc] init];
    [self.navigationController pushViewController:rescueDetailVC animated:YES];
}



@end
