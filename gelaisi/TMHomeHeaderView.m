//
//  TMHomeHeaderView.m
//  Jingtemai
//
//  Created by Jasper on 15/4/16.
//  Copyright (c) 2015年 jasper. All rights reserved.
//

#import "TMHomeHeaderView.h"
#import "HMBannerView.h"

@interface TMHomeHeaderView()<HMBannerViewDelegate>

@property (nonatomic, strong)HMBannerView *bannerView;

@end
@implementation TMHomeHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

- (void)setupView {
    HMBannerView *bannerView = [[HMBannerView alloc] initWithFrame:CGRectMake(0, 64, UIScreenWidth, TMSacle320WidthHeightToLocal(120)) scrollDirection:ScrollDirectionLandscape images:@[@"banner", @"banner", @"banner"]];
    self.bannerView = bannerView;
    self.bannerView.backgroundColor = [UIColor whiteColor];
    [self.bannerView setRollingDelayTime:4.0];
    [self.bannerView setDelegate:self];
    [self.bannerView setPageControlStyle:PageStyle_Middle];
    [self addSubview:self.bannerView];
    
}

#pragma mark -
#pragma mark HMBannerViewDelegate

- (void)imageCachedDidFinish:(HMBannerView *)bannerView
{
    [bannerView startRolling];
}

- (void)bannerView:(HMBannerView *)bannerView didSelectImageView:(NSInteger)index withData:(NSDictionary *)bannerData
{
    if (_delegate && [_delegate respondsToSelector:@selector(headerView:didSelectedBannerIndex:)]) {
        [_delegate headerView:self didSelectedBannerIndex:index];
    }
}

#pragma mark -
- (CGSize)getViewSize {
    return CGSizeMake(UIScreenWidth, CGRectGetMaxY(self.bannerView.frame));
}
@end
