//
//  JXTextView.h
//
//  Created by apple on 14-10-20.
//  Copyright (c) 2014年. All rights reserved.
//  增强：带有占位文字

#import <UIKit/UIKit.h>

@interface JXTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end
