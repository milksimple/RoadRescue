//
//  JXSkinViewCell.m
//  RoadRescue
//
//  Created by mac on 16/6/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXSkinViewCell.h"
#import "JXSkin.h"
#import "JXFTPTool.h"
#import "MBProgressHUD+MJ.h"
#import <SSZipArchive.h>
#import <UIImageView+WebCache.h>

@interface JXSkinViewCell()

@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *skinNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *bytesWrittenLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@property (nonatomic, strong) JXFTPTool *ftpTool;

@end

@implementation JXSkinViewCell
#pragma mark - lazy
- (JXFTPTool *)ftpTool {
    if (_ftpTool == nil) {
        _ftpTool = [[JXFTPTool alloc] init];
    }
    return _ftpTool;
}

//- (IBAction)downLoadButtonClicked {
//    if ([self.delegate respondsToSelector:@selector(skinViewCellDidClickedDownLoadButton)]) {
//        [self.delegate skinViewCellDidClickedDownLoadButton];
//    }
//}

+ (instancetype)skinCell {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

+ (NSString *)reuseIdentifier {
    return @"skinViewCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.container.layer.borderColor = JXColor(115, 209, 80).CGColor;
    
    // 监听皮肤的切换
    [JXNotificationCenter addObserver:self selector:@selector(skinChanged:) name:JXChangedSkinNotification object:nil];
}

- (void)setSkin:(JXSkin *)skin {
    _skin = skin;
    
    if ([skin.title isEqualToString:@"默认"]) {
        self.iconView.image = [UIImage imageNamed:@"default"];
    }
    else {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:skin.frontcover] placeholderImage:[UIImage imageNamed:@"icon_placeholder"]];
    }
    
    self.skinNameLabel.text = skin.title;
    
    // 判断是否为已使用
    NSString *usingSkinName = [JXSkinTool skinType];
    if ([usingSkinName isEqualToString:skin.packageName]) {
        self.status = JXSkinViewCellStatusUsing;
        return;
    }
    
    // 判断是否是默认皮肤
    if ([skin.title isEqualToString:@"默认"]) {
        self.status = JXSkinViewCellStatusDefault;
        return;
    }
    
    // 根据包名去沙盒里面找相应的文件
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSString *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *skinPackagePath = [cache stringByAppendingPathComponent:skin.packageName];
    BOOL cacheExist = [mgr fileExistsAtPath:skinPackagePath];
    if (cacheExist) { // 已下载
        self.status = JXSkinViewCellStatusDownloaded;
        return;
    }

    // 到tmp文件查看压缩包是否存在
    NSString *tmp = NSTemporaryDirectory();
    NSString *fileName = [NSString stringWithFormat:@"%@.zip", skin.packageName];
    NSString *skinZipPath = [tmp stringByAppendingPathComponent:fileName];
    BOOL tmpExist = [mgr fileExistsAtPath:skinZipPath];
    if (tmpExist) { // 存在压缩包, 正在下载
        self.status = JXSkinViewCellStatusPause;
        return;
    }
    else { // 压缩包不存在, 未下载
        self.status = JXSkinViewCellStatusNoDownload;
        return;
    }
}

- (void)setStatus:(JXSkinViewCellStatus)status {
    _status = status;
    
    switch (status) {
        case JXSkinViewCellStatusDefault: { // 默认皮肤，根据setSkin方法里面，这里肯定不是正在使用的皮肤
            self.progressView.hidden = YES;
            self.selectedImageView.hidden = YES;
            self.bytesWrittenLabel.hidden = YES;
            self.loadStatusLabel.hidden = YES;
            self.sizeLabel.hidden = YES;
            self.container.layer.borderWidth = 0;
            self.loadStatusLabel.textColor = JXColor(246, 39, 0);
        }
            break;
            
        case JXSkinViewCellStatusNoDownload: { // 未下载
            self.progressView.hidden = YES;
            self.selectedImageView.hidden = YES;
            self.bytesWrittenLabel.hidden = YES;
            self.loadStatusLabel.hidden = YES;
            self.sizeLabel.hidden = NO;
            self.container.layer.borderWidth = 0;
            self.loadStatusLabel.textColor = JXColor(246, 39, 0);
            self.sizeLabel.text = [NSString stringWithFormat:@"%.1fM", self.skin.size/1024.0/1024.0];
        }
            break;
            
        case JXSkinViewCellStatusDownloading: { // 正在下载
            self.progressView.hidden = NO;
            self.selectedImageView.hidden = YES;
            self.bytesWrittenLabel.hidden = NO;
            self.loadStatusLabel.hidden = NO;
            self.sizeLabel.hidden = YES;
            self.container.layer.borderWidth = 0;
            self.loadStatusLabel.textColor = JXColor(63, 203, 87);
            
            // 计算压缩包大小
            NSUInteger zipSize = [self.ftpTool fileSizeWithDownLoadFileName:[self.skin.packageName stringByAppendingPathExtension:@"zip"]];
            JXLog(@"ZipSize = %zd", zipSize);
            self.bytesWrittenLabel.text = [NSString stringWithFormat:@"%.1fM/%.1fM", zipSize/1024.0/1024.0, self.skin.size/1024.0/1024.0];
            CGFloat progress = 1.0 *zipSize/self.skin.size;
            self.progressView.progress = progress;
            self.loadStatusLabel.text = [NSString stringWithFormat:@"等待下载 %.0f%%", progress*100];
        }
            break;
            
        case JXSkinViewCellStatusPause: { // 已暂停
            self.progressView.hidden = NO;
            self.selectedImageView.hidden = YES;
            self.bytesWrittenLabel.hidden = NO;
            self.loadStatusLabel.hidden = NO;
            self.sizeLabel.hidden = YES;
            self.container.layer.borderWidth = 0;
            self.loadStatusLabel.textColor = JXColor(246, 39, 0);
            
            // 计算压缩包大小
            NSUInteger zipSize = [self.ftpTool fileSizeWithDownLoadFileName:self.skin.skinPath.lastPathComponent];
            self.bytesWrittenLabel.text = [NSString stringWithFormat:@"%.1fM/%.1fM", zipSize/1024.0/1024.0, self.skin.size/1024.0/1024.0];
            CGFloat progress = 1.0 *zipSize/self.skin.size;
            self.loadStatusLabel.text = [NSString stringWithFormat:@"已暂停 %.0f%%", progress*100];
            self.progressView.progress = progress;
        }
            break;
            
        case JXSkinViewCellStatusDownloaded: { // 已下载
            self.progressView.hidden = YES;
            self.selectedImageView.hidden = YES;
            self.bytesWrittenLabel.hidden = YES;
            self.loadStatusLabel.hidden = YES;
            self.sizeLabel.hidden = NO;
            self.container.layer.borderWidth = 0;
            self.loadStatusLabel.textColor = JXColor(246, 39, 0);
            
            self.sizeLabel.text = @"已下载";
        }
            break;
            
        case JXSkinViewCellStatusUsing: { // 使用中
            self.progressView.hidden = YES;
            self.selectedImageView.hidden = NO;
            self.bytesWrittenLabel.hidden = YES;
            self.loadStatusLabel.hidden = YES;
            self.sizeLabel.hidden = YES;
            self.container.layer.borderWidth = 1;
            self.loadStatusLabel.textColor = JXColor(246, 39, 0);
            
        }
            break;
            
        default:
            break;
    }
}

+ (CGFloat)rowHeight {
    return 80;
}

- (IBAction)ctrBtnClicked {
    // 如果点击的是默认皮肤项，且当前皮肤是默认皮肤，那么是不需要弹出actionsheet的
    if (self.status == JXSkinViewCellStatusUsing) {
        return;
    }
    
    // 根据当前皮肤状态，弹出相应的actionsheet
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSMutableArray *options = [NSMutableArray array];
    switch (self.status) {
        case JXSkinViewCellStatusDefault: // 默认皮肤
            [options addObjectsFromArray:@[@"使用主题"]];
            break;
            
        case JXSkinViewCellStatusNoDownload: // 未下载
            [options addObjectsFromArray:@[@"下载"]];
            break;
            
        case JXSkinViewCellStatusDownloading: // 正在下载
            [options addObjectsFromArray:@[@"暂停", @"删除"]];
            break;
            
        case JXSkinViewCellStatusPause: // 已暂停
            [options addObjectsFromArray:@[@"继续下载", @"删除"]];
            break;
            
        case JXSkinViewCellStatusDownloaded: // 已下载
            [options addObjectsFromArray:@[@"使用主题", @"删除"]];
            break;
            
        case JXSkinViewCellStatusUsing: // 使用中
            
            break;
            
        default:
            break;
    }
    
    __weak typeof(self) wSelf = self;
    for (NSString *option in options) {
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if ([option isEqualToString:@"删除"]) {
            style = UIAlertActionStyleDestructive;
        }
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:option style:style handler:^(UIAlertAction * _Nonnull action) {
            if ([option isEqualToString:@"使用主题"]) {
                [wSelf useSkin];
                
            }
            else if ([option isEqualToString:@"下载"] || [option isEqualToString:@"继续下载"]) {
                [wSelf startDownload];
            }
            else if ([option isEqualToString:@"暂停"]) {
                [wSelf pauseDownload];
            }
            else if ([option isEqualToString:@"删除"]) {
                [wSelf deleteSkin];
            }
        }];
        
        [alertVC addAction:action];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancelAction];
    
    if ([self.delegate respondsToSelector:@selector(skinViewCellNeedPresentAlertVC:)]) {
        [self.delegate skinViewCellNeedPresentAlertVC:alertVC];
    }
}

/**
 *  使用主题
 */
- (void)useSkin {
    // 此方法内部会发送皮肤更改通知
    [JXSkinTool setSkinType:self.skin.packageName];
    // 要保证这个方在上面通知发出后，取消了上个cell的选中状态后，再设置自己为选中
    self.status = JXSkinViewCellStatusUsing;
    
    if ([self.delegate respondsToSelector:@selector(skinViewCellDidUsedSomeoneSkin)]) {
        [self.delegate skinViewCellDidUsedSomeoneSkin];
    }
}

/**
 *  开始下载/继续下载
 */
- (void)startDownload {
    self.status = JXSkinViewCellStatusDownloading;
    
    [self.ftpTool download:self.skin.skinPath username:JXFTPUsername password:JXFTPPassword progress:^(NSUInteger totalBytesWritten, CGFloat progress) {
        self.progressView.progress = progress;
        self.loadStatusLabel.text = [NSString stringWithFormat:@"正在下载 %.0f%%", progress*100];
        self.bytesWrittenLabel.text = [NSString stringWithFormat:@"%.1fM/%.1fM", totalBytesWritten/1024.0/1024.0, self.skin.size/1024.0/1024.0];
    } complete:^(NSString *filePath) {
        self.loadStatusLabel.text = @"正在解压";
        
        // 解压文件到cache
        [self performSelectorInBackground:@selector(unZipWithFilePath:) withObject:filePath];
        
    } error:^(NSString *error) {
        JXLog(@"下载错误 - %@", error);
        self.status = JXSkinViewCellStatusPause;
        [MBProgressHUD showError:@"网络错误, 请重试"];
    }];
}

/**
 *  暂停下载
 */
- (void)pauseDownload {
    self.status = JXSkinViewCellStatusPause;
    [self.ftpTool closeWithBlock:nil];
    self.ftpTool = nil;
}

/**
 *  删除皮肤
 */
- (void)deleteSkin {
    UIAlertController *deleteAlertVC = [UIAlertController alertControllerWithTitle:nil message:@"皮肤删除后要重新下载，确定删除？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // cache的文件夹和tmp的zip都要删除
        NSError *error1 = nil;
        [JXFileManager removeItemAtPath:[JXCachePath stringByAppendingPathComponent:self.skin.packageName] error:&error1];
        
        if (!error1) { // 删除成功
            self.status = JXSkinViewCellStatusNoDownload;
        }
        
        // 删除zip
        NSError *error2 = nil;
        // 删除zip
        [JXFileManager removeItemAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:self.skin.skinPath.lastPathComponent] error:&error2];
        if (!error2) {
            self.status = JXSkinViewCellStatusNoDownload;
        }
        
    }];
    [deleteAlertVC addAction:cancel];
    [deleteAlertVC addAction:confirm];
    
    // 通知代理,更新cell状态
    if ([self.delegate respondsToSelector:@selector(skinViewCellNeedPresentAlertVC:)]) {
        [self.delegate skinViewCellNeedPresentAlertVC:deleteAlertVC];
    }
}

- (void)skinChanged:(NSNotification *)noti {
    // 取消之前cell的选中状态
    self.container.layer.borderWidth = 0;
    if (self.status == JXSkinViewCellStatusUsing) { // 如果当前cell是正在用的cell，那么取消其选中状态
        if ([self.skin.title isEqualToString:@"默认"]) {
            self.status = JXSkinViewCellStatusDefault;
            return;
        }
        self.status = JXSkinViewCellStatusDownloaded;
    }
}

- (void)unZipWithFilePath:(NSString *)filePath {
    JXLog(@"filePath = %@", filePath);
    [SSZipArchive unzipFileAtPath:filePath toDestination:JXCachePath progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
    } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
        if (succeeded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.status = JXSkinViewCellStatusDownloaded;
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                JXLog(@"解压皮肤文件失败 - %@", error);
                [MBProgressHUD showError:@"下载错误, 请删除后重试"];
            });
        }
    }];
}

- (void)dealloc {
    JXLog(@"cell - dealloc");
    self.ftpTool = nil;
    [JXNotificationCenter removeObserver:self];
}

@end
