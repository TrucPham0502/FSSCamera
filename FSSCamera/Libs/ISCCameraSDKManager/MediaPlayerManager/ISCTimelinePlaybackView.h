//
//  ISCTimelinePlaybackView.h
//  FunSDKDemo
//
//  Created by Pham Chi Hieu on 10/26/19.
//  Copyright © 2019 Pham Chi Hieu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayView.h"
#import "JHRotatoUtil.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ISCTimelinePlaybackViewDelegate <NSObject>
    
@optional

- (void)getCloudVideoTimeResult:(NSInteger)result;
- (void)getInfoPlayerInit:(NSString *)startTime endTime:(NSString *)endTime endTimeInt:(int)endTimeInt;
- (void)getInfoPlayerRunning:(NSString *)playTime playTimeInt:(int)playTimeInt;
- (void)getInfoPlayerEnd:(NSString *)startTime;
@end

@interface ISCTimelinePlaybackView : PlayView
    @property (nonatomic, weak) id <ISCTimelinePlaybackViewDelegate> delegate;
    @property (nonatomic) NSString *isPause;
    @property (nonatomic) NSString *serialNumber;
    @property (nonatomic) UIInterfaceOrientation lastOrientation;
- (void)createPlayView;
- (void)initDataSource;
- (void)getDeviceVideoByTime:(NSDate*)date;
- (void)startPlayCloudVideo:(NSDate*)date endDate:(NSDate*)endDate;
- (void)stopPlayback;
- (void)pauseOrresumue;
- (void)resumue;
- (void)pause;
- (void)seekToTime:(int)time;
- (void)seekToTimeV2:(int)time;
    // MARK - Video Cloud
- (void)initDelegateVideoConfig;
- (void)searchCloudVideo:(NSDate*)date;
- (NSMutableArray*)getVideoTimeArray;
- (NSMutableArray*)getVideoArray;
    
    
-(void)fullScreenMode;
@end

NS_ASSUME_NONNULL_END
