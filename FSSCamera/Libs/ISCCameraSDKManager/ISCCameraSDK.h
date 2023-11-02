//
//  ISCCameraSDK.h
//  ISCCamera
//
//  Created by Pham Chi Hieu on 10/28/19.
//  Copyright © 2019 fun.sdk.ftel.vn.su4. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SDKInitializeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ISCCameraSDK : NSObject

+ (ISCCameraSDK *) shared;

- (void)initSDK;
- (void)unInitSDK;

@end
NS_ASSUME_NONNULL_END
