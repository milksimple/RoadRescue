//
//  JXSkinViewController.m
//  RoadRescue
//
//  Created by mac on 16/6/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXSkinViewController.h"
#import "JXSkinViewCell.h"
#import <AFNetworking.h>
#import <SSZipArchive.h>
#import <CFNetwork/CFHTTPStream.h>
#import "JXSkin.h"
#import "JXHttpTool.h"
#import <MJExtension.h>
#import "MBProgressHUD+MJ.h"

@interface JXSkinViewController ()
{
    // 下载句柄
    NSURLSessionDownloadTask *_downloadTask;
}

/** 进度条 */
@property (nonatomic, weak) UIProgressView *progressView;

/** cell */
@property (nonatomic, weak) JXSkinViewCell *skinViewCell;

/** 皮肤数组 */
@property (nonatomic, strong) NSMutableArray *skins;

@end

@implementation JXSkinViewController
- (NSMutableArray *)skins {
    if (_skins == nil) {
        _skins = [NSMutableArray array];
        JXSkin *skin = [[JXSkin alloc] init];
        skin.title = @"默认";
        skin.frontcover = @"default";
        skin.packageName = JXSkinTypeOriginStr;
        [_skins addObject:skin];
    }
    return _skins;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"更换主题";
    
    [self setupCancelButton];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JXSkinViewCell class]) bundle:nil] forCellReuseIdentifier:[JXSkinViewCell reuseIdentifier]];
    
    // 先从沙盒加载皮肤的json数据
    id json = [JXUserDefaults objectForKey:JXSkinsJsonKey];
    [self dealData:json];
    
    [self loadSkinData];
}

- (void)setupCancelButton {
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"返回" forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"nav_back_gray"] forState:UIControlStateNormal];
    [cancelButton setTitleColor:JXColor(158, 158, 158) forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(0, 0, 50, 20);
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 让按钮的内容往左边偏移10
    cancelButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
}

- (void)cancelButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadSkinData {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"os"] = @"ios";
    [JXHttpTool post:[NSString stringWithFormat:@"%@/skin", JXServerName] params:paras success:^(id json) {
        BOOL success = json[@"success"];
        if (success) {
            // json数组存入沙盒
            [JXUserDefaults setObject:json forKey:JXSkinsJsonKey];
            [JXUserDefaults synchronize];
            
            [self dealData:json];
        }
    } failure:^(NSError *error) {
        JXLog(@"请求皮肤列表失败 - %@", error);
//        [MBProgressHUD showError:@"网络连接失败"];
    }];
}

- (void)dealData:(id)json {
    // 清空数组
    self.skins = nil;
    NSArray *skinArray = [JXSkin mj_objectArrayWithKeyValuesArray:json[@"data"]];
    [self.skins addObjectsFromArray:skinArray];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.skins.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JXSkinViewCell *cell = [JXSkinViewCell skinCell];
    cell.skin = self.skins[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JXSkinViewCell rowHeight];
}

@end
