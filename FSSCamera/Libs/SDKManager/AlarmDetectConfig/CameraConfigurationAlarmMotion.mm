//
//  CameraConfiguration.m
//  ISCCamera
//
//  Created by Long Vu on 6/5/19.
//  Copyright © 2019 fun.sdk.ftel.vn.su4. All rights reserved.
//

#import "CameraConfigurationAlarmMotion.h"
#import "Detect_MotionDetect.h"

@interface CameraConfigurationAlarmMotion () {}
@property (nonatomic, assign) Detect_MotionDetect motionCfg;
@end
@implementation CameraConfigurationAlarmMotion
-(void)getAlarmMotionConfig:(NSString *)serial {
    CfgParam* paramMotionCfg = [[CfgParam alloc] initWithName:[NSString stringWithUTF8String:_motionCfg.Name()] andDevId:serial andChannel:0 andConfig:&_motionCfg andOnce:YES andSaveLocal:NO];
    [self AddConfig:paramMotionCfg];
    [self GetConfig];
}

- (BOOL)getMotionEnable {
    return _motionCfg.Enable.Value();
}
- (BOOL)getMotionRecordEnable {
    return _motionCfg.mEventHandler.RecordEnable.Value();
}
- (BOOL)getMotionSnapEnable {
    return _motionCfg.mEventHandler.SnapEnable.Value();
}
- (BOOL)getMotionMessageEnable{
    return _motionCfg.mEventHandler.MessageEnable.Value();
}
- (int)getMotionlevel{
    return _motionCfg.Level.Value();
}
- (void)setMotionEnable:(BOOL)Enable {
    _motionCfg.Enable = Enable;
}
- (void)setMotionRecordEnable:(BOOL)Enable {
    _motionCfg.mEventHandler.RecordEnable = Enable;
}
- (void)setMotionSnapEnable:(BOOL)Enable {
    _motionCfg.mEventHandler.SnapEnable = Enable;
}
- (void)setMotionMessageEnable:(BOOL)Enable{
    _motionCfg.mEventHandler.MessageEnable =Enable;
}
- (void)setMotionlevel:(int)Level{
    _motionCfg.Level = Level;
}


- (void)setDeviceAlarmDetectConfig {
    [self SetConfig];
}

- (void)OnSetConfig:(CfgParam *)param {
    if ([param.name isEqualToString:[NSString stringWithUTF8String:_motionCfg.Name()]]) {
        if ([self.delegate respondsToSelector:@selector(setAlarmDetectConfigResult:)]) {
            [self.delegate setAlarmDetectConfigResult:param.errorCode];
        }
    }
}


-(void)OnGetConfig:(CfgParam *)param {
    if ([param.name isEqualToString:[NSString stringWithUTF8String:_motionCfg.Name()]]) {
                if ([self.delegate respondsToSelector:@selector(getAlarmDetectConfigResult:)]) {
                    [self.delegate getAlarmDetectConfigResult:param.errorCode ];
                }
    }
}

- (void)OnFunSDKResult:(NSNumber *) pParam {
    [super OnFunSDKResult:pParam];
}
@end
