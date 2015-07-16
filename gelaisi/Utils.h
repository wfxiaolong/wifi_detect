//
//  Utils.h
//  ArpMac
//
//  Created by Evgeniy Kapralov on 17/09/14.
//  Copyright (c) 2014 Kapralos Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UtilDelegate;
@interface Utils : NSObject

@property (nonatomic, weak) id<UtilDelegate>  delegate;
+ (Utils*)shareUtils;

- (NSString*)ipToMac:(NSString*)ipAddress;
- (NSString*)getDefaultGatewayIp;

- (void)getArpDevice;

@end


@protocol UtilDelegate <NSObject>

- (void)utilScanLANDidFindNewAdrress:(NSString *)address havingMactName:(NSString *)macName;
- (void)utilScanLandidFinishScanning;
@end
