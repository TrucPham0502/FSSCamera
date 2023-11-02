//
//  ISCCameraLiveStreamView.h
//  FunSDKDemo
//
//  Created by Pham Chi Hieu on 10/25/19.
//  Copyright © 2019 Pham Chi Hieu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayView.h"
#import "JHRotatoUtil.h"
NS_ASSUME_NONNULL_BEGIN
@class ISCCameraLiveStreamView;
@protocol ISCCameraLiveStreamViewDelegate <NSObject>
@optional
//    -(void)didTapScreen;
//    -(void)changeQuality;
//
///// Description kết quả quay phim thành công
///// @param result result description
///// @param path path description
//    -(void)stopRecordResult:(int)result path:(NSString*)path;
//
///// Description
///// @param result result description
///// @param path path description
///// @param time time description thời gian của hình ảnh
//    -(void)snapImageResult:(int)result path:(NSString*)path time:(NSString*)time;
//
//    -(void)stopRecordVideo:(BOOL)result;
//    -(void)startedPlayInfo;
//    -(void)errorStartPlay;


    //callback dành cho grid livestream
    -(void)didTapScreen:(ISCCameraLiveStreamView*)cameraLiveStreamView;
    -(void)changeQuality:(ISCCameraLiveStreamView*)cameraLiveStreamView;

/// Description kết quả quay phim thành công
/// @param result result description
/// @param path path description
    -(void)stopRecordResult:(ISCCameraLiveStreamView*)cameraLiveStreamView result:(int)result path:(NSString*)path;

/// Description
/// @param result result description
/// @param path path description
/// @param time time description thời gian của hình ảnh
    -(void)snapImageResult:(ISCCameraLiveStreamView*)cameraLiveStreamView result:(int)result path:(NSString*)path;

    -(void)stopRecordVideo:(ISCCameraLiveStreamView*)cameraLiveStreamView result:(BOOL)result;
    -(void)startedPlay:(ISCCameraLiveStreamView*)cameraLiveStreamView result:(int)result dssResult:(int)dssResult;//start livestream thành công
    -(void)startedPlayInfo:(ISCCameraLiveStreamView*)cameraLiveStreamView;
    -(void)errorStartPlay:(ISCCameraLiveStreamView*)cameraLiveStreamView;

    - (void) talkBackControlStart;
    - (void) talkBackControlStop;
    - (void) talkBackControlError:(int)param1;

@end

@interface ISCCameraLiveStreamView : PlayView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <ISCCameraLiveStreamViewDelegate> delegate;

@property (nonatomic,strong)UITapGestureRecognizer *singleTap;
@property (nonatomic,strong)UISwipeGestureRecognizer *swipeleft;
@property (nonatomic,strong)UISwipeGestureRecognizer *swiperight;
@property (nonatomic,strong)UISwipeGestureRecognizer *swipeup;
@property (nonatomic,strong)UISwipeGestureRecognizer *swipedown;
@property (nonatomic) UIInterfaceOrientation lastOrientation;
@property (nonatomic) bool isRecording;
@property (nonatomic, assign) CGRect playViewBound;
@property (nonatomic) BOOL isHighPixel;
@property (nonatomic) BOOL bIsSound;
@property (nonatomic) BOOL isSplitMode;
@property (nonatomic) int index;

- (void)createPlayView;

/// Description lamnhs xoá sự kiện single tap vì grid view camera không cần dùng. để khỏi đụng sự kiện click
- (void)removeSingleTap;

- (void)initDataSource:(int)stream;

/// Description lamnhs func này sử dụng cho grid view livestream
/// @param channelObject channelObject description
/// @param stream stream description
- (void)initDataSource:(ChannelObject*) channelObject stream:(int)stream;

- (void)startRealPlay;
- (void)stopRealPlay;
- (void)stop;
- (int)pause;
- (int)resume;
- (NSString*)startRecord;
- (void)stopRecord;
//- (NSString*)snapImage:(UIImage *)image;
/// Description lamnhs chụp ảnh sử dụng sdk
- (NSString*)snapImageSDK;
//- (NSString*)snapImageWhenTapButtonBack:(UIImage *)image serial:(NSString*)serial;
/// Description lamnhs chụp ảnh sử dụng sdk
- (NSString*)snapImageWhenTapButtonBackSDK:(NSString*)serial phone:(NSString*)phone;
- (void)changeStreamType:(int)stream;
// TODO: Swipe Camera
- (void)swipeCamera:(int)direction;
- (void)setupSwipeGesture;
- (void)removeSwipeGesture;
- (void)fullScreenMode;
- (void)controZStartlPTAction:(int)type;
- (void)controZStopIPTAction:(int)type;
- (void)openSound:(int)soundValue;
- (void)closeSound;
- (void)openTalk;
- (void)closeTalk;
- (void)startDouTalk;
- (void)stopDouTalk;
@end


NS_ASSUME_NONNULL_END
