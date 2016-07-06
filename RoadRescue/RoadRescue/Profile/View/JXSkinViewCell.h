//
//  JXSkinViewCell.h
//  RoadRescue
//
//  Created by mac on 16/6/22.
//  Copyright © 2016年 mac. All rights reserved.
//

typedef enum {
    JXSkinViewCellStatusDefault, // 默认皮肤
    JXSkinViewCellStatusNoDownload, // 未下载
    JXSkinViewCellStatusDownloaded, // 已下载
    JXSkinViewCellStatusDownloading, // 正在下载
    JXSkinViewCellStatusPause, // 已暂停
    JXSkinViewCellStatusUsing // 使用中
} JXSkinViewCellStatus;

#import <UIKit/UIKit.h>
@class JXSkin;

@protocol JXSkinViewCellDelegate <NSObject>

@optional
- (void)skinViewCellDidClickedDownLoadButton;
/** 皮肤状态发生了改变(有新皮肤下载成功、改变皮肤、删除了皮肤等等)，一般控制器需要啊在此方法刷新tableview */
- (void)skinViewCellDidChangedStatus;
/** 需要控制器present alertVC */
- (void)skinViewCellNeedPresentAlertVC:(UIAlertController *)alertVC;

@end

@interface JXSkinViewCell : UITableViewCell

+ (instancetype)skinCell;

/** 皮肤模型 */
@property (nonatomic, strong) JXSkin *skin;

+ (NSString *)reuseIdentifier;

/** 状态 */
@property (nonatomic, assign) JXSkinViewCellStatus status;

/** 代理 */
@property (nonatomic, weak) id<JXSkinViewCellDelegate> delegate;

+ (CGFloat)rowHeight;

@end
