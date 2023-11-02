//
//  UIPlaybackView.h
//  ISCCamera
//
//  Created by Long Vu on 4/16/19.
//  Copyright © 2019 fun.sdk.ftel.vn.su4. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JHRotatoUtil.h"

NS_ASSUME_NONNULL_BEGIN

// Protocol
@protocol UIPlaybackViewDelegate <NSObject>
// TODO: Must-have function callback
@required
// TODO: Callback when success connect video

@end


@interface UIPlaybackView : UIView
@property (nonatomic, assign) int myHandle;
@property (nonatomic) UIInterfaceOrientation lastOrientation;
@property (nonatomic, assign) CGRect playViewBound;
@property (readonly, nonatomic) int hObj;
@property (nonatomic) BOOL bIsSound;
@property (nonatomic) BOOL isPause;
@property (nonatomic) BOOL isCompletedPlay;


@property  (nonatomic,strong) NSString* url;

@property (nonatomic, weak) id <UIPlaybackViewDelegate> delegate;

// TODO: Setup Playback View
-(void)setup:(NSString* )url;
-(void)playViewDidDisappear;
-(void)fullScreenMode;

@end

NS_ASSUME_NONNULL_END
