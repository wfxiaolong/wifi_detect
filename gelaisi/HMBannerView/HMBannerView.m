//
//  HMBannerView.m
//  HMBannerViewDemo
//
//  Created by Dennis on 13-12-31.
//  Copyright (c) 2013年 Babytree. All rights reserved.
//

#import "HMBannerView.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"
#import "FXPageControl.h"
#import "UtilToolkit.h"
#import "UIImageView+WebCache.h"
#define Banner_StartTag     1000


@interface HMBannerView ()
{
    // 下载统计
    NSInteger totalCount;
}

@property (nonatomic, strong) FXPageControl *pageControl;
@property (nonatomic, assign) BOOL enableRolling;


- (void)refreshScrollView;

- (NSInteger)getPageIndex:(NSInteger)index;
- (NSArray *)getDisplayImagesWithPageIndex:(NSInteger)pageIndex;


@end

@implementation HMBannerView
@synthesize delegate;

@synthesize imagesArray;
@synthesize scrollDirection;

@synthesize pageControl;

- (void)dealloc
{
    delegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
}

- (id)initWithFrame:(CGRect)frame scrollDirection:(BannerViewScrollDirection)direction images:(NSArray *)images
{
    self = [super initWithFrame:frame];

    if(self)
    {
        self.imagesArray = [[NSArray alloc] initWithArray:images];

        self.scrollDirection = direction;

        totalPage = imagesArray.count;
        totalCount = totalPage;
        // 显示的是图片数组里的第一张图片
        // 和数组是+1关系
        curPage = 1;

        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.frame];
        imageV.image = [UIImage imageNamed:@"img_default_banner"];
        [self addSubview:imageV];
        
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.scrollsToTop = NO;
        [self addSubview:scrollView];
        
        // 在水平方向滚动
        if(scrollDirection == ScrollDirectionLandscape)
        {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3,
                                                scrollView.frame.size.height);
        }
        // 在垂直方向滚动 
        else if(scrollDirection == ScrollDirectionPortait)
        {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,
                                                scrollView.frame.size.height * 3);
        }

        for (NSInteger i = 0; i < 3; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
            imageView.userInteractionEnabled = YES;
            imageView.tag = Banner_StartTag+i;

            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [imageView addGestureRecognizer:singleTap];

            // 水平滚动
            if(scrollDirection == ScrollDirectionLandscape)
            {
                imageView.frame = CGRectOffset(imageView.frame, scrollView.frame.size.width * i, 0);
            }
            // 垂直滚动
            else if(scrollDirection == ScrollDirectionPortait)
            {
                imageView.frame = CGRectOffset(imageView.frame, 0, scrollView.frame.size.height * i);
            }
            
            [scrollView addSubview:imageView];
        }

        self.pageControl = [[FXPageControl alloc] initWithFrame:CGRectMake(5, frame.size.height-15, 200, 15)];
        self.pageControl.backgroundColor = [UIColor clearColor];
        self.pageControl.numberOfPages = self.imagesArray.count;
        self.pageControl.selectedDotImage = [UIImage imageNamed:@"img_slider_sel"];
        self.pageControl.dotImage = [UIImage imageNamed:@"img_slider_nor"];
        self.pageControl.dotSpacing = 6.0f;
        [self addSubview:self.pageControl];

        self.pageControl.currentPage = 0;
        [self refreshScrollView];
    }
    
    return self;
}

- (void)reloadBannerWithData:(NSArray *)images
{
    if (self.enableRolling) {
        [self stopRolling];
    }
    
    self.imagesArray = [[NSArray alloc] initWithArray:images];

    totalPage = imagesArray.count;
    totalCount = totalPage;
    curPage = 1;
    self.pageControl.numberOfPages = totalPage;
    [self.pageControl invalidateIntrinsicContentSize];
    self.pageControl.currentPage = 0;
    [self refreshScrollView];
}

- (void)setSquare:(NSInteger)asquare
{
    if (scrollView)
    {
        scrollView.layer.cornerRadius = asquare;
        if (asquare == 0)
        {
            scrollView.layer.masksToBounds = NO;
        }
        else
        {
            scrollView.layer.masksToBounds = YES;
        }
    }
}

- (void)setPageControlStyle:(BannerViewPageStyle)pageStyle {
#define PageControlInset 5
#define PageControlHeightInset -5.0f
    [self.pageControl removeConstraints:self.pageControl.constraints];
    if (pageStyle == PageStyle_Left)
    {
        [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:PageControlInset];
        [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-PageControlHeightInset];
    }
    else if (pageStyle == PageStyle_Right)
    {
        [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:-PageControlInset];
        [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-PageControlHeightInset];
    }
    else if (pageStyle == PageStyle_Middle)
    {
        [self.pageControl autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-PageControlHeightInset];
    }
    else if (pageStyle == PageStyle_None)
    {
        [self.pageControl setHidden:YES];
    }
}

- (void)showClose:(BOOL)show {
    if (show)
    {
        if (!BannerCloseButton)
        {
            BannerCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [BannerCloseButton setFrame:CGRectMake(self.bounds.size.width-40, 0, 40, 40)];
            [BannerCloseButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
            [BannerCloseButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [BannerCloseButton addTarget:self action:@selector(closeBanner) forControlEvents:UIControlEventTouchUpInside];
            [BannerCloseButton setImage:[UIImage imageNamed:@"banner_close"] forState:UIControlStateNormal];
            [self addSubview:BannerCloseButton];
        }

        BannerCloseButton.hidden = NO;
    }
    else
    {
        if (BannerCloseButton)
        {
            BannerCloseButton.hidden = YES;
        }
    }
}

- (void)closeBanner {
    [self stopRolling];

    if ([self.delegate respondsToSelector:@selector(bannerViewdidClosed:)])
    {
        [self.delegate bannerViewdidClosed:self];
    }
}

#pragma mark - Custom Method

- (void)refreshScrollView {
    NSArray *curimageUrls = [self getDisplayImagesWithPageIndex:curPage];

    for (NSInteger i = 0; i < 3; i++)
    {
        UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:Banner_StartTag+i];
        NSString *imgName = [curimageUrls objectAtIndex:i];
        if (imageView && [imageView isKindOfClass:[UIImageView class]]) {
            imageView.image = [UIImage imageNamed:imgName];
        }
    }

    // 水平滚动
    if (scrollDirection == ScrollDirectionLandscape)
    {
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    }
    // 垂直滚动
    else if (scrollDirection == ScrollDirectionPortait)
    {
        scrollView.contentOffset = CGPointMake(0, scrollView.frame.size.height);
    }

    self.pageControl.currentPage = curPage-1;
}

- (NSArray *)getDisplayImagesWithPageIndex:(NSInteger)page {
    NSInteger pre = [self getPageIndex:curPage-1];
    NSInteger last = [self getPageIndex:curPage+1];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
    
    [images addObject:[imagesArray objectAtIndex:pre-1]];
    [images addObject:[imagesArray objectAtIndex:curPage-1]];
    [images addObject:[imagesArray objectAtIndex:last-1]];
    
    return images;
}

- (NSInteger)getPageIndex:(NSInteger)index {
    // value＝1为第一张，value = 0为前面一张
    if (index == 0)
    {
        index = totalPage;
    }

    if (index == totalPage + 1)
    {
        index = 1;
    }
    
    return index;
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if (self.imagesArray == nil || [self.imagesArray count] == 0) {
        return;
    }
    NSInteger x = aScrollView.contentOffset.x;
    NSInteger y = aScrollView.contentOffset.y;
    //NSLog(@"did  x=%d  y=%d", x, y);

    //取消已加入的延迟线程
    if (self.enableRolling)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
    }

    // 水平滚动
    if(scrollDirection == ScrollDirectionLandscape)
    {
        // 往下翻一张
        if (x >= 2 * scrollView.frame.size.width)
        {
            curPage = [self getPageIndex:curPage+1];
            [self refreshScrollView];
        }

        if (x <= 0)
        {
            curPage = [self getPageIndex:curPage-1];
            [self refreshScrollView];
        }
    }
    // 垂直滚动
    else if(scrollDirection == ScrollDirectionPortait)
    {
        // 往下翻一张
        if (y >= 2 * scrollView.frame.size.height)
        {
            curPage = [self getPageIndex:curPage+1];
            [self refreshScrollView];
        }

        if (y <= 0)
        {
            curPage = [self getPageIndex:curPage-1];
            [self refreshScrollView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    // 水平滚动
    if (scrollDirection == ScrollDirectionLandscape)
    {
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    }
    // 垂直滚动
    else if (scrollDirection == ScrollDirectionPortait)
    {
        scrollView.contentOffset = CGPointMake(0, scrollView.frame.size.height);
    }

    if (self.enableRolling)
    {
        [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime];
    }
}


#pragma mark -
#pragma mark Rolling

- (void)startRolling
{
    if (![self.imagesArray count] || self.imagesArray.count == 1)
    {
        return;
    }

    [self stopRolling];

    self.enableRolling = YES;
    [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime];
}

- (void)stopRolling
{
    self.enableRolling = NO;
    //取消已加入的延迟线程
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
}

- (void)rollingScrollAction {
    [UIView animateWithDuration:0.25 animations:^{
        // 水平滚动
        if(scrollDirection == ScrollDirectionLandscape)
        {
            scrollView.contentOffset = CGPointMake(1.99*scrollView.frame.size.width, 0);
        }
        // 垂直滚动
        else if(scrollDirection == ScrollDirectionPortait)
        {
            scrollView.contentOffset = CGPointMake(0, 1.99*scrollView.frame.size.height);
        }
        //NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    } completion:^(BOOL finished) {
        curPage = [self getPageIndex:curPage+1];
        [self refreshScrollView];

        if (self.enableRolling)
        {
            [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime];
        }
    }];
}

#pragma mark - SDWebImageManager Delegate

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image {
    totalCount--;

    if (totalCount == 0)
    {
        curPage = 1;
        [self refreshScrollView];

        if ([self.delegate respondsToSelector:@selector(imageCachedDidFinish:)])
        {
            [self.delegate imageCachedDidFinish:self];
        }
    }
}


#pragma mark -
#pragma mark action

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if (self.imagesArray == nil || [self.imagesArray count] == 0) {
        return;
    }
    if ([delegate respondsToSelector:@selector(bannerView:didSelectImageView:withData:)])
    {
        [delegate bannerView:self didSelectImageView:curPage-1 withData:[self.imagesArray objectAtIndex:curPage-1]];
    }
}

@end
