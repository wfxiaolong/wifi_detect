//
//  TMControllerManager.h
//  TryGood
//
//  Created by zhouzhanpeng on 14-9-3.
//  Copyright (c) 2014年 youmi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "REFrostedViewController.h"
@interface TMControllerManager : NSObject

+ (TMControllerManager*)shareMgr;

- (UIViewController*)rootController;

@end
