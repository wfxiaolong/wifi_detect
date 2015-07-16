//
//  TMHomeHeaderView.h
//  Jingtemai
//
//  Created by Jasper on 15/4/16.
//  Copyright (c) 2015年 jasper. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TMHomeHeaderViewDelegate;

@interface TMHomeHeaderView : UIView

@property (nonatomic, weak) id<TMHomeHeaderViewDelegate> delegate;
@property (nonatomic, strong)   NSArray    *bannerData;

- (CGSize)getViewSize;
@end


@protocol TMHomeHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(TMHomeHeaderView*)headerView didSelectedBannerIndex:(NSInteger)index;
@end