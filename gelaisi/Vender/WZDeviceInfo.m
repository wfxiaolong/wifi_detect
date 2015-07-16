//
//  WZDeviceInfo.m
//  zuan
//
//  Created by zhouzhanpeng on 14-7-29.
//  Copyright (c) 2014年 Thousand Earn. All rights reserved.
//

#import "WZDeviceInfo.h"

#import <sys/socket.h>
#import <sys/utsname.h>
#import <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <dlfcn.h>

#import "SSKeychain.h"
//#import <AdSupport/AdSupport.h>


static NSString* GetSysInfoByName(char *typeSpecifier) {
	size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
	sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    NSString *results = [NSString stringWithUTF8String:answer];
	free(answer);
	return results;
}

static NSUInteger GetSysInfo(uint typeSpecifier) {
	size_t size = sizeof(int);
	int results;
	int mib[2] = {CTL_HW, typeSpecifier};
	sysctl(mib, 2, &results, &size, NULL, 0);
	return (NSUInteger) results;
}

@implementation WZDeviceInfo

+ (WZDeviceInfo *)sharedInstance {
    static WZDeviceInfo *shareDeviceInfo = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareDeviceInfo = [[WZDeviceInfo alloc] init];
    });
    return shareDeviceInfo;
}

#pragma mark -
#pragma mark 初始化

#pragma mark -
#pragma mark Static Methods
+ (NSString *)MAC_ADDR {
    int                 mib[6];
	size_t              len;
	char                *buf;
	unsigned char       *ptr;
	struct if_msghdr    *ifm;
	struct sockaddr_dl  *sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		NSLog(@"Error: if_nametoindex error\n");
		return NULL;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		NSLog(@"Error: sysctl, take 1\n");
		return NULL;
	}
	
	if ((buf = malloc(len)) == NULL) {
		NSLog(@"Could not allocate memory. error!\n");
		return NULL;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
		NSLog(@"Error: sysctl, take 2");
        free(buf);
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	NSString *macAddress = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X",
                            *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	macAddress = [macAddress lowercaseString];
	free(buf);
	
	return macAddress;
}

+ (BOOL)isSimulator {
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

+ (BOOL)isDevice {
    return ![self isSimulator];
}

+ (BOOL)isIPhoneSimulator {
	return [self isSimulator] && [self isPhoneUI];
}

+ (BOOL)isIPadSimulator {
    return [self isSimulator] && [self isPadUI];
}

+ (BOOL)isIPhoneOrIPodTouch {
    return [self isIPhone] || [self isIPodTouch];
}

+ (BOOL)isIPhone {
    NSString *platform = [self platform];
    if (CFStringFind((CFStringRef)platform, (CFStringRef)@"iPhone", kCFCompareCaseInsensitive).length > 0) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isIPodTouch {
    NSString *platform = [self platform];
    if (CFStringFind((CFStringRef)platform, (CFStringRef)@"iPod", kCFCompareCaseInsensitive).length > 0) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isIPad {
    NSString *platform = [self platform];
    if (CFStringFind((CFStringRef)platform, (CFStringRef)@"iPad", kCFCompareCaseInsensitive).length > 0) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isPadUI {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
}

+ (BOOL)isPhoneUI {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isRetina {
	return ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2);
}

+ (BOOL)isMultitaskingSupported {
	BOOL multiTaskingSupported = NO; // 没必要判断的了，留着吧
	if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
		multiTaskingSupported = [(id)[UIDevice currentDevice] isMultitaskingSupported];
	}
	return multiTaskingSupported;
}

+ (BOOL)isJailbroken {
#if TARGET_IPHONE_SIMULATOR
    return NO;
    
#else
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia:"]]) {
        return YES;
    }
    
    BOOL isJailbroken = NO;
    
    FILE *f = fopen("/bin/bash", "r");
    
    if (!(errno == ENOENT)) {
        isJailbroken = YES;
    }
    fclose(f);
    return isJailbroken;
#endif
}

+ (NSString *)countryCode {
	NSLocale *locale = [NSLocale currentLocale];
	NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    return countryCode;
}

+ (NSString *)language {
	NSString *language;
    NSLocale *locale = [NSLocale currentLocale];
	if ([[NSLocale preferredLanguages] count] > 0) {
        language = [[NSLocale preferredLanguages]objectAtIndex:0];
	} else {
		language = [locale objectForKey:NSLocaleLanguageCode];
	}
	
    return language;
}

+ (NSInteger)systemMainVersion {
    return [[[UIDevice currentDevice] systemVersion] intValue];
}

+ (NSString *)platform {
	return GetSysInfoByName("hw.machine");
}

+ (NSString *)hwmodel {
	return GetSysInfoByName("hw.model");
}

+ (NSUInteger)cpuFrequency {
	return GetSysInfo(HW_CPU_FREQ);
}

+ (NSUInteger)busFrequency {
	return GetSysInfo(HW_BUS_FREQ);
}

+ (NSUInteger)totalMemory {
	return GetSysInfo(HW_PHYSMEM);
}

+ (NSUInteger)userMemory {
	return GetSysInfo(HW_USERMEM);
}

+ (NSUInteger)maxSocketBufferSize {
	return GetSysInfo(KIPC_MAXSOCKBUF);
}

+ (NSNumber *)totalDiskSpace {
	NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

+ (NSNumber *)freeDiskSpace {
	NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}


//+ (NSString*)idfa {
//    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//}

+ (NSString*)idfv {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString*)serNumber {
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        return nil;
    }
    
    NSString *serialNumber = nil;
    
//    void *IOKit = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit", RTLD_NOW);
//    if (IOKit)
//    {
//        mach_port_t *kIOMasterPortDefault = dlsym(IOKit, "kIOMasterPortDefault");
//        CFMutableDictionaryRef (*IOServiceMatching)(const char *name) = dlsym(IOKit, "IOServiceMatching");
//        mach_port_t (*IOServiceGetMatchingService)(mach_port_t masterPort, CFDictionaryRef matching) = dlsym(IOKit, "IOServiceGetMatchingService");
//        CFTypeRef (*IORegistryEntryCreateCFProperty)(mach_port_t entry, CFStringRef key, CFAllocatorRef allocator, uint32_t options) = dlsym(IOKit, "IORegistryEntryCreateCFProperty");
//        kern_return_t (*IOObjectRelease)(mach_port_t object) = dlsym(IOKit, "IOObjectRelease");
//        
//        if (kIOMasterPortDefault && IOServiceGetMatchingService && IORegistryEntryCreateCFProperty && IOObjectRelease)
//        {
//            mach_port_t platformExpertDevice = IOServiceGetMatchingService(*kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
//            if (platformExpertDevice)
//            {
//                CFTypeRef platformSerialNumber = IORegistryEntryCreateCFProperty(platformExpertDevice, CFSTR("IOPlatformSerialNumber"), kCFAllocatorDefault, 0);
//                if (CFGetTypeID(platformSerialNumber) == CFStringGetTypeID())
//                {
//                    serialNumber = [NSString stringWithString:(__bridge NSString*)platformSerialNumber];
//                    CFRelease(platformSerialNumber);
//                }
//                IOObjectRelease(platformExpertDevice);
//            }
//        }
//        dlclose(IOKit);
//    }
    
    return serialNumber;
}

#define kKCServiceDevice @"com.xiaolong.technology"
#define kKCCustomIdfa   @"custom_idfa"

+ (NSString*)customIdfa {
    NSString *customIdfa = [SSKeychain passwordForService:kKCServiceDevice account:kKCCustomIdfa];
    if ( customIdfa == nil ) {
        customIdfa = [[self class] stringWithUUID];
        [SSKeychain setPassword:customIdfa forService:kKCServiceDevice account:kKCCustomIdfa];
    }
    return customIdfa;
}

+ (NSString*)stringWithUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;//[uuidString autorelease];
}
@end
