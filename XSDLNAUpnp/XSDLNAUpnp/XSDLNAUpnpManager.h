//
//  XSDLNAUpnpManager.h
//  YouKu
//
//  Created by OSX on 17/1/20.
//  Copyright © 2017年 OSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUPnP.h"
@interface XSDLNAUpnpManager : NSObject<CLUPnPDeviceDelegate,CLUPnPResponseDelegate>
{
    CLUPnPDevice *searchDevices;
    CLUPnPRenderer *deviceCtrl;
    NSString *tvVolume;
    BOOL status;
    NSString *connectedHost;
}
@property(nonatomic,strong)NSMutableArray *devicesArr;
+ (XSDLNAUpnpManager *)sharedInstance;
-(void)startSearch;
-(void)stopSearch;
-(void)connectDevice:(CLUPnPModel*)deviceModel;
-(void)sendContentURL:(NSString*)url;
-(void)setNextContentURL:(NSString*)url;
-(void)playNext;
-(void)playPrevious;
-(void)sendStop;
-(void)setVolume:(NSString*)volume;
-(void)getVolume;
-(void)setRate:(BOOL)playState;
-(void)setScrub:(float)seconds;
-(void)getPosition;
-(void)getTransport;
-(BOOL)getDeviceStatus;
-(NSString*)getDeviceIp;
@end
