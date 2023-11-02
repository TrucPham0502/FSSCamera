//
//  ISCCameraSetting.h
//  ISCCamera
//
//  Created by Long Vu on 6/6/19.
//  Copyright © 2019 fun.sdk.ftel.vn.su4. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ISCCameraSettingDelegate <NSObject>
@optional
-(void)getMarkerConfigResult:(BOOL)result;
-(void)setMarkerConfigResult:(BOOL)result;
-(void)getAlarmDetectConfigResult:(BOOL)result;
-(void)setAlarmDetectConfigResult:(BOOL)result;
@end

@interface ISCCameraSetting : NSObject
+ (ISCCameraSetting *) shared;
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, weak) id <ISCCameraSettingDelegate> delegate;
- (void)setup:(NSString *)serial_camera;

// TODO: Alarm Motion
- (void)getAlarmMotionConfig;
- (void)setMotionAlarmSetting;

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

// TODO: Watermark
- (void)getWatermarkConfig;
- (BOOL)getTimeWatermark;
- (BOOL)getTextWatermark;
- (void)setTimeWatermark:(BOOL)enable;
- (void)setTextWatermark:(BOOL)enable content:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
