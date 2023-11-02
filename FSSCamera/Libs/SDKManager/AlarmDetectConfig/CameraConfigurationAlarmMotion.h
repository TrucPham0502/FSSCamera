//
//  CameraConfiguration.h
//  ISCCamera
//
//  Created by Long Vu on 6/5/19.
//  Copyright © 2019 fun.sdk.ftel.vn.su4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigControllerBase.h"

@protocol CameraConfigurationAlarmMotionDelegate <NSObject>
- (void)getAlarmDetectConfigResult:(NSInteger)result;
- (void)setAlarmDetectConfigResult:(NSInteger)result;
@end

NS_ASSUME_NONNULL_BEGIN

@interface CameraConfigurationAlarmMotion : ConfigControllerBase
@property (nonatomic, weak) id <CameraConfigurationAlarmMotionDelegate> delegate;
- (void)getAlarmMotionConfig:(NSString *)serial;
- (void)setDeviceAlarmDetectConfig;

- (BOOL)getMotionEnable;
- (BOOL)getMotionRecordEnable;
- (BOOL)getMotionSnapEnable;
- (BOOL)getMotionMessageEnable;
- (int)getMotionlevel;

- (void)setMotionEnable:(BOOL)Enable;
- (void)setMotionRecordEnable:(BOOL)Enable;
- (void)setMotionSnapEnable:(BOOL)Enable;
- (void)setMotionMessageEnable:(BOOL)Enable;
- (void)setMotionlevel:(int)Level;

@end

NS_ASSUME_NONNULL_END
