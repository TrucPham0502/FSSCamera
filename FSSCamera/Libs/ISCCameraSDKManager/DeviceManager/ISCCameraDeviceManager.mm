//
//  ISCCameraDeviceManager.m
//  FunSDKDemo
//
//  Created by Pham Chi Hieu on 10/25/19.
//  Copyright © 2019 Pham Chi Hieu. All rights reserved.
//

#import "ISCCameraDeviceManager.h"
#import "DeviceManager.h"
#import "DeviceControl.h"
#import "CloudVideoConfig.h"
#import "AlarmManager.h"

@interface ISCCameraDeviceManager ()<DeviceManagerDelegate, CloudVideoTimeDelegate> {
    DeviceManager *deviceManager;
    CloudVideoConfig *videoConfig;
    
}
@end

@implementation ISCCameraDeviceManager

NSTimer *_timer;
int _timeSearch;
BOOL _config;
BOOL _isSearching;

static ISCCameraDeviceManager *shareManager;
+ (ISCCameraDeviceManager * )shared {
    return shareManager ? shareManager : [[ISCCameraDeviceManager alloc]init];
}
- (id)init{
    static dispatch_once_t once;
    dispatch_once(&once ,^{
        shareManager = self;
    });
    
    deviceManager = [DeviceManager getInstance];
    deviceManager.delegate = self;
    self = shareManager;
    return self;
}
- (void)initServerAlam: (NSString *)token {
    [[AlarmManager getInstance] initServer:SZSTR(token)];
}

- (void)initDelegateVideoConfig {

    videoConfig = [[CloudVideoConfig alloc] init];
    videoConfig.timeDelegate = self;
}

-(void)getdeviceState:(NSString*)deviceMac {
    //刷新读取到的设备状态
    if ([deviceMac isEqualToString:@""]){
        [deviceManager getDeviceState:nil];
    }else {
        [deviceManager getDeviceState:deviceMac];
    }
}

- (void)getDeviceState:(NSString *)sId result:(int)result {
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(getDeviceState:result:)]) {
        [self.delegate getDeviceState:sId result:result];
    }
}

- (void)getDeviceStateV2:(NSString *)sId result:(int)result {
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(getDeviceStateV2:result:)]) {
        [self.delegate getDeviceStateV2:sId result:result];
    }
    if (_cameraStatus) {
        _cameraStatus(sId, result);
    }
    
}

- (void)addDeviceByDeviseSerialnumber:(NSString*)serialNumber deviceName:(NSString *)deviceName devType:(int)type seq:(int)seq {
    [deviceManager addDeviceByDeviseSerialnumber:serialNumber deviceName:deviceName devType:type seq:seq];
}

- (void)deleteDeviceWithDevMac:(NSString *)devMac {
    [deviceManager deleteDeviceWithDevMac:devMac];
}
- (void)logoutDevice:(NSString *)devMac{
    [deviceManager logoutDevice:devMac];
}
- (NSMutableArray*)currentDeviceArray {
    return [[DeviceControl getInstance] currentDeviceArray];
}

- (void)clearDeviceArray {
    return [[DeviceControl getInstance] clearDeviceArray];
}

- (void)changeDevicePsw:(NSString *)devMac loginName:(NSString *)name password:(NSString *)psw {
    [deviceManager changeDevicePsw:devMac loginName:name password:psw];
}

- (void)getDeviceChannel:(NSString *)devMac seq:(int)seq{
    [deviceManager getDeviceChannel:devMac seq:seq];
}

- (void)cleanSelectChannel {
    [[DeviceControl getInstance]cleanSelectChannel];
}

- (nullable DeviceObject *)GetDeviceObjectBySN:(NSString *)devSN {
    DeviceObject *device = [[DeviceControl getInstance] GetDeviceObjectBySN:devSN];
    if(device != NULL){
        return device;
    }
    return nil;
}

- (void)setSelectChannel:(ChannelObject *)channel {
     [[DeviceControl getInstance] setSelectChannel:channel];
}
    
- (void)LinkAlarm:(NSString *)deviceMac DeviceName:(NSString *)devName Username:(NSString *)username Password:(NSString *)password {
    [[AlarmManager getInstance] LinkAlarmPush:deviceMac DeviceName:devName Username:username Password:password];
}

-(void)startConfigWithSSID:(NSString*)ssid password:(NSString*)password  timeout:(int) timeOut {
    [self stopConfig];
    if (_timer != nil) {
        [_timer invalidate];
    }
    _timer = nil;
    if (ssid.length == 0 && password.length == 0) {
        if (self.delegate &&  [self.delegate respondsToSelector:@selector(errorQuickConfiguration:)]) {
            [self.delegate errorQuickConfiguration:@"ERROR_WLAN_INFO"];
        }
        return;
    }
    _isSearching = YES;
    _timeSearch = timeOut;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown:) userInfo:nil repeats:YES];
    [deviceManager startConfigWithSSID:ssid password:password];
}

-(void)stopConfig {
    [deviceManager stopConfig];
    if (_timer != nil) {
        [_timer invalidate];
    }
}

- (NSString *)devThumbnailFile:(NSString*)devId andChannle:(int)channle{
    NSString *devThumbnailFile = [NSString devThumbnailFile:devId andChannle:channle];
    return devThumbnailFile;
}

-(void)countdown:(NSTimer*)timer{
    if (_isSearching == NO ) {
        return;
    }
    _timeSearch = _timeSearch - 1;
    if (_timeSearch >= 0) {
        _config = YES;
    }else{
        _config = NO;
    }
    if (_timeSearch < 0) {
        [timer invalidate];
        if (self.delegate &&  [self.delegate respondsToSelector:@selector(errorQuickConfiguration:)]) {
            [self.delegate errorQuickConfiguration:@"ERROR_WLAN_INFO"];
        }
    }
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(countdown:)]) {
        [self.delegate countdown:_timeSearch];
    }
}

- (NSMutableArray*)getVideoTimeArray {
    return [videoConfig getVideoTimeArray];
}
    
- (NSMutableArray*)getVideoArray {
    return [videoConfig getVideoArray];
}

- (void)addDeviceResult:(NSString *)sId result:(int)result seq:(int)seq{
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(addDeviceResult:result:seq:)]) {
        [self.delegate addDeviceResult:sId result:result seq:seq];
    }
    
}
- (void)deleteDevice:(NSString *)sId result:(int)result {
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(deleteDevice:result:)]) {
        [self.delegate deleteDevice:sId result:result];
    }
}

- (void)getDeviceChannel:(NSString *)sId result:(int)result seq:(int)seq{
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(getDeviceChannel:result:seq:)]) {
        [self.delegate getDeviceChannel:sId result:result seq:seq];
    }
}

- (void)quickConfiguration:(id)device result:(int)resurt {
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(quickConfiguration:result:)]) {
        [self.delegate quickConfiguration:device result:resurt];
    }
}

- (void)changeDevice:(NSString *)sId changedResult:(int)result {
    
}

- (void)setConfigByJson: (NSString *)serial strConfigName:(NSString *)name strJsonConfig:(NSString *) config{
    [deviceManager setConfigByJson:serial strConfigName:name strJsonConfig:config];
}

- (void)setConfigByJson: (int)errorCode{
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(setConfigByJson:)]) {
        [self.delegate setConfigByJson:errorCode];
    }
}

- (void)searchDevice{
    [deviceManager SearchDevice];
}

#pragma lamnhs callback search device
- (void)searchDevice:(NSMutableArray*)searchArray result:(int)result{
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(searchDevice:result:)]) {
        [self.delegate searchDevice:searchArray result:result];
    }
}

#pragma mark - 开始快速配置
-(void)startConfigWifiByAPMode:(NSString*)userName userPassword:(NSString*)userPassword ssid:(NSString*)ssid password:(NSString*)password{
    [deviceManager startConfigWifiByAPMode:userName userPassword:userPassword ssid:ssid password:password];
}

- (void)startConfigWifiAPModeTimer:(int)timeOut {
    [self stopConfig];
    if (_timer != nil) {
        [_timer invalidate];
    }
    _timer = nil;
    _isSearching = YES;
    _timeSearch = timeOut;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown:) userInfo:nil repeats:YES];
}

//- (void)loginDevice:
//            (NSString *)serial
//         deviceName:(NSString *)deviceName
//           userName:(NSString *)userName
//           password:(NSString *)password
//            deviceType:(int)deviceType
//                seq:(int)seq
//{
//    if ([self GetDeviceObjectBySN:serial] != NULL){
//        [self changeDevicePsw:serial loginName:userName password:password];
//        [self getDeviceChannel:serial seq:seq];
//    }else{
//        [self addDeviceByDeviseSerialnumber:serial deviceName:deviceName devType:deviceType seq:seq];
//        [self changeDevicePsw:serial loginName:userName password:password];
//    }
//}


- (void)loginDeviceResult:(NSString *)sId result:(int)result seq:(int)seq{
    if(_loginResult) { _loginResult(sId, result); }
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(loginDeviceResult:result:seq:)]) {
        [self.delegate loginDeviceResult:sId result:result seq:seq];
    }
}

- (void)addDeviceResultForLoginDevice:(NSString *)sId result:(int)result seq:(int)seq{
    [self getDeviceChannel:sId seq:seq];
}
@end
