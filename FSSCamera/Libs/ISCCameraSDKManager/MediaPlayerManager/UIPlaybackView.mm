//
//  UIPlaybackView.m
//  ISCCamera
//
//  Created by Long Vu on 4/16/19.
//  Copyright © 2019 fun.sdk.ftel.vn.su4. All rights reserved.
//

#import "UIPlaybackView.h"
#include <FunSDK/FunSDK.h>

@interface UIPlaybackView() {
    int _beginHour;
    int _beginMin;
    int _beginSec;
}

@end

@implementation UIPlaybackView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

-(void)dealloc {
    FUN_MediaStop(_myHandle);
    self.myHandle = 0;
    [self CloseHandle];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

+(Class)layerClass {
    return [CAEAGLLayer class];
}

-(int)MsgHandle{
    if ( !_hObj ) {
        _hObj = FUN_RegWnd((__bridge void*)self);
    }
    return _hObj;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

// TODO: Playback

// TODO: Setup Playback View
-(void)setup:(NSString* )url {
    
    // Note: Data setup a camera play view
    
    self.playViewBound = self.bounds;
    self.bIsSound = NO;
    self.isPause = NO;
    self.isCompletedPlay = NO;
    
    self.url = url;
    [self setupGesutre];
    
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                             UIViewAutoresizingFlexibleHeight);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotated:) name:UIDeviceOrientationDidChangeNotification object:nil];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////

// TODO: Gesture

-(void)setupGesutre {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [singleTap setNumberOfTapsRequired:1];
    [self addGestureRecognizer:singleTap];
}

- (void)singleTapAction:(UIGestureRecognizer *)gestureRecoginizer {
//    [self.delegate didTapScreen];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

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
    [topViewController.navigationController setNavigationBarHidden:YES animated:YES];
}

// Chuyển sang chuẩn bị màn hình thu nhỏ
- (void)p_prepareSmallScreen {
    UIViewController *topViewController = [self topViewController];
    [topViewController.navigationController setNavigationBarHidden:NO animated:YES];
    [topViewController.navigationController.navigationBar setOpaque:0.4];
}


-(void)fullScreenMode {
    if (JHRotatoUtil.isOrientationLandscape) {
        [JHRotatoUtil forceOrientation:UIInterfaceOrientationPortrait];
    }
    else {
        [JHRotatoUtil forceOrientation:UIInterfaceOrientationLandscapeRight];
    }
}



// Note: Call this in View Did Disappear
- (void)playViewDidDisappear {
    FUN_MediaStop(_myHandle);
    _myHandle = 0;
    [self CloseHandle];
    //[SVProgressHUD dismiss];
    
//    ISCAppDelegate* appDelegate = (ISCAppDelegate*)[[UIApplication sharedApplication]delegate];
//    appDelegate.enableAllOrientation = false;
}

-(void)CloseHandle{
    FUN_UnRegWnd(_hObj);
    _hObj = 0;
}


    
- (void)seekToTime:(float)value {
    FUN_MediaSeekToTime(_myHandle,(int)value, 0, 0);
}





//////////////////////////////////////////////////////////////////////////////////////////////////////

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

+ToNSStr:(const char*)szStr
{
    NSString* retStr;
    if (szStr) {
        retStr = [NSString stringWithUTF8String:szStr];
    }
    else {
        return @"";
    }
    
    if (retStr == nil || (retStr.length == 0 && strlen(szStr) > 0)) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData* data = [NSData dataWithBytes:szStr length:strlen(szStr)];
        retStr = [[NSString alloc] initWithData:data encoding:enc];
    }
    if (retStr == nil) {
        retStr = @"";
    }
    return retStr;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

@end
