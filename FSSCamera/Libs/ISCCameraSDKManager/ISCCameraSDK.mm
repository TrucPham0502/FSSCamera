//
//  ISCCameraSDK.m
//  ISCCamera
//
//  Created by Pham Chi Hieu on 10/28/19.
//  Copyright © 2019 fun.sdk.ftel.vn.su4. All rights reserved.
//
#import "ISCCameraSDK.h"

@implementation ISCCameraSDK

static ISCCameraSDK *shareManager;
+ (ISCCameraSDK * )shared {
    return shareManager ? shareManager : [[ISCCameraSDK alloc]init];
}
- (id) init{
    static dispatch_once_t once;
    dispatch_once(&once ,^{
        shareManager = self;
    });
    self = shareManager;
    return self;
}
// TODO: Init SDK Function
- (void)initSDK {
    [SDKInitializeModel SDKInit];
}

- (void)unInitSDK{
    [SDKInitializeModel SDKUnInit];
}
@end
