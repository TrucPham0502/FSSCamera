//
//  ISCCameraLiveStreamView.m
//  FunSDKDemo
//
//  Created by Pham Chi Hieu on 10/25/19.
//  Copyright © 2019 Pham Chi Hieu. All rights reserved.
//

#import "ISCCameraLiveStreamView.h"
#import "DeviceManager.h"
#import "MediaplayerControl.h"
#import "PlayView.h"
#import "TalkBackControl.h"
#import "PlayFunctionView.h"
#import "DoorBellModel.h"
#import "Glimpse.h"

@interface ISCCameraLiveStreamView () <MediaplayerControlDelegate,basePlayFunctionViewDelegate, TalkBackControlDelegate>
{
    NSMutableArray *feyeArray;
    MediaplayerControl  *mediaPlayer;
    TalkBackControl *talkControl;
    PlayFunctionView *toolView;
    double orginalRatio;
}

@end

@implementation ISCCameraLiveStreamView
Glimpse *glimpse;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

#pragma mark - 界面初始化
- (void)createPlayView {
    self.isRecording = NO;
//    if (playViewArray == nil) {
//        playViewArray = [[NSMutableArray alloc] initWithCapacity:0];
//    }
//    //单通道播放
//    [playViewArray addObject:self];
    [self setupGesutre];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotated:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)initDataSource:(int)stream {
    
    //选择播放的通道信息
    ChannelObject *channel = [[[DeviceControl getInstance] getSelectChannelArray] firstObject];
    mediaPlayer = [[MediaplayerControl alloc] init];
    mediaPlayer.devID = channel.deviceMac;//设备序列号
    mediaPlayer.channel = channel.channelNumber;//当前通道号
    mediaPlayer.stream = stream;//辅码流
//    mediaPlayer.renderWnd = [playViewArray objectAtIndex:0];
    mediaPlayer.renderWnd = self;
    mediaPlayer.delegate = self;
    //初始化对讲工具，这个可以放在对讲开始前初始化
    talkControl = [[TalkBackControl alloc] init];
    talkControl.deviceMac = mediaPlayer.devID;
    talkControl.channel = mediaPlayer.channel;
    talkControl.delegate = self;
}

/// Description dành cho grid video
/// @param channelObject channelObject description
/// @param stream stream description
- (void)initDataSource:(ChannelObject*) channelObject stream:(int)stream {
    mediaPlayer = [[MediaplayerControl alloc] init];
    mediaPlayer.devID = channelObject.deviceMac;//设备序列号
    mediaPlayer.channel = channelObject.channelNumber;//当前通道号
    mediaPlayer.stream = stream;//辅码流
    mediaPlayer.renderWnd = self;
    mediaPlayer.delegate = self;
    //初始化对讲工具，这个可以放在对讲开始前初始化
    talkControl = [[TalkBackControl alloc] init];
    talkControl.deviceMac = mediaPlayer.devID;
    talkControl.channel = mediaPlayer.channel;
}

- (void)startRealPlay {
//    for (int i =0; i< playViewArray.count; i++) {
//        PlayView *pView = [playViewArray objectAtIndex:i];
//        [pView playViewBufferIng];
//        MediaplayerControl *mediaPlayer = [mediaArray objectAtIndex:i];
//        [mediaPlayer start];
//    }
    [self playViewBufferIng];
    [mediaPlayer start];

}

-(void)changeStreamType:(int)stream {

    //先停止预览
    [mediaPlayer stop];
    //切换主辅码流
    mediaPlayer.stream = stream;
    //重新播放预览
    [mediaPlayer start];
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeQuality:)]) {
        [self.delegate changeQuality:self];
    }
}

/*
- (NSString*)snapImage:(UIImage *)image {
//    [mediaPlayer snapImage];
    NSString *dateString = [NSString GetSystemTimeString];
    NSString *file = [NSString getPhotoPath];
    NSString *pictureFilePath = [file stringByAppendingFormat:@"/%@.jpg",dateString];
    
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:pictureFilePath atomically:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(snapImageResult:result:path:time:)]) {
            [self.delegate snapImageResult:self result:0 path:[NSString stringWithFormat:@"%@/%@.jpg",[CommonOBJC DIRECTORY_PHOTOS],dateString] time:@""];
        }
    });
    return [NSString stringWithFormat:@"%@/%@.jpg",[CommonOBJC DIRECTORY_PHOTOS],dateString];
}
 */

- (NSString*)snapImageSDK{
    NSString *dateString = [NSString GetSystemTimeString];
    NSString *file = [NSString getPhotoPath];
    NSString *pictureFilePath = [file stringByAppendingFormat:@"/%@.jpg",dateString];
    int result = [mediaPlayer snapImage:pictureFilePath];
    
    NSString *pathFile = [NSString stringWithFormat:@"%@/%@.jpg",@"Photos",dateString];
    return pathFile;
}

/*
/// Description chụp hình màn hình live stream khi user nhấn button back
/// @param image image description
/// @param serial serial description
- (NSString*)snapImageWhenTapButtonBack:(UIImage *)image serial:(NSString*)serial {
    NSString *dateMillisecond = [NSString stringWithFormat:@"%ld",[NSString GetSystemTimeMiliseconds]];
    NSString *file = [NSString getPhotoPath];
    NSString *pictureFilePath = [file stringByAppendingFormat:@"/%@.jpg",serial];
    
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:pictureFilePath atomically:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(snapImageResult:result:path:time:)]) {
            [self.delegate snapImageResult:self result:0 path:[NSString stringWithFormat:@"%@/%@.jpg",[CommonOBJC DIRECTORY_PHOTOS],serial] time:dateMillisecond];
        }
    });
    return [NSString stringWithFormat:@"%@/%@.jpg",[CommonOBJC DIRECTORY_PHOTOS],serial];
}
*/

- (NSString*)snapImageWhenTapButtonBackSDK:(NSString*)serial phone:(NSString*)phone{
    NSString *file = [NSString getPhotoPath];
    NSString *pictureFilePath = [file stringByAppendingFormat:@"/%@_%@.jpg",serial,phone];
    int result = [mediaPlayer snapImage:pictureFilePath];
    return [NSString stringWithFormat:@"/%@_%@.jpg",@"Photos",serial,phone];
}

//- (void)startRecord {
//    self.isRecording = YES;
//    [mediaPlayer startRecord];
//}
//
- (void)stopRecord {
    self.isRecording = NO;
//        FUN_MediaStopRecord(_myHandle);
     [mediaPlayer stopRecord];
//    [glimpse stop];
//    glimpse = nil;
}

-(NSString*)startRecord {
    NSString *dateString = [NSString GetSystemTimeString];
    NSString *file = [NSString getVideoPaths];
    NSString *movieFilePath = [file stringByAppendingFormat:@"/%@.mp4",dateString];
    self.isRecording = YES;
//    [self startRecordVideo:movieFilePath];
    [mediaPlayer startRecordWithPath:movieFilePath];
    return [NSString stringWithFormat:@"Videos/%@.mp4",dateString];
}

-(void)startRecordVideo:(NSString*)movieFilePath {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        glimpse = [[Glimpse alloc] initWithCustomizeUrlOutput:movieFilePath];
        dispatch_async(dispatch_get_main_queue(), ^{
            [glimpse startRecordingView:self onCompletion:^(NSURL *fileOuputURL) {
                NSLog(@"DONE WITH OUTPUT: %@", fileOuputURL.absoluteString);
                if (self.delegate && [self.delegate respondsToSelector:@selector(stopRecordVideo:result:)]) {
                    [self.delegate stopRecordVideo:self result:YES];
                }
            }];
        });
    });
}

-(void)fullScreenMode {
    if (JHRotatoUtil.isOrientationLandscape) {
        [JHRotatoUtil forceOrientation:UIInterfaceOrientationPortrait];
    }
    else {
        [JHRotatoUtil forceOrientation:UIInterfaceOrientationLandscapeRight];
    }
}

#pragma mark - 开始预览结果回调
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer startResult:(int)result DSSResult:(int)dssResult {
//    NSLog(@"mediaPlayer_DSSResult: %d",dssResult);
//    if (result < 0) {
//    }else {
//        if (dssResult == XM_NET_TYPE_DSS) { //DSS 打开视频成功
//            NSLog(@"mediaPlayer_DSSResult: đang play DSS");
//        }else if (dssResult == XM_NET_TYPE_RPS){//RPS打开预览成功
//            NSLog(@"mediaPlayer_DSSResult: đang play RPS");
//        }else if (dssResult == XM_NET_TYPE_P2P){//RPS打开预览成功
//            NSLog(@"mediaPlayer_DSSResult: đang play P2P");
//        }else if (dssResult == XM_NET_TYPE_SERVER_TRAN){//RPS打开预览成功
//            NSLog(@"mediaPlayer_DSSResult: đang play TRAN");
//        }else if (dssResult == XM_NET_TYPE_IP){//RPS打开预览成功
//            NSLog(@"mediaPlayer_DSSResult: đang play IP");
//        }else if (dssResult == XM_NET_TYPE_TUTK){//RPS打开预览成功
//            NSLog(@"mediaPlayer_DSSResult: đang play TUTK");
//        }else if (dssResult == XM_NET_TYPE_RTC_P2P){//RPS打开预览成功
//            NSLog(@"mediaPlayer_DSSResult: đang play RTC_P2P");
//        }else if (dssResult == XM_NET_TYPE_RTC_PROXY){//RPS打开预览成功
//            NSLog(@"mediaPlayer_DSSResult: đang play RTC_PROXY");
//        }else if (dssResult == XM_NET_TYPE_P2P_V2){//RPS打开预览成功
//            NSLog(@"mediaPlayer_DSSResult: đang play P2P_V2");
//        }else if (dssResult == XM_NET_TYPE_PROXY_V2){//RPS打开预览成功
//            NSLog(@"mediaPlayer_DSSResult: đang play PROXY_V2");
//        }
//    }
    
    
    if (result < 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(errorStartPlay:)]) {
            [self.delegate errorStartPlay:self];
        }
    }else {
        [self playViewBufferIng];
        ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
        DeviceObject *devObject = [[DeviceControl getInstance] GetDeviceObjectBySN:channel.deviceMac];
        if (devObject == NULL){
            return;
        }
        if (devObject.nType == XM_DEV_DOORBELL || devObject.nType == XM_DEV_CAT || devObject.nType == CZ_DOORBELL || devObject.nType == XM_DEV_INTELLIGENT_LOCK || devObject.nType == XM_DEV_DOORBELL_A || devObject.nType == XM_DEV_DOORLOCK_V2) {
            [[DoorBellModel shareInstance] beginUploadData:channel.deviceMac];
            [DoorBellModel shareInstance].DevUploadDataCallBack = ^(NSDictionary *state, NSString *devMac) {
                NSLog(@"DoorBellModel %@",state);
            };
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(startedPlay:result:dssResult:)]) {
            [self.delegate startedPlay:self result:result dssResult:dssResult];
        }
    }
}

#pragma mark - 视频缓冲中
-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer buffering:(BOOL)isBuffering ratioDetail:(double)ratioDetail{
//    PlayView *pview = [playViewArray objectAtIndex:mediaPlayer.index];
    if (isBuffering == YES) {//开始缓冲
//        [pview playViewBufferIng];
        [self playViewBufferIng];
    }else{//缓冲完成
        // 预览开始时抓张设备缩略图 当背景
        
        orginalRatio = ratioDetail;
//        NSString* thumbnailPathName = [NSString devThumbnailFile:mediaPlayer.devID andChannle:0];
//        FUN_MediaGetThumbnail(mediaPlayer.player, thumbnailPathName.UTF8String,1);
//        [pview playViewBufferEnd];
        [self playViewBufferEnd];
        
    }
}


-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer startRecordResult:(int)result path:(NSString*)path {
    if (result == EE_OK) { //开始录像成功
        mediaPlayer.record = MediaRecordTypeRecording;
        [toolView refreshFunctionView:CONTROL_REALPLAY_VIDEO result:YES];
    }else{
        //[MessageUI ShowErrorInt:result];
        [toolView refreshFunctionView:CONTROL_REALPLAY_VIDEO result:NO];
    }
}

-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer stopRecordResult:(int)result path:(NSString*)path {
   
    [toolView refreshFunctionView:CONTROL_REALPLAY_VIDEO result:NO];
    mediaPlayer.record = MediaRecordTypeNone;
//    [self.delegate stopRecordResult:result path:path];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        if (self.delegate && [self.delegate respondsToSelector:@selector(stopRecordVideo:result:)]) {
            [self.delegate stopRecordVideo:self result:YES];
        }
    });
}

-(void)mediaPlayer:(MediaplayerControl*)mediaPlayer snapImagePath:(NSString *)path result:(int)result {
    if (self.delegate && [self.delegate respondsToSelector:@selector(snapImageResult:result:path:)]) {
        [self.delegate snapImageResult:self result:result path:path];
    }
}

- (void)mediaPlayer:(MediaplayerControl *)mediaPlayer Param1:(int)param1 Param2:(int)param2 Param3:(int)param3{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startedPlayInfo:)]) {
        [self.delegate startedPlayInfo:self];
    }
}


- (void)talkBackControlStart {
    if (self.delegate && [self.delegate respondsToSelector:@selector(talkBackControlStart)]) {
        [self.delegate talkBackControlStart];
    }
}

- (void)talkBackControlError:(int)param1 {
    //EE_MNETSDK_TALK_ALAREADY_START = -400012
    if (self.delegate && [self.delegate respondsToSelector:@selector(talkBackControlError:)]) {
        [self.delegate talkBackControlError:param1];
    }
    
}

- (void)talkBackControlStop {
    if (self.delegate && [self.delegate respondsToSelector:@selector(talkBackControlStop)]) {
        [self.delegate talkBackControlStop];
    }
}


- (void)stopRealPlay {
    // 停止设备主动上报
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    DeviceObject *devObject = [[DeviceControl getInstance] GetDeviceObjectBySN:channel.deviceMac];
    if(devObject != NULL){
        [[DoorBellModel shareInstance] beginStopUploadData:devObject.deviceMac];
    }
    [talkControl closeTalk]; //停止对讲
    [mediaPlayer closeSound]; //停止音频
    [mediaPlayer stop];
    [[DeviceControl getInstance] cleanSelectChannel];
}

- (void)stop {
    [mediaPlayer stop];
}

- (int)pause{
    return [mediaPlayer pause];
}
- (int)resume{
    return [mediaPlayer resumue];
}

// TODO: Gesture

-(void)setupGesutre {
    @try {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        [_singleTap setNumberOfTapsRequired:1];
        [self addGestureRecognizer:_singleTap];
        [self setupSwipeGesture];
    } @catch (NSException *exception) {
     
    }
}

/// Description lamnhs xoá sự kiện single tap vì màn hình grid view camera live không dùng, để khỏi đụng sự kiện
- (void)removeSingleTap{
    if (_singleTap != NULL){
        [self removeGestureRecognizer:_singleTap];
    }
}

-(void)setupSwipeGesture {
    [self removeSwipeGesture];
    _swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanSwipe:)];
    _swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:_swipeleft];
    
    _swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanSwipe:)];
    _swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:_swiperight];
    
    _swipeup=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanSwipe:)];
    _swipeup.direction=UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:_swipeup];
    
    _swipedown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanSwipe:)];
    _swipedown.direction=UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:_swipedown];
}

- (void)handlePanSwipe:(UISwipeGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateChanged) {
        PTZ_ControlType ptz;
        switch (recognizer.direction) {
            case UISwipeGestureRecognizerDirectionUp:
                ptz = TILT_DOWN;
                break;
            case UISwipeGestureRecognizerDirectionDown:
                ptz = TILT_UP;
                break;
            case UISwipeGestureRecognizerDirectionLeft:
                ptz = PAN_RIGHT;
                break;
            case UISwipeGestureRecognizerDirectionRight:
                ptz = PAN_LEFT;
                break;
            default:
                ptz = TILT_UP;
                break;
        }
//        FUN_DevPTZControl (_myHandle, [self.serialName UTF8String], 0, ptz, 0);
//        sleep(1);
//        FUN_DevPTZControl (_myHandle, [self.serialName UTF8String], 0, ptz, 1);
    }
}

#pragma mark - 点击云台控制的按钮，开始控制  这个接口没有回调信息
-(void)controZStartlPTAction:(int)type {
    [mediaPlayer controZStartlPTAction:(PTZ_ControlType)type];
}
#pragma mark - 抬起云台控制的按钮，结束控制   这个接口没有回调信息
-(void)controZStopIPTAction:(int)type {
    [mediaPlayer controZStopIPTAction:(PTZ_ControlType)type];
}
#pragma mark 开始播放音频
- (void)openSound:(int)soundValue {
    if (mediaPlayer.voice == MediaVoiceTypeNone){
        [mediaPlayer openSound:soundValue];
        mediaPlayer.voice = MediaVoiceTypeVoice;
    }
}
#pragma mark 停止播放音频
- (void)closeSound {
    if (mediaPlayer.voice == MediaVoiceTypeVoice){
        [mediaPlayer closeSound];
        mediaPlayer.voice = MediaVoiceTypeNone;
    }
}

#pragma - mark - 语音对讲按钮代理 (对讲和双向对讲同时只能打开一个)
- (void)openTalk {
   talkControl.handle = mediaPlayer.msgHandle;
    [talkControl startTalk];
}
- (void)closeTalk {
    talkControl.handle = mediaPlayer.msgHandle;
    [talkControl closeTalk];
}

#pragma - mark 开始双向对讲  (单向对讲和双向对讲同时只能打开一个) (双向对讲最好做一下手机端的回音消除工作     demo中并没有做这个)
- (void)startDouTalk {
    [talkControl startDouTalk];
}
//结束双向对讲
- (void)stopDouTalk {
    [talkControl stopDouTalk];
}

- (void)removeSwipeGesture {
    for (int k = 0; k <= self.subviews.count-1; k++) {
        if(k >= self.subviews.count){
            return;
        }
        int count = (int)self.subviews[k].gestureRecognizers.count;
        if (count == 0) { return; }
        for (int l=0;l<=count-1;l++) {
            if (self.subviews[k].gestureRecognizers[l] == self.swipeleft) {
                [self removeGestureRecognizer:self.subviews[k].gestureRecognizers[l]];
            }
            if (self.subviews[k].gestureRecognizers[l] == self.swipedown) {
                [self removeGestureRecognizer:self.subviews[k].gestureRecognizers[l]];
            }
            if (self.subviews[k].gestureRecognizers[l] == self.swipeup) {
                [self removeGestureRecognizer:self.subviews[k].gestureRecognizers[l]];
            }
            if (self.subviews[k].gestureRecognizers[l] == self.swiperight) {
                [self removeGestureRecognizer:self.subviews[k].gestureRecognizers[l]];
            }
        }
    }
}


- (void)singleTapAction:(UIGestureRecognizer *)gestureRecoginizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapScreen:)]) {
        [self.delegate didTapScreen:self];
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)rotated:(NSNotification *)notification {
//    if ([JHRotatoUtil isOrientationLandscape]) {
//        self->_lastOrientation = [UIApplication sharedApplication].statusBarOrientation;
//        [self p_prepareFullScreen];
//    }
//    else {
//        [self p_prepareSmallScreen];
//    }
//    if (self.playStatus == PlayerStatusPlayIng) {
//        self.playStatus = PlayerStatusPause;
//        FUN_MediaStop(self.myHandle);
//        double delayInSeconds = 0.25;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [self runLiveStream];
//        });
//    }
}

- (void)p_prepareFullScreen {
    UIViewController *topViewController = [self topViewController];
    [topViewController.navigationController setNavigationBarHidden:YES animated:YES];
}

// Chuyển sang chuẩn bị màn hình thu nhỏ
- (void)p_prepareSmallScreen {
    UIViewController *topViewController = [self topViewController];
    [topViewController.navigationController setNavigationBarHidden:NO animated:YES];
    [topViewController.navigationController.navigationBar setOpaque:0.4];
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

@end
