//
//  JXProfileHeaderViewCell.m
//  RoadRescueTeam
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXProfileHeaderViewCell.h"
#import "UIButton+WebCache.h"

@interface JXProfileHeaderViewCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UIImageView *accessory;
@property (weak, nonatomic) IBOutlet UIView *separator;

@end

@implementation JXProfileHeaderViewCell

+ (instancetype)headerViewCell {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

+ (CGFloat)rowHeight {
    return 80;
}

- (void)setAccount:(JXAccount *)account {
    _account = account;
    
    if (account.icon.length > 0) {
        [self.iconButton sd_setImageWithURL:[NSURL URLWithString:account.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_placeholder"]];
    }
#warning 测试 名字什么的设置后面再说
    self.mobileLabel.text = [NSString stringWithFormat:@"ID：%@", account.telephone];
    
    // 设置皮肤
    self.bgView.backgroundColor = [JXSkinTool skinToolColorWithKey:@"profile_header_bg"];
    self.nameLabel.textColor = self.mobileLabel.textColor = [JXSkinTool skinToolColorWithKey:@"profile_title_text"];
    self.separator.backgroundColor = [JXSkinTool skinToolColorWithKey:@"profile_header_separator"];
}

@end
