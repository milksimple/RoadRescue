//
//  JXNewFeatureViewController.m
//  JMXMiJia
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 mac. All rights reserved.
//

#define JXNewfeatureCount 4

#import "JXNewFeatureViewController.h"
#import "UIView+JXExtension.h"
#import "JXTabBarViewController.h"

@interface JXNewFeatureViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation JXNewFeatureViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 1.创建一个scrollView：显示所有的新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 2.添加图片到scrollView中
    CGFloat scrollW = scrollView.jx_width;
    CGFloat scrollH = scrollView.jx_height;
    for (int i = 0; i<JXNewfeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.jx_width = scrollW;
        imageView.jx_height = scrollH;
        imageView.jx_y = 0;
        imageView.jx_x = i * scrollW;
        // 显示图片
        NSString *name = [NSString stringWithFormat:@"guide_%d", i + 1];
        if (JXScreenH <= 480) {
            name = [NSString stringWithFormat:@"guide_%d_ip4", i + 1];
        }
        
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        // 如果是最后一个imageView，就往里面添加其他内容
        if (i == JXNewfeatureCount - 1) {
            [self setupLastImageView:imageView];
        }
        else {
            [self setupFrontImageView:imageView];
        }
    }
    
    // 3.设置scrollView的其他属性
    // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
    scrollView.contentSize = CGSizeMake(JXNewfeatureCount * scrollW, 0);
    scrollView.bounces = NO; // 去除弹簧效果
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    // 4.添加pageControl：分页，展示目前看的是第几页
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = JXNewfeatureCount;
    pageControl.currentPageIndicatorTintColor = JXColor(58, 58, 58);
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.jx_centerX = scrollW * 0.5;
    pageControl.jx_centerY = scrollH - 20;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.jx_width;
    // 四舍五入计算出页码
    self.pageControl.currentPage = (int)(page + 0.5);
}

/**
 *  初始化前面几个imageView
 *  @param imageView 最后一个imageView
 */
- (void)setupFrontImageView:(UIImageView *)imageView {
    imageView.userInteractionEnabled = YES;
    
    UIButton *nextBtn = [[UIButton alloc] init];
    CGFloat nextW = 41;
    CGFloat nextH = 30;
    CGFloat nextX = JXScreenW - nextW - 10;
    CGFloat nextY = JXScreenH - nextH - 5;
    
    nextBtn.frame = CGRectMake(nextX, nextY, nextW, nextH);
    [nextBtn setImage:[UIImage imageNamed:@"guide_next"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:nextBtn];
}

/**
 *  初始化最后一个imageView
 *  @param imageView 最后一个imageView
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    // 开启交互功能
    imageView.userInteractionEnabled = YES;
    
    // 2.开始
    UIButton *startBtn = [[UIButton alloc] init];
    CGFloat startW = 100;
    CGFloat startH = 30;
    CGFloat startX = (self.view.jx_width - startW) * 0.5;
    CGFloat startY = JXScreenH - startH - 40;
    
    startBtn.frame = CGRectMake(startX, startY, startW, startH);
    startBtn.layer.cornerRadius = 5;
    startBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    startBtn.layer.borderWidth = 1;
    startBtn.clipsToBounds = YES;
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
}

- (void)nextBtnClicked {
    [self.scrollView setContentOffset:CGPointMake(JXScreenW*(self.pageControl.currentPage + 1), 0) animated:YES];
}

- (void)shareClick:(UIButton *)shareBtn
{
    // 状态取反
    shareBtn.selected = !shareBtn.isSelected;
}

- (void)startClick
{
    // 切换到JXTabBarController
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[JXTabBarViewController alloc] init];
}
@end
