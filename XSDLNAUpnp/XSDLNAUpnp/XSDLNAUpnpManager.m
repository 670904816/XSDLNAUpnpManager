//
//  XSDLNAUpnpManager.m
//  YouKu
//
//  Created by OSX on 17/1/20.
//  Copyright © 2017年 OSX. All rights reserved.
//

#import "XSDLNAUpnpManager.h"

@implementation XSDLNAUpnpManager
+ (XSDLNAUpnpManager *)sharedInstance
{
    static XSDLNAUpnpManager *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedInstace = [[self alloc] init];
    });
    return sharedInstace;
}
-(void)startSearch
{
    connectedHost = @"";
    self.devicesArr = [NSMutableArray array];
    searchDevices = [[CLUPnPDevice alloc] init];
    searchDevices.delegate = self;
    [searchDevices search];
}
-(void)stopSearch
{
    [searchDevices stop];
}
#pragma mark CLUPnPDeviceDelegate--设备搜索回调
- (void)upnpSearchResultsWith:(CLUPnPModel *)model{
    if ([self discoverDevices:model]) {
        NSLog(@"发现新设备\n设备名称:%@\nip:%@",model.friendlyName,model.host);
    }
    
}

- (void)upnpSearchErrorWith:(NSError *)error{
    //NSLog(@"error==%@", error);
}

-(BOOL)discoverDevices:(CLUPnPModel*)model
{
    NSUInteger devicesCount = self.devicesArr.count;
    for (NSUInteger index = 0; index < devicesCount; index ++) {
        CLUPnPModel *modeled = self.devicesArr[index];
        if ([modeled.host isEqualToString:model.host]) {
            return NO;
        }
    }
    [self.devicesArr addObject:model];
    return YES;
}

#pragma mark 连接/操作 设备
-(void)connectDevice:(CLUPnPModel*)deviceModel
{
    deviceCtrl = [[CLUPnPRenderer alloc]initWithModel:deviceModel];
    deviceCtrl.delegate = self;
    status = YES;
    connectedHost = deviceModel.host;
    [deviceCtrl getVolume];
}
-(void)sendContentURL:(NSString*)url
{
    [deviceCtrl setAVTransportURL:url];
}
-(void)setNextContentURL:(NSString*)url
{
    [deviceCtrl setNextAVTransportURI:url];
}
-(void)playNext
{
    [deviceCtrl next];
}
-(void)playPrevious
{
    [deviceCtrl previous];
}
-(void)sendStop
{
    [deviceCtrl stop];
}
-(void)setVolume:(NSString*)volume
{
    tvVolume = volume;
    [deviceCtrl setVolumeWith:tvVolume];
}
-(void)getVolume
{
    [deviceCtrl getVolume];
}
-(void)setRate:(BOOL)playState
{
    if (playState) {
        [deviceCtrl play];
    }
    else
    {
        [deviceCtrl pause];
    }
}
-(void)setScrub:(float)seconds
{
//    int hours = seconds / 3600;
//    int minutes = (seconds - hours * 3600) / 60;
//    seconds = (seconds - hours * 3600 - minutes * 60);
//    NSString *seekStr = [NSString stringWithFormat:@"%2d:%2d:%2d",hours,minutes,seconds];
//    [deviceCtrl seekToTarget:seekStr Unit:unitREL_TIME];
    [deviceCtrl seek:seconds];
}
-(void)getPosition
{
    [deviceCtrl getPositionInfo];
}
-(void)getTransport
{
    [deviceCtrl getTransportInfo];
}
-(BOOL)getDeviceStatus
{
    return status;
}
-(NSString*)getDeviceIp
{
    return connectedHost;
}
#pragma mark - CLUPnPResponseDelegate -UPNP回调
- (void)upnpSetAVTransportURIResponse{
    //    [render play];
}

- (void)upnpGetTransportInfoResponse:(CLUPnPTransportInfo *)info{
    //    STOPPED
    //    PAUSED_PLAYBACK
    NSLog(@"%@ === %@", info.currentTransportState, info.currentTransportStatus);
    if (!([info.currentTransportState isEqualToString:@"PLAYING"] || [info.currentTransportState isEqualToString:@"TRANSITIONING"])) {
        [deviceCtrl play];
    }
}

- (void)upnpPlayResponse{
    NSLog(@"播放");
}

- (void)upnpPauseResponse{
    NSLog(@"暂停");
}

- (void)upnpStopResponse{
    NSLog(@"退出");
}

- (void)upnpSeekResponse{
    NSLog(@"跳转完成");
}

- (void)upnpPreviousResponse{
    NSLog(@"前一个");
    [deviceCtrl setAVTransportURL:@""];
}

- (void)upnpNextResponse{
    NSLog(@"下一个");
    [deviceCtrl setAVTransportURL:@""];
}

- (void)upnpSetVolumeResponse{
    NSLog(@"设置音量成功");
}

- (void)upnpSetNextAVTransportURIResponse{
    NSLog(@"设置下一个url成功");
}

- (void)upnpGetVolumeResponse:(NSString *)volume{
    NSLog(@"音量=%@", volume);
    tvVolume = volume;
}

- (void)upnpGetPositionInfoResponse:(CLUPnPAVPositionInfo *)info{
    NSLog(@"%f, === %f === %f", info.trackDuration, info.absTime, info.relTime);
}

- (void)upnpUndefinedResponse:(NSString *)xmlString{
    NSLog(@"xmlString = %@", xmlString);
}

@end
