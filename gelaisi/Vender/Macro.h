//
//  Header.h
//  zuan
//
//  Created by zhouzhanpeng on 14-5-28.
//  Copyright (c) 2014年 Thousand Earn. All rights reserved.
//

#ifndef TM_Header_h
#define TM_Header_h

#ifdef DEBUG
#define TMLOG(xx, ...) NSLog(@"TM<INFO>: " xx, ##__VA_ARGS__)
#define TMWarning(xx, ...) NSLog(@"TM<Warning>:" xx, ##__VA_ARGS__)
#define TMLOGData(data) TMLOG(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding])
#else
#define TMLOG(xx, ...) ((void)0)
#define TMWarning(xx, ...) ((void)0)
#define TMLOGData(data) ((void)0)
#endif

#define TMAssignSafely(value) (((value) == nil) ? @"" : value)

#define SYSTEM_IOS7 [[UIDevice currentDevice].systemVersion floatValue] >= 7.0
#define NOT_SYSTEM_IOS7 (!(SYSTEM_IOS7))

#define TMTimeIntervalPerMin    60.0f
#define TMTimeIntervalPerHour   (60 * TMTimeIntervalPerMin)
#define TMTimeIntervalPerDay    (24 * TMTimeIntervalPerHour)

#define QiYe        //修改发布方式

#ifdef QiYe
#define QiYeOrAppStore(qiye, appstore) qiye
#endif

#ifdef AppStore
#define QiYeOrAppStore(qiye, appstore) appstore
#endif


/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


/*
 * screen
 */

#define UIScreenWidth [UIScreen mainScreen].bounds.size.width
#define UIScreenHeight [UIScreen mainScreen].bounds.size.height
#define TM320WidthToLocal(width) (UIScreenWidth == 320 ? width : (UIScreenWidth/320 * width))
#define TM568HeightToLocal(width) (UIScreenHeight == 568 ? height : (UIScreenHeight/568 * height))
#define TMSacle320WidthHeightToLocal(height)  (UIScreenWidth == 320 ? height : (UIScreenWidth/320 * height))
#endif  //zuan_Header_h


