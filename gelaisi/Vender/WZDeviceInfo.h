//
//  WZDeviceInfo.h
//  zuan
//
//  Created by zhouzhanpeng on 14-7-29.
//  Copyright (c) 2014年 Thousand Earn. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <UIKit/UIKit.h>
enum {
    YMLDeviceAttributeNone               = 0,
    YMLDeviceAttributeCanMakeTelephone   = 1 << 0,
    YMLDeviceAttributeCanSendMessage     = 1 << 1,
    YMLDeviceAttributeCanGetLocation     = 1 << 2,
    YMLDeviceAttributeCanUseWiFi         = 1 << 3,
    YMLDeviceAttributeIsPad              = 1 << 4,
    YMLDeviceAttributeIsPhoneUI          = 1 << 5,
    YMLDeviceAttributeIsJailbroken       = 1 << 6,
    YMLDeviceAttributeIsIfaOpen          = 1 << 7,
};
typedef NSUInteger YMLDeviceAttribute;


@interface WZDeviceInfo : NSObject

@property(nonatomic, readonly)  NSUInteger  attribute;

@property(nonatomic, copy, readonly)    NSString *UDID;
@property(nonatomic, copy, readonly)    NSString *MAC_ADDR;
@property(nonatomic, copy, readonly)    NSString *IFA;
@property(nonatomic, copy, readonly)    NSString *originIFA;            // 原始的IFA，因为IFA会变，需要知道设备的IFA有没有改动
@property(nonatomic, assign, readonly)  BOOL    isIfaOpen;
@property(nonatomic, copy, readonly)    NSString *openIDFA;

@property(nonatomic, copy, readonly)    NSString *CID;

@property(nonatomic, copy, readonly)    NSString *device;               // ex. iPod 2,1
@property(nonatomic, copy, readonly)    NSString *deviceDetail;         //
@property(nonatomic, copy, readonly)    NSString *phoneOS;              // ex. iOS 6.1.2
@property(nonatomic, copy, readonly)    NSString *countryCode;          // ex. CN
@property(nonatomic, copy, readonly)    NSString *language;             // ex. zh

@property(nonatomic, copy, readonly)    NSString *accessPointName;      // ex. wifi, GPRS|3G


@property(nonatomic, assign, readonly)  CGFloat screenWidth;
@property(nonatomic, assign, readonly)  CGFloat screenHeight;

@property(nonatomic, copy, readonly)    NSString *carrierName;
@property(nonatomic, copy, readonly)    NSString *carrierNameNew;       // 1：移动，中国移动，CHINA MOBILE 2：联通，中国联通，China Unicom 3：电信，中国电信，China Telecom
@property(nonatomic, copy, readonly)    NSString *mobileCountryCode;
@property(nonatomic, copy, readonly)    NSString *mobileNetworkCode;


// deprecated
@property(nonatomic, copy, readonly)    NSString *IMEI;                 // 等于UDID
@property(nonatomic, copy, readonly)    NSString *BD_ADDR;              // 等于MAC
@property(nonatomic, copy, readonly)    NSString *IMSI;                 // 没有， 默认""
@property(nonatomic, copy, readonly)    NSString *SMSCenterNumber;      // 不获取默认 ""
@property(nonatomic, copy, readonly)    NSString *deviceVendor;         // 没意义
@property(nonatomic, copy, readonly)    NSString *registrationCellId;   // 不获取默认 ""
@property(nonatomic, copy, readonly)    NSString *registrationCellLac;  // 不获取默认 ""
@property(nonatomic, copy, readonly)    NSString *deprecatedCID;        // 旧的Banner要用


// Single instance
+ (WZDeviceInfo *)sharedInstance;

+ (NSString *)MAC_ADDR;
+ (NSString*)serNumber;

+ (BOOL)isSimulator;
+ (BOOL)isIPhoneSimulator;
+ (BOOL)isIPadSimulator;
+ (BOOL)isDevice;
+ (BOOL)isIPhoneOrIPodTouch;
+ (BOOL)isIPhone;
+ (BOOL)isIPodTouch;
+ (BOOL)isIPad;
+ (BOOL)isPadUI;    // 包括iPad 和 iPad模拟器
+ (BOOL)isPhoneUI;  // 包括iPhone， iPode 以及 iPhone模拟器
+ (BOOL)isRetina;
+ (BOOL)isMultitaskingSupported;
+ (BOOL)isJailbroken;

+ (NSString *)countryCode;
+ (NSString *)language;

+ (NSInteger)systemMainVersion;
+ (NSString *)platform;
+ (NSString *)hwmodel;  // maybe 可以去掉

+ (NSUInteger)cpuFrequency;
+ (NSUInteger)busFrequency;
+ (NSUInteger)totalMemory;
+ (NSUInteger)userMemory;
+ (NSUInteger)maxSocketBufferSize;
+ (NSNumber *)totalDiskSpace;
+ (NSNumber *)freeDiskSpace;
//+ (NSString*)idfa;
+ (NSString*)idfv;


+ (NSString*)customIdfa;
+ (NSString*)stringWithUUID;    //change everytime
@end
