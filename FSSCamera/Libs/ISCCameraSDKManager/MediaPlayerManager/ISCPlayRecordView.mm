//
//  ISCPlayRecordView.m
//  ISCCamera
//
//  Created by PHAM CHI HIEU on 3/7/20.
//  Copyright © 2020 fun.sdk.ftel.vn.su4. All rights reserved.
//

#import "ISCPlayRecordView.h"

#import "ISCPlayrecordControl.h"
@interface ISCPlayRecordView ()<ISCPlayrecordControlDelegate>
{
    ISCPlayrecordControl  *mediaPlayer;
}
@property (nonatomic,strong) CYGLKView *glView;
@end

@implementation ISCPlayRecordView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

-(void)setUp{
    mediaPlayer = [[ISCPlayrecordControl alloc] init];
    mediaPlayer.filePath = self.filePath;
    mediaPlayer.renderWnd = _glView;
    mediaPlayer.delegate = self;
}

-(void)myLayout{
    self.glView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_glView];
    
}
-(void)setFrame{
    self.glView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
- (void)dissmissPlayView{
    [mediaPlayer dissmissPlayView];
}

-(void)playVideo
{
    [mediaPlayer playVideo];
}
- (void)pauseOrResumePlay
{
    self.isPause = !self.isPause;
    [mediaPlayer pauseOrResumePlay];
}
- (void)seekToTime:(NSInteger)addtime
{
    [mediaPlayer seekToTime:addtime];
}

- (void)startPlayVideoTimeResult:(NSInteger)startTime Time:(NSInteger)time TimeRight:(NSString *)timeRight {
    [self.delegate startPlayVideoTimeResult:startTime Time:time TimeRight:timeRight];
}
- (void)startPlayVideoInfoResult:(NSInteger)playTime TimeLeft:(NSString *)timeLeft{
    [self.delegate startPlayVideoInfoResult:playTime TimeLeft:timeLeft];
}

- (void)stopPlayVideoResult{
    [self.delegate stopPlayVideoResult];
}

- (NSString *)sliderValueChanged:(NSInteger)addtime{
    return [mediaPlayer sliderValueChanged:addtime];
}
-(void)sliderTouchDown {
     [mediaPlayer pauseOrResumePlay];
}
-(void)fullScreenMode {
    if (JHRotatoUtil.isOrientationLandscape) {
        [JHRotatoUtil forceOrientation:UIInterfaceOrientationPortrait];
    }
    else {
        [JHRotatoUtil forceOrientation:UIInterfaceOrientationLandscapeRight];
    }
    self.glView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark - LazyLoad
-(CYGLKView *)glView{
    if (!_glView) {
        _glView = [[CYGLKView alloc] init];
        _glView.backgroundColor = [UIColor blackColor];
    }
    
    return _glView;
}
@end
