//
//  ISCPlayrecordControl.m
//  ISCCamera
//
//  Created by PHAM CHI HIEU on 3/7/20.
//  Copyright © 2020 fun.sdk.ftel.vn.su4. All rights reserved.
//

#import "ISCPlayrecordControl.h"

@implementation ISCPlayrecordControl


#pragma mark - 开始播放
-(void)playVideo
{
    self.player = FUN_MediaLocRecordPlay(self.msgHandle, [self.filePath UTF8String] , (__bridge void*)(self.renderWnd),0);
    
    FUN_MediaSetSound(self.player, 100, 0);
}
-(void)dissmissPlayView{
    FUN_MediaSetSound(self.player, 0, 0);
    FUN_MediaStop(self.player);
}
#pragma mark - 暂停恢复播放
- (void)pauseOrResumePlay
{
//    self.isPause = !self.isPause;
    FUN_MediaPause(_player,-1);
//    FUN_MediaPause(self.player, 1, 0);
}


-(void)seekToTime:(NSInteger)addtime
{
    [self pauseOrResumePlay];
    FUN_MediaSeekToTime(self.player,addtime, 0, 0);
}

-(NSString *)sliderValueChanged:(NSInteger)addtime {
    return [self changeSecToTimeText:addtime];
}

#pragma mark - 将秒转化成显示的时间
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



#pragma mark - FunSDK CallBack
-(void)OnFunSDKResult:(NSNumber *) pParam
{
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    switch (msg->id) {
        case EMSG_START_PLAY://开始播放回
        {
            int time = msg->param3 - msg->param2 + 1;
            
            [self.delegate startPlayVideoTimeResult:msg->param2 Time:time TimeRight:[NSString stringWithFormat:@"%@",[self changeSecToTimeText:time]]];
        }
            break;
        case EMSG_ON_PLAY_INFO: //收到解码信息回调
        {
            int playTime = msg->param2 - msg->param1;
            [self.delegate startPlayVideoInfoResult:playTime TimeLeft: [self changeSecToTimeText:playTime]];
        }
            break;
        
        case EMSG_ON_PLAY_END:              // 录像播放结束
        {
            [self.delegate stopPlayVideoResult];
            FUN_MediaStop(self.player);
//           stopPlayVideoResult NSLog(@"结束\np1------%d\np2------%d\np3------%d",msg->param1,msg->param2,msg->param3);
        }
            break;
            default:
            break;
    }
}

@end
