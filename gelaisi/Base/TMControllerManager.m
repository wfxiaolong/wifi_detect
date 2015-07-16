//
//  TMControllerManager.m
//  TryGood
//
//  Created by zhouzhanpeng on 14-9-3.
//  Copyright (c) 2014年 youmi. All rights reserved.
//

#import "TMControllerManager.h"
#import "TMNavigationController.h"
#import "TMMenuViewController.h"
#import "TMHomeController.h"

@interface TMControllerManager()<REFrostedViewControllerDelegate>

@property (nonatomic, strong)UIViewController   *_rootViewController;

@end
@implementation TMControllerManager

+ (TMControllerManager*)shareMgr {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)setupRootViewController {
    TMHomeController *homeController = [[TMHomeController alloc]init];
    homeController.title = @"gelaisi";
    TMNavigationController *nav = [[TMNavigationController alloc]initWithRootViewController:homeController];
    
    TMMenuViewController *menuController = [[TMMenuViewController alloc] init];
    
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:nav menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.delegate = self;
    frostedViewController.menuViewSize = CGSizeMake(250, UIScreenHeight);
    
    self._rootViewController = frostedViewController;
}

- (UIViewController*)rootController {
    if (!self._rootViewController) {
        [self setupRootViewController];
    }
    return self._rootViewController;
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController");
}
@end
