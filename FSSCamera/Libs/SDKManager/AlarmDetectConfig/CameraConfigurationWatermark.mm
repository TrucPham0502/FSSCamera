//
//  CameraConfigurationWatermark.m
//  ISCCamera
//
//  Created by Long Vu on 6/6/19.
//  Copyright © 2019 fun.sdk.ftel.vn.su4. All rights reserved.
//

#import "CameraConfigurationWatermark.h"
#import "fVideo_OsdLogo.h"
#import "AVEnc_VideoWidget.h"
#import <FunSDK/FunSDK.h>

@implementation CameraConfigurationWatermark
{
    fVideo_OsdLogo videoLogo;
    AVEnc_VideoWidget widgetCfg;
}
- (void)getLogoConfig:(NSString *)serial{
    
    [self AddConfig:[CfgParam initWithName:serial andConfig:&widgetCfg andChannel:0 andCfgType:CFG_GET_SET]];
    [self AddConfig:[CfgParam initWithName:serial andConfig:&videoLogo andChannel:-1 andCfgType:CFG_GET_SET]];
    
    [self GetConfig];
}

-(void)OnGetConfig:(CfgParam *)param {
    if ([self.delegate respondsToSelector:@selector(getLogoWidgetResult:)]) {
        [self.delegate getLogoWidgetResult:param.errorCode];
    }
}
- (void)OnSetConfig:(CfgParam *)param {
    if ([self.delegate respondsToSelector:@selector(setLogoWidgetResult:)]) {
        [self.delegate setLogoWidgetResult:param.errorCode];
    }
}

- (int)getTimeWatermark {
    return widgetCfg.mTimeTitleAttribute.EncodeBlend.Value();
}

- (int)getTextWatermark {
    return widgetCfg.mChannelTitleAttribute.EncodeBlend.Value();
}

- (void)setTimeWatermark:(int)enable {
    widgetCfg.mTimeTitleAttribute.EncodeBlend = enable;
    widgetCfg.mTimeTitleAttribute.PreviewBlend = enable;
    [self SetConfig];
}

- (void)setTextWatermark:(int)enable content:(NSString *)content {
    widgetCfg.mChannelTitleAttribute.EncodeBlend = enable;
    widgetCfg.mChannelTitleAttribute.PreviewBlend = enable;
    const char *name = [content UTF8String];
    widgetCfg.mChannelTitle.Name = name;
    [self SetConfig];
}

- (NSString *)getCustomTextWatermark {
    return [NSString stringWithUTF8String:widgetCfg.mChannelTitle.Name.Value()];
}

@end
