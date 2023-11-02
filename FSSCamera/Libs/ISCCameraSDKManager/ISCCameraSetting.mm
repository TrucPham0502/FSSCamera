//
//  CameraSetting.m
//  ISCCamera
//
//  Created by Long Vu on 6/6/19.
//  Copyright © 2019 fun.sdk.ftel.vn.su4. All rights reserved.
//

#import "ISCCameraSetting.h"
#import "../SDKManager/AlarmDetectConfig/CameraConfigurationAlarmMotion.h"
#import "../SDKManager/AlarmDetectConfig/CameraConfigurationWatermark.h"

@interface ISCCameraSetting() <CameraConfigurationAlarmMotionDelegate,CameraConfigurationWatermarkDelegate> {}
@end

@implementation ISCCameraSetting
static ISCCameraSetting *shareManager;
CameraConfigurationAlarmMotion *alarmotion_setting;
CameraConfigurationWatermark *watermark_setting;
NSString *serial;
+ (ISCCameraSetting * )shared {
    return shareManager ? shareManager : [[ISCCameraSetting alloc]init];
}
- (id) init{
    static dispatch_once_t once;
    dispatch_once(&once ,^{
        shareManager = self;
    });
    self = shareManager;
    return self;
}
- (void)dealloc {
    alarmotion_setting = nil;
    watermark_setting = nil;
}
- (void)setup:(NSString *)serial_camera {
    alarmotion_setting = nil;
    watermark_setting = nil;
    serial = serial_camera;
}

- (void)getAlarmMotionConfig {
    if (alarmotion_setting == nil) {
        alarmotion_setting = [[CameraConfigurationAlarmMotion alloc] init];
        alarmotion_setting.delegate = self;
    }
    [alarmotion_setting getAlarmMotionConfig:serial];
}

- (void)getAlarmDetectConfigResult:(NSInteger)result {
    if ([self.delegate respondsToSelector:@selector(getAlarmDetectConfigResult:)]) {
        if (result>0) {
            [self.delegate getAlarmDetectConfigResult:YES];
        }else{
            [self.delegate getAlarmDetectConfigResult:NO];
        }
    }
}

- (void)setAlarmDetectConfigResult:(NSInteger)result {
    if ([self.delegate respondsToSelector:@selector(setAlarmDetectConfigResult:)]) {
        if (result>0) {
            [self.delegate setAlarmDetectConfigResult:YES];
        }else{
            [self.delegate setAlarmDetectConfigResult:NO];
        }
    }
}

- (void)setMotionAlarmSetting {
    if (alarmotion_setting == nil) {
        return;
    }
    [alarmotion_setting setDeviceAlarmDetectConfig];
}
- (BOOL)getMotionEnable {
    if (alarmotion_setting == nil) {
        return NO;
    }
    return [alarmotion_setting getMotionEnable];
}
- (BOOL)getMotionRecordEnable {
    if (alarmotion_setting == nil) {
        return NO;
    }
    return [alarmotion_setting getMotionRecordEnable];
}
- (BOOL)getMotionSnapEnable {
    if (alarmotion_setting == nil) {
        return NO;
    }
    return [alarmotion_setting getMotionSnapEnable];
}
- (BOOL)getMotionMessageEnable{
    if (alarmotion_setting == nil) {
        return NO;
    }
    return [alarmotion_setting getMotionMessageEnable];
}
- (int)getMotionlevel{
    if (alarmotion_setting == nil) {
        return 0;
    }
    return [alarmotion_setting getMotionlevel];
}
- (void)setMotionEnable:(BOOL)Enable {
    if (alarmotion_setting == nil) {
        return;
    }
    return [alarmotion_setting setMotionEnable:Enable];
}
- (void)setMotionRecordEnable:(BOOL)Enable {
    if (alarmotion_setting == nil) {
        return;
    }
    return [alarmotion_setting setMotionRecordEnable:Enable];
}
- (void)setMotionSnapEnable:(BOOL)Enable {
    if (alarmotion_setting == nil) {
        return;
    }
    return [alarmotion_setting setMotionSnapEnable:Enable];
}
- (void)setMotionMessageEnable:(BOOL)Enable{
    if (alarmotion_setting == nil) {
        return;
    }
    return [alarmotion_setting setMotionMessageEnable:Enable];
}
- (void)setMotionlevel:(int)Level{
    if (alarmotion_setting == nil) {
        return;
    }
    return [alarmotion_setting setMotionlevel:Level];
}

- (void)getWatermarkConfig {
    if (watermark_setting == nil) {
        watermark_setting = [[CameraConfigurationWatermark alloc] init];
        watermark_setting.delegate = self;
    }
    [watermark_setting getLogoConfig:serial];
}

-(void)getLogoWidgetResult:(NSInteger)result {
    if ([self.delegate respondsToSelector:@selector(getMarkerConfigResult:)]) {
        if (result>0) {
            [self.delegate getMarkerConfigResult:YES];
        }else{
            [self.delegate getMarkerConfigResult:NO];
        }
    }
    
}
-(void)setLogoWidgetResult:(NSInteger)result {
    if ([self.delegate respondsToSelector:@selector(setMarkerConfigResult:)]) {
        if (result>0) {
            [self.delegate setMarkerConfigResult:YES];
        }else{
            [self.delegate setMarkerConfigResult:NO];
        }
    }
}

- (BOOL)getTimeWatermark {
    if ([watermark_setting getTimeWatermark] > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)getTextWatermark {
    if ([watermark_setting getTextWatermark] > 0) {
        return YES;
    }
    return NO;
}

- (void)setTimeWatermark:(BOOL)enable {
    if (enable) {
        // Turn on
        [watermark_setting setTimeWatermark:1];
    }
    else {
        // Turn off
        [watermark_setting setTimeWatermark:0];
    }
}

- (void)setTextWatermark:(BOOL)enable content:(NSString *)content {
    if (enable) {
        // Turn on
        [watermark_setting setTextWatermark:1 content:content];
    }
    else {
        // Turn off
        [watermark_setting setTextWatermark:0 content:content];
    }
}

@end
