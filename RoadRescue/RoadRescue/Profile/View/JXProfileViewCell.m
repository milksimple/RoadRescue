//
//  JXProfileViewCell.m
//  RoadRescueTeam
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXProfileViewCell.h"

@interface JXProfileViewCell()
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
            self.iconView.image = [UIImage imageNamed:@"profile_redbag"];
            self.titleLabel.text = @"我的红包";
            self.separator.hidden = YES;
            break;
            
        case JXProfileViewCellTypeSetting:
            self.accessory.hidden = YES;
            self.rightLabel.hidden = YES;
            self.iconView.image = [UIImage imageNamed:@"profile_setting"];
            self.titleLabel.text = @"设置";
            self.separator.hidden = NO;
            break;
            
        case JXProfileViewCellTypeHelp:
            self.accessory.hidden = YES;
            self.rightLabel.hidden = YES;
            self.iconView.image = [UIImage imageNamed:@"profile_help"];
            self.titleLabel.text = @"帮助";
            self.separator.hidden = NO;
            break;
            
        case JXProfileViewCellTypeChangeSkin:
            self.accessory.hidden = YES;
            self.rightLabel.hidden = NO;
            self.iconView.image = [UIImage imageNamed:@"profile_help"];
            self.titleLabel.text = @"更换皮肤";
            self.separator.hidden = YES;
            break;
            
        default:
            break;
    }
    
    NSString *skinType = [JXSkinTool skinType];
    if ([skinType isEqualToString:JXSkinTypeOriginStr]) {
        self.rightLabel.text = @"普通";
    }
    else if ([skinType isEqualToString:JXSkinTypeBrickStr]) {
        self.rightLabel.text = @"碳纤维";
    }
    else if ([skinType isEqualToString:JXSkinTypeWoodStr]) {
        self.rightLabel.text = @"木纹";
    }
}

+ (NSString *)reuseIdentifier {
    return @"profileViewCell";
}

+ (CGFloat)rowHeight {
    return 44;
}

@end
