//
//  CameraConfigurationWatermark.h
//  ISCCamera
//
//  Created by Long Vu on 6/6/19.
//  Copyright © 2019 fun.sdk.ftel.vn.su4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigControllerBase.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CameraConfigurationWatermarkDelegate <NSObject>
@optional
-(void)getLogoWidgetResult:(NSInteger)result;
-(void)setLogoWidgetResult:(NSInteger)result;
@end

@interface CameraConfigurationWatermark : ConfigControllerBase

@property (nonatomic, weak) id <CameraConfigurationWatermarkDelegate> delegate;
- (void)getLogoConfig:(NSString *)serial;
- (int)getTimeWatermark;
- (int)getTextWatermark;
- (void)setTimeWatermark:(int)enable;
- (void)setTextWatermark:(int)enable content:(NSString *)content;
- (NSString *)getCustomTextWatermark;
@end

NS_ASSUME_NONNULL_END
