//
//  ISCTimelinePlaybackView.m
//  FunSDKDemo
//
//  Created by Pham Chi Hieu on 10/26/19.
//  Copyright © 2019 Pham Chi Hieu. All rights reserved.
//

#import "ISCTimelinePlaybackView.h"
#import "PlayView.h"
#import "PlayFunctionView.h"
#import "PlayMenuView.h"
#import "CloudVideoConfig.h"
#import "MediaPlaybackControl.h"
#import "NSDate+TimeCategory.h"

@interface ISCTimelinePlaybackView () <MediaplayerControlDelegate,basePlayFunctionViewDelegate,CloudVideoTimeDelegate,MediaPlayBackControlDelegate>
{
    ChannelObject *channel;
    MediaPlaybackControl  *mediaPlayer;
    CloudVideoConfig *videoConfig;
    int startTimeSave;//thời gian bắt đầu video motion
    int endTimeSave;//thời gian kết thúc video motion
    int currentTimeSave;//thời gian video motion đang play
//    ProgressBackView *pBackView;
}

@end

@implementation ISCTimelinePlaybackView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)createPlayView {
    [self refreshView:0];
}

- (void)initDataSource {
//    channel = [[[DeviceControl getInstance] getSelectChannelArray] firstObject];
    
//    mediaPlayer.devID = channel.deviceMac;//设备序列号
    mediaPlayer = [[MediaPlaybackControl alloc] init];
    mediaPlayer.devID = self.serialNumber;//设备序列号
    mediaPlayer.channel = 0;//当前通道号
    mediaPlayer.stream = 1;//辅码流
    mediaPlayer.renderWnd = self;
    mediaPlayer.delegate = self;
    mediaPlayer.playbackDelegate = self;
    
    videoConfig = [[CloudVideoConfig alloc] init];
    videoConfig.timeDelegate = self;
    
}


-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer startResult:(int)result DSSResult:(int)dssResult {
    
    if (result < 0) {
        //[MessageUI ShowErrorInt:result];
    }else {
        if (dssResult == XM_NET_TYPE_DSS) { //DSS 打开视频成功
            
        }else if (dssResult == XM_NET_TYPE_RPS){//RPS打开预览成功
            
        }
        [self playViewBufferIng];
    }
}

/// <#Description#>
/// @param mediaPlayer mediaPlayer description
/// @param result result description
/// @param param3 param3 description thời gian kết thúc video motion
/// @param param2 param2 description thời gian bắt đầu video motion
- (void)mediaPlayer:(MediaplayerControl *)mediaPlayer startResultPlayBack:(int)result param3:(int)param3 param2:(int)param2 {
    self.isPause = @"PLAYING";
    int endTime = param3 - param2 + 1;
    NSString* endStr = [NSString stringWithFormat:@"%@",[self changeSecToTimeText:endTime]];
    NSString* startStr = [NSString stringWithFormat:@"00:00"];
    
    //lamnhs bổ sung thêm truòng lưu lại mốc thời gian motion
    startTimeSave = param2;
    endTimeSave = param3;
    currentTimeSave = 0;
    //end lamnhs bổ sung thêm truòng lưu lại mốc thời gian motion
    
    [self.delegate getInfoPlayerInit:startStr endTime:endStr endTimeInt:endTime];
}

- (void)mediaPlayer:(MediaplayerControl *)mediaPlayer DevTime:(NSString *)time {
    
}

- (void)mediaPlayer:(MediaplayerControl *)mediaPlayer info1:(int)nInfo info2:(NSString *)strInfo {
    
}

/// Description
/// @param mediaPlayer mediaPlayer description
/// @param param1 param1 description thời gian bắt đầu video
/// @param param2 param2 description thời gian hiện tại đang play video
/// @param param3 param3 description thời gian kết thúc video
- (void)mediaPlayer:(MediaplayerControl *)mediaPlayer Param1:(int)param1 Param2:(int)param2 Param3:(int)param3{
    int playTime = param2 - param3;
    if (playTime < 0) {
        playTime = param2 - param1;
    }
    //lamnhs bổ sung thêm truòng lưu lại mốc thời gian motion
    currentTimeSave = playTime;
    //end lamnhs bổ sung thêm truòng lưu lại mốc thời gian motion
    
    NSString* playStr = [self changeSecToTimeText:playTime];
    [self.delegate getInfoPlayerRunning:playStr playTimeInt:playTime];
}

- (void)mediaPlayer:(MediaplayerControl *)mediaPlayer playEndResult:(NSString *)startTime {
    [self.delegate getInfoPlayerEnd:startTime];
}

-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer buffering:(BOOL)isBuffering {
    if (isBuffering == YES) {//开始缓冲
        [self playViewBufferIng];
    }else{//缓冲完成
        [self playViewBufferEnd];
    }
}

- (void)stopPlayback {
    [mediaPlayer stop];
}

- (void)pauseOrresumue {
    if (mediaPlayer.status == MediaPlayerStatusPause) {
        [mediaPlayer resumue];
        self.isPause = @"PLAYING";
    }else if (mediaPlayer.status == MediaPlayerStatusPlaying) {
        [mediaPlayer pause];
        self.isPause = @"PAUSE";
    }else if (mediaPlayer.status == MediaPlayerStatusStop) {
        self.isPause = @"STOP";
    }
    
}
    
- (void)resumue {
    [mediaPlayer resumue];
}
- (void)pause {
    [mediaPlayer pause];
}
    
- (void)startPlayCloudVideo:(NSDate*)date endDate:(NSDate*)endDate {
    [self playViewBufferIng];
    
    //设置云视频时间并开始播放
    [mediaPlayer startPlayCloudVideo:date endDate:endDate];
}
- (void)startSearchFile:(NSDate*)date  {
    [videoConfig searchCloudVideo:date DeviceMac:self.serialNumber];
}
    
    // MARK - Get file play cloud
- (void)searchCloudVideo:(NSDate*)date {
    [videoConfig searchCloudVideo:date DeviceMac:self.serialNumber];
}
- (NSMutableArray*)getVideoTimeArray {
    return [videoConfig getVideoTimeArray];
}
    
- (NSMutableArray*)getVideoArray {
    return [videoConfig getVideoArray];
}

- (void)getCloudVideoTimeResult:(NSInteger)result {
    [self.delegate getCloudVideoTimeResult:result];
}


// TODO: Get TopViewController
- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)viewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navContObj = (UINavigationController*)viewController;
        return [self topViewControllerWithRootViewController:navContObj.visibleViewController];
    } else if (viewController.presentedViewController && !viewController.presentedViewController.isBeingDismissed) {
        UIViewController* presentedViewController = viewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }
    else {
        for (UIView *view in [viewController.view subviews])
        {
            id subViewController = [view nextResponder];
            if ( subViewController && [subViewController isKindOfClass:[UIViewController class]])
            {
                if ([(UIViewController *)subViewController presentedViewController]  && ![subViewController presentedViewController].isBeingDismissed) {
                    return [self topViewControllerWithRootViewController:[(UIViewController *)subViewController presentedViewController]];
                }
            }
        }
        return viewController;
    }
}

- (void)rotated:(NSNotification *)notification {
    if ([JHRotatoUtil isOrientationLandscape]) {
        self->_lastOrientation = [UIApplication sharedApplication].statusBarOrientation;
        [self p_prepareFullScreen];
    }
    else {
        [self p_prepareSmallScreen];
    }
}

- (void)p_prepareFullScreen {
    UIViewController *topViewController = [self topViewController];
//    [topViewController.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)p_prepareSmallScreen {
    UIViewController *topViewController = [self topViewController];
//    [topViewController.navigationController setNavigationBarHidden:NO animated:YES];
//    [topViewController.navigationController.navigationBar setOpaque:0.4];
}

-(void)fullScreenMode {
    if (JHRotatoUtil.isOrientationLandscape) {
        [JHRotatoUtil forceOrientation:UIInterfaceOrientationPortrait];
    }
    else {
        [JHRotatoUtil forceOrientation:UIInterfaceOrientationLandscapeRight];
    }
}

- (NSString *)changeSecToTimeText:(int)second
{
    NSString *timeStr = @"";
    int min = (int)second/60;
    NSString *minStr;
    if (min < 10) {
        minStr = [NSString stringWithFormat:@"0%d",min];
    }
    else{
        minStr = [NSString stringWithFormat:@"%d",min];
    }
    int sec = second- ((int)second/60) * 60;
    NSString *secStr;
    if (sec < 10) {
        secStr = [NSString stringWithFormat:@"0%d",sec];
    }
    else{
        secStr = [NSString stringWithFormat:@"%d",sec];
    }
    
    timeStr = [NSString stringWithFormat:@"%@:%@",minStr,secStr];
    return timeStr;
}

//MARK Play record
#pragma mark - 开始播放
- (void)initPlayBack {
//    channel = [[[DeviceControl getInstance] getSelectChannelArray] firstObject];
    
//    mediaPlayer.devID = channel.deviceMac;//设备序列号
    mediaPlayer = [[MediaPlaybackControl alloc] init];
    mediaPlayer.devID = self.serialNumber;//设备序列号
    mediaPlayer.renderWnd = self;
    mediaPlayer.delegate = self;
    mediaPlayer.playbackDelegate = self;
}
- (void)seekToTime:(int)time{
    [mediaPlayer seekToTime:time];
}
/// Description
/// @param time giá trị là từ 0 -> 30 tổng thời gian video motion
- (void)seekToTimeV2:(int)time{
    //lamnhs tính ra thời gian video sẽ play ex: 1591322900
    int playTime = startTimeSave + time;
    if(time <= 0){
        //lamnhs nếu thởi gian playtime hiện tại khi seek tới == 0 thì cho play tại start time
        playTime = startTimeSave;
        //NSLog(@"playTime_time1111111: %d",playTime);
    }else if(time > endTimeSave - startTimeSave){
        //lamnhs nếu thởi gian playtime hiện tại khi seek tới lớn hơn endtime - starttime thì cho play tại end time
        playTime = endTimeSave;
        //NSLog(@"playTime_time2222222: %d",playTime);
    }
//    NSLog(@"playTime_time: %d",time);
//    NSLog(@"playTime_startTimeSave: %d",startTimeSave);
//    NSLog(@"playTime_endTimeSave: %d",endTimeSave);
//    NSLog(@"playTime_playTime: %d",playTime);
//    NSLog(@"playTime_playTime: =====================================================");
    [mediaPlayer seekToTimeV2:playTime];
    //[mediaPlayer setPlaySpeed:2];
}
@end
