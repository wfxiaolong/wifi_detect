//
//  AppDelegate.m
//  gelaisi
//
//  Created by lxlong on 15/7/13.
//  Copyright (c) 2015年 lxlong. All rights reserved.
//

#import "AppDelegate.h"
#import "WZDeviceInfo.h"
#import "UMSocial.h"
#import "MobClick.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

#import "TMControllerManager.h"

#define MobClickKey @"5594ff8167e58ee8f20006d9"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#ifndef DEBUG
    [self mobTouch];
    [self umTrack];
#endif
    
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [TMControllerManager shareMgr].rootController;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - um click
- (void)mobTouch {
    /// 友盟数据分析
    NSString *distributionKind = GetDistributionKind();
    [MobClick startWithAppkey:MobClickKey reportPolicy:SEND_INTERVAL channelId:distributionKind];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    /// 友盟分享平台
    [UMSocialData setAppKey:MobClickKey];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wxf749f8afa615469c" appSecret:@"D5Vi98YW2SxtblWz" url:@"http://www.umeng.com/social"];
    
    //设置手机QQ的AppId，指定你的分享url，若传nil，将使用友盟的网址
    [UMSocialQQHandler setQQWithAppId:@"1104631749" appKey:@"D5Vi98YW2SxtblWz" url:@"http://www.umeng.com/social"];
    
}

#pragma mark -
- (void)umTrack {
    NSString * appKey = MobClickKey;
    NSString * deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * mac = [WZDeviceInfo MAC_ADDR];
    NSString * idfa = [WZDeviceInfo customIdfa];
    NSString * idfv = [WZDeviceInfo idfv];
    NSString * urlString = [NSString stringWithFormat:@"http://log.umtrack.com/ping/%@/?devicename=%@&mac=%@&idfa=%@&idfv=%@", appKey, deviceName, mac, idfa, idfv];
    TMLOG(@"%@", urlString);
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:urlString]] delegate:nil];
}

@end
