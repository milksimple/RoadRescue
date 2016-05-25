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

@interface JXRescueViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet JXTextView *accidentDesView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextButtonTopConstraint;

@end

@implementation JXRescueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    self.accidentDesView.placeholder = @"添加详细事故描述（可选）";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    CGFloat currentMaxY = CGRectGetMaxY(self.nextButton.frame) + 20;
//    if (currentMaxY < JXScreenH) {
//        //        self.contentViewBottomConstraint.constant = JXScreenH + 10 - CGRectGetMaxY(self.nextButton.frame) + 20;
//        //
//        //        JXLog(@"%f  %f", self.contentView.frame.size.height, JXScreenH + 10 - CGRectGetMaxY(self.nextButton.frame));
//        //        [self.view layoutIfNeeded];
//        self.nextButtonTopConstraint.constant = 200;
//    }
//    
//    
//}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    CGFloat currentMaxY = CGRectGetMaxY(self.nextButton.frame) + 20;
//    if (currentMaxY < JXScreenH) {
////        self.contentViewBottomConstraint.constant = JXScreenH + 10 - CGRectGetMaxY(self.nextButton.frame) + 20;
////        
////        JXLog(@"%f  %f", self.contentView.frame.size.height, JXScreenH + 10 - CGRectGetMaxY(self.nextButton.frame));
////        [self.view layoutIfNeeded];
//        self.nextButtonTopConstraint.constant = 200;
//    }
//}

- (void)setupNav {
    self.navigationItem.title = @"发布救援申请";
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.textColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    self.navigationController.navigationBar.barTintColor = JXMiOrangeColor;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor bla]}];
    
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    JXLog(@"touchesBegan");
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
