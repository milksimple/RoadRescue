//
//  JXProfileViewCell.m
//  RoadRescueTeam
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXProfileViewCell.h"

@interface JXProfileViewCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *accessory;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *separator;

@end

@implementation JXProfileViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setType:(JXProfileViewCellType)type {
    _type = type;
    
    switch (type) {
            
        case JXProfileViewCellTypeRedbag:
            self.accessory.hidden = NO;
            self.rightLabel.hidden = YES;
            self.iconView.image = [JXSkinTool skinToolImageWithImageName:@"profile_redbag"];
            self.titleLabel.text = @"我的红包";
            self.separator.hidden = YES;
            break;
            
            
        case JXProfileViewCellTypeChangeSkin:
            self.accessory.hidden = YES;
            self.rightLabel.hidden = NO;
            self.iconView.image = [JXSkinTool skinToolImageWithImageName:@"profile_skin"];
            self.titleLabel.text = @"更换皮肤";
            self.separator.hidden = NO;
            break;
            
        case JXProfileViewCellTypeHelp:
            self.accessory.hidden = YES;
            self.rightLabel.hidden = YES;
            self.iconView.image = [JXSkinTool skinToolImageWithImageName:@"profile_help"];
            self.titleLabel.text = @"帮助";
            self.separator.hidden = NO;
            break;
            
        case JXProfileViewCellTypeLogout:
            self.accessory.hidden = YES;
            self.rightLabel.hidden = YES;
            self.iconView.image = [JXSkinTool skinToolImageWithImageName:@"profile_setting"];
            self.titleLabel.text = @"注销";
            self.separator.hidden = YES;
            break;
            
        default:
            break;
    }
    
    // 设置皮肤
    self.bgView.backgroundColor = [JXSkinTool skinToolColorWithKey:@"profile_cell_bg"];
    self.titleLabel.textColor = self.rightLabel.textColor = [JXSkinTool skinToolColorWithKey:@"profile_title_text"];
    self.separator.backgroundColor = [JXSkinTool skinToolColorWithKey:@"profile_cell_separator"];

}

+ (NSString *)reuseIdentifier {
    return @"profileViewCell";
}

+ (CGFloat)rowHeight {
    return 44;
}

@end
