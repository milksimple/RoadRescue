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
//- (void)skinViewCellDidClickedDownLoadButton;
/** 需要控制器present alertVC */
- (void)skinViewCellNeedPresentAlertVC:(UIAlertController *)alertVC;
/** 使用了某个主题 */
- (void)skinViewCellDidUsedSomeoneSkin;

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
