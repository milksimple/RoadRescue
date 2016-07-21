//
//  JXHelpViewController.m
//  RoadRescue
//
//  Created by mac on 16/7/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXHelpViewController.h"
#import "JXComplaintViewController.h"

@interface JXHelpViewController ()

@end

@implementation JXHelpViewController
- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"帮助";
    
    // 设置背景
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = self.view.bounds;
    bgView.image = [JXSkinTool skinToolImageWithImageName:@"complete_bg.jpg"];
    self.tableView.backgroundView = bgView;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"helpCell"];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"helpCell" forIndexPath:indexPath];
    cell.textLabel.textColor = JXColor(69, 69, 69);
    // 设置皮肤
    cell.backgroundColor = [UIColor clearColor];
//    cell.backgroundColor = [JXSkinTool skinToolColorWithKey:@"profile_cell_bg"];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [JXSkinTool skinToolColorWithKey:@"profile_title_text"];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"使用帮助";
            break;
            
        case 1:
            cell.textLabel.text = @"用户投诉";
            break;
            
        default:
            break;
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selected = NO;
    });
    
    switch (indexPath.row) {
        case 0:
            
            break;
            
        case 1: { // 用户投诉
            JXComplaintViewController *complaintVC = [[JXComplaintViewController alloc] init];
            [self.navigationController pushViewController:complaintVC animated:YES];
        }
            break;
            
        default:
            break;
    }

}

@end
