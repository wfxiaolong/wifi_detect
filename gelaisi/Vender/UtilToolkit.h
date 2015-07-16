//
//  UtilToolkit.h
//  zuan
//
//  Created by zhouzhanpeng on 14-6-5.
//  Copyright (c) 2014年 Thousand Earn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TM_LightGreen   = 0,
    TM_DarkGreen,
    TM_Green,
    
    TM_DarkGray,
    TM_GrayWhite,
    TM_LightGray,
    
    TM_DarkRed,
    TM_LightRed,
    TM_Red,
    
    TM_BlackOne,
    TM_BlackTwo,
    TM_Black,
    
    TM_LightYellow,
    TM_DarkYellow,
    
    // add v2.3
    TM_Blue,
    
    // add v3.0
    TG_Red,
    
    TG_Dark_1,
    TG_Dark_2,
    
    TG_Light_1,
    TG_Light_2,
    TG_Light_3,
    TG_Light_4,
    
    // add baoyi
    TM_Orange_1,
    
} TM_COLOR;

#ifndef TMUtil
#define TMUtil

#define TMCOLOR(color) [UtilToolkit customColor:color]
#define TMCOLORFROMSTRING(str) [UtilToolkit colorFromARGBString:str]
#define TMCOLORFROMSTRINGSimple(str) TMCOLORFROMSTRING([@"#ff" stringByAppendingString:str])

#define TMDrawLine(frompoint,topoint,color,width) [UtilToolkit drawLine:frompoint toPoint:topoint withColor:color withWidth:width];

#define TMAddConstraint(view,size) [UtilToolkit addConstraintToView:view withSize:size];
#define TMAddConstraintAlignToSuperView(view,attri,value) [UtilToolkit addConstraintAlignToSuperView:view withAttribute:attri withValue:value];
#define TMAddConstraintAlignToSuperViewZero(view,attri) TMAddConstraintAlignToSuperView(view,attri,0.0f)

#define TMAddConstraintAlignToCenter(view)  \
    TMAddConstraintAlignToSuperViewZero(view, NSLayoutAttributeCenterX); \
    TMAddConstraintAlignToSuperViewZero(view, NSLayoutAttributeCenterY);

#define TMUIImageWithColor(color,size)      [UtilToolkit imageWithColor:color withSize:size]

#define TMSaveObjInUserDefault(key,obj)     [UtilToolkit saveObjectInUserDefault:obj withKey:key]
#define TMObjInUserDefault(key)             [UtilToolkit objectInUserDefaultWithKey:key]
#define TMRemoveObjFromUserDefault(key)     [UtilToolkit removeObjectFromUserDefault:key]

#define TMBitAnd(One,Two)       (One & Two)
#define TMBitOr(One,Two)        (One | Two)
#define TMBitXor(One,Two)       (One ^ Two)
#define TMBitSetFalse(One,Two)  ((~Two) & One)
#define TMBitSetTrue(One,Two)   (One | Two)

#define TMInt2NSString(value)       [NSString stringWithFormat:@"%ld", (long)(value)]
#define TMIntNumber2NSString(value) [NSString stringWithFormat:@"%ld", (long)[value integerValue]]
#define TMUInt2NSString(value)      [NSString stringWithFormat:@"%lu",(unsigned long)value]

#define TMTopViewController         [UtilToolkit topViewController]

#define TMISValidPhoneNumber(phone)         [UtilToolkit isValidPhoneNumber:phone]
#endif //TMUtil


@interface UtilToolkit : NSObject
/**将字符串转化为COLOR
 *#实现：传入字符串，根据ARGB四个通道，每两个字符代表一个通道数值(16进制)
 *#注意：
 *##1.所传入字符串必须大于8
 *##2.注意字符串中数值顺序 ARGB
 *#eg: #11223344 A:11(17) R:22(34) G:33(51) B:44(68)
 */
+ (UIColor *)colorFromARGBString:(NSString *)argbString;

/**将传入COLOR转化为字符串
 *#实现:参考上面
 */
+ (NSString *)ARGBStringFromColor:(UIColor *)color;

///将16进制字符转化为10进制整数
+ (NSInteger)integerFromHexChar:(char)c;

+ (UIColor*)customColor:(TM_COLOR)color;

/**
 *绘制直线--请在drawrect里面使用
 */
+ (void)drawLine:(CGPoint)fromPoint toPoint:(CGPoint)toPoint withColor:(CGColorRef)color withWidth:(CGFloat)width;

/**
 *返回一张纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size;

/**
 *constraint
 */
+ (void)addConstraintToView:(UIView*)view withSize:(CGSize)size;
+ (void)addConstraintAlignToSuperView:(UIView*)view withAttribute:(NSLayoutAttribute)attribute withValue:(CGFloat)value;

/**
 *userdefault
 */
+ (id)objectInUserDefaultWithKey:(NSString*)key;
+ (void)saveObjectInUserDefault:(id)obj withKey:(NSString*)key;
+ (void)removeObjectFromUserDefault:(NSString*)key;

/**
 *top viewcontroller
 */
+ (UIViewController*)topViewController;

+ (BOOL)isValidPhoneNumber:(NSString*)phone;
@end

NSString* GetDistributionKind();
