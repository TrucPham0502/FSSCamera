//
//  ISCPlayRecordView.h
//  ISCCamera
//
//  Created by PHAM CHI HIEU on 3/7/20.
//  Copyright © 2020 fun.sdk.ftel.vn.su4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYGLKView.h"
#import "JHRotatoUtil.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ISCPlayRecordViewDelegate <NSObject>
    
@optional

- (void)startPlayVideoTimeResult:(NSInteger)startTime Time:(NSInteger)time TimeRight:(NSString *)timeRight;
- (void)startPlayVideoInfoResult:(NSInteger)playTime TimeLeft:(NSString *)timeLeft;
- (void)stopPlayVideoResult;
@end
@interface ISCPlayRecordView : UIView
    @property (nonatomic, weak) id <ISCPlayRecordViewDelegate> delegate;
    @property (nonatomic,copy) NSString *filePath;
    @property (nonatomic,assign) BOOL isPause;
- (void)setUp;
- (void)myLayout;
- (void)playVideo;
- (void)pauseOrResumePlay;
- (void)seekToTime:(NSInteger)addtime;
- (void)fullScreenMode;
- (NSString *)sliderValueChanged:(NSInteger)addtime;
- (void)sliderTouchDown;
- (void)dissmissPlayView;
- (void)setFrame;
@end

NS_ASSUME_NONNULL_END
