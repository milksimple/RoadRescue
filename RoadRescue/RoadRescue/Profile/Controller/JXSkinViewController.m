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

@interface JXSkinViewController () <JXSkinViewCellDelegate>
{
    // 下载句柄
    NSURLSessionDownloadTask *_downloadTask;
}

///** 皮肤名称数组 */
//@property (nonatomic, strong) NSMutableArray *skinNames;

/** 进度条 */
@property (nonatomic, weak) UIProgressView *progressView;

/** cell */
@property (nonatomic, weak) JXSkinViewCell *skinViewCell;

/** 皮肤数组 */
@property (nonatomic, strong) NSMutableArray *skins;

@end

@implementation JXSkinViewController
#pragma mark - lazy
//- (NSMutableArray *)skinNames {
//    if (_skinNames == nil) {
//        _skinNames = [NSMutableArray array];
//    }
//    return _skinNames;
//}

#warning 测试数据
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
        JXLog(@"请求皮肤列表成功 - %@", json);
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
    cell.delegate = self;
    cell.skin = self.skins[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JXSkinViewCell rowHeight];
}

#pragma mark -JXSkinViewCellDelegate
//- (void)skinViewCellDidChangedStatus {
//    [self.tableView reloadData];
//}

- (void)skinViewCellDidUsedSomeoneSkin {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)skinViewCellNeedPresentAlertVC:(UIAlertController *)alertVC {
        [self presentViewController:alertVC animated:YES completion:nil];
    
}

//- (void)skinViewCellDidClickedDownLoadButton {
////    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/brick.zip", JXServerName]];
//    NSURL *url = [NSURL URLWithString:@"ftp://10.255.31.110/upload/roadRescueGu/complete_bg@3x.png"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    //默认配置
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    
//    //AFN3.0+基于封住URLSession的句柄
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
//        });
//    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        NSString *tmp = NSTemporaryDirectory();
//        NSString *filePath = [tmp stringByAppendingPathComponent:response.suggestedFilename];
//        return [NSURL fileURLWithPath:filePath];
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
////        JXLog(@"下载成功");
////        // 解压
////        NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
////        BOOL result = [SSZipArchive unzipFileAtPath:filePath.path  toDestination:cache];
////        if (result) {
////            JXLog(@"解压成功");
////            dispatch_async(dispatch_get_main_queue(), ^{
////                [self.skinViewCell.downLoadButton setTitle:@"使用" forState:UIControlStateNormal];
////            });
////        }
//        
//        JXLog(@"下载出错 - %@", error);
//    }];
//    
//    [downloadTask resume];
//}

@end
