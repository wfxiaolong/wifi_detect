//
//  UtilToolkit.m
//  zuan
//
//  Created by zhouzhanpeng on 14-6-5.
//  Copyright (c) 2014年 Thousand Earn. All rights reserved.
//

#import "UtilToolkit.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation UtilToolkit

+ (UIColor *)colorFromARGBString:(NSString *)argbString {
    if (argbString.length < 8) return nil;
    argbString = [argbString lowercaseString];
    const char *c_str = [argbString cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned int len = (unsigned int)strlen(c_str);
    
    double ia = [self integerFromHexChar:c_str[len-8]] * 16 + [self integerFromHexChar:c_str[len-7]];
    float a = ia / 255.0;
    
    double ir = [self integerFromHexChar:c_str[len-6]] * 16 + [self integerFromHexChar:c_str[len-5]];
    float r = ir / 255.0;
    
    double ig = [self integerFromHexChar:c_str[len-4]] * 16 + [self integerFromHexChar:c_str[len-3]];
    float g = ig / 255.0;
    
    double ib = [self integerFromHexChar:c_str[len-2]] * 16 + [self integerFromHexChar:c_str[len-1]];
    float b = ib / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (NSString *)ARGBStringFromColor:(UIColor *)color {
    CGFloat a = 0.0, r = 0.0, g = 0.0, b = 0.0;
    [color getRed:&r green:&g blue:&b alpha:&a];
    unsigned int ia = (int)(a * 255);
    unsigned int ir = (int)(r * 255);
    unsigned int ig = (int)(g * 255);
    unsigned int ib = (int)(b * 255);
    
    
    int64_t argb = ia;
    argb = argb << 24;
    argb = argb | (ir << 16) | (ig << 8) | ib;
    
    return [NSString stringWithFormat:@"#%08llx", argb];
}

+ (NSInteger)integerFromHexChar:(char)c {
    c = 0x20 | c; // lowercase
    int res = c - '0';
    if (res < 10) return res;
    return ((c - 'a') + 10);
}

+ (UIColor*)customColor:(TM_COLOR)color {
    switch (color) {

        case TM_LightGreen:
            return TMCOLORFROMSTRINGSimple(@"a1d53c");
        case TM_DarkGreen:
            return TMCOLORFROMSTRINGSimple(@"5dbc24");
        case TM_Green:
            return TMCOLORFROMSTRINGSimple(@"81cd28");
            
        case TM_DarkGray:
            return TMCOLORFROMSTRINGSimple(@"99999f");
        case TM_GrayWhite:
            return TMCOLORFROMSTRINGSimple(@"f5f5f5");
        case TM_LightGray:
            return TMCOLORFROMSTRINGSimple(@"e2e1e6");
            
        case TM_DarkRed:
            return TMCOLORFROMSTRINGSimple(@"db3054");
        case TM_LightRed:
            return TMCOLORFROMSTRINGSimple(@"fc5265");
        case TM_Red:
            return TMCOLORFROMSTRINGSimple(@"f14062");
            
        case TM_BlackOne:
            return TMCOLORFROMSTRINGSimple(@"61616d");
        case TM_BlackTwo:
            return TMCOLORFROMSTRINGSimple(@"666672");
        case TM_Black:
            return TMCOLORFROMSTRINGSimple(@"000444");
            
        case TM_DarkYellow:
            return TMCOLORFROMSTRINGSimple(@"ff9018");
        case TM_LightYellow:
            return TMCOLORFROMSTRINGSimple(@"ffcc00");
            
        case TM_Blue:
            return TMCOLORFROMSTRINGSimple(@"3293d1");
        
        // v3.0.0
        case TG_Red:
            return TMCOLORFROMSTRINGSimple(@"e5131a");
        case TG_Dark_1:
            return TMCOLORFROMSTRINGSimple(@"111111");
        case TG_Dark_2:
            return TMCOLORFROMSTRINGSimple(@"333333");
        case TG_Light_1:
            return TMCOLORFROMSTRINGSimple(@"f0f3f5");
        case TG_Light_2:
            return TMCOLORFROMSTRINGSimple(@"e2e1e6");
        case TG_Light_3:
            return TMCOLORFROMSTRINGSimple(@"99999f");
        case TG_Light_4:
            return TMCOLORFROMSTRINGSimple(@"d2d1d6");
        
        // baoyi
        case TM_Orange_1:
            return TMCOLORFROMSTRINGSimple(@"f18c19");
            
        default:
            break;
    }
}

+ (void)drawLine:(CGPoint)fromPoint toPoint:(CGPoint)toPoint withColor:(CGColorRef)color withWidth:(CGFloat)width {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        CGContextSetLineWidth(context, width);
        CGContextSetStrokeColorWithColor(context, color);
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
}

+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)addConstraintToView:(UIView*)view withSize:(CGSize)size {
    if (size.width != 0) {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size.width]];
    }
    if (size.height != 0) {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size.height]];
    }
}

+ (void)addConstraintAlignToSuperView:(UIView*)view withAttribute:(NSLayoutAttribute)attribute withValue:(CGFloat)value {
    [view.superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:attribute multiplier:1.0 constant:value]];
}

#pragma mark - 
+ (id)objectInUserDefaultWithKey:(NSString*)key {
    NSData  *dData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (dData) {
        @try {
            id obj = [NSKeyedUnarchiver unarchiveObjectWithData:dData];
            return obj;
        }
        @catch(NSException *exception) {
            TMWarning(@"objectInUserDefaultWithKey Error:%@",exception);
        }
    }
    return nil;
}

+ (void)saveObjectInUserDefault:(id)obj withKey:(NSString*)key {
    @try {
        NSData  *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    @catch(NSException *exception) {
        TMWarning(@"saveObjectInUserDefault Error:%@",exception);
    }
}

+ (void)removeObjectFromUserDefault:(NSString*)key {
    @try {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    @catch(NSException *exception) {
        TMWarning(@"removeObjectFromUserDefault Error:%@",exception);
    }
}


#pragma mark -

+ (UIViewController*)topViewController {
    return [UtilToolkit topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [UtilToolkit topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [UtilToolkit topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [UtilToolkit topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

#pragma mark -
+ (BOOL)isValidPhoneNumber:(NSString*)phone {
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}
@end


NSString* GetDistributionKind() {
    NSBundle *xBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"a" ofType:@"bundle"]];
//    NSBundle *xBundle = [NSBundle mainBundle];
    NSString *infoPath = [xBundle pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:infoPath];

    NSString *distributionKind = dict[@"Distribution"];
    return distributionKind;
}
