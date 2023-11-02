//
//  ISCPlayrecordControl.h
//  ISCCamera
//
//  Created by PHAM CHI HIEU on 3/7/20.
//  Copyright © 2020 fun.sdk.ftel.vn.su4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FunMsgListener.h"
#import "FunSDK/FunSDK.h"
#import "CYGLKView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ISCPlayrecordControlDelegate <NSObject>
    
@optional

- (void)startPlayVideoTimeResult:(NSInteger)startTime Time:(NSInteger)time TimeRight:(NSString *)timeRight;
- (void)startPlayVideoInfoResult:(NSInteger)playTime TimeLeft:(NSString *)timeLeft;
- (void)stopPlayVideoResult;

@end
@interface ISCPlayrecordControl : FunMsgListener
@property (nonatomic, weak) id <ISCPlayrecordControlDelegate> delegate;
@property (nonatomic, assign) FUN_HANDLE player;
@property (nonatomic, assign) CYGLKView* renderWnd;
@property (nonatomic,copy) NSString *filePath;
- (void)playVideo;
- (void)pauseOrResumePlay;
- (void)seekToTime:(NSInteger)addtime;
- (NSString *)sliderValueChanged:(NSInteger)addtime;
- (void)dissmissPlayView;
@end

NS_ASSUME_NONNULL_END
