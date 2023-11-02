//
//  TalkView.m
//  XMEye
//
//  Created by Wangchaoqun on 15/7/4.
//  Copyright (c) 2015年 Megatron. All rights reserved.
//

#import "TalkView.h"


@implementation TalkView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.talkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.talkButton setBackgroundImage:[UIImage imageNamed:TS("press_talk")] forState:UIControlStateNormal];
        [self.talkButton setBackgroundImage:[UIImage imageNamed:TS("press_talk_selected")] forState:UIControlStateHighlighted];
        [self.talkButton addTarget:self action:@selector(talkToOther:) forControlEvents:UIControlEventTouchDown];
        [self.talkButton addTarget:self action:@selector(cannelTalk:) forControlEvents:UIControlEventTouchUpInside];
        [self.talkButton addTarget:self action:@selector(cannelTalk:) forControlEvents:UIControlEventTouchUpOutside];
        self.talkButton.tag = 100;
        [self addSubview:self.talkButton];
        
        
        self.dTalkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.dTalkButton setBackgroundImage:[UIImage imageNamed:TS("press_Doutalk")] forState:UIControlStateNormal];
        [self.dTalkButton setBackgroundImage:[UIImage imageNamed:TS("press_Doutalk_selected")] forState:UIControlStateHighlighted];
        [self.dTalkButton setBackgroundImage:[UIImage imageNamed:TS("press_Doutalk")] forState:UIControlStateNormal];
        [self.dTalkButton setBackgroundImage:[UIImage imageNamed:TS("press_Doutalk_selected")] forState:UIControlStateSelected];
        [self.dTalkButton addTarget:self action:@selector(talkToOther:) forControlEvents:UIControlEventTouchDown];
        [self.dTalkButton addTarget:self action:@selector(cannelTalk:) forControlEvents:UIControlEventTouchUpInside];
        [self.dTalkButton addTarget:self action:@selector(cannelTalk:) forControlEvents:UIControlEventTouchUpOutside];
        self.dTalkButton.tag = 200;
        [self addSubview:self.dTalkButton];
        
        self.cannelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cannelButton setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [self.cannelButton addTarget:self action:@selector(cannelTheView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cannelButton];
    }
    return self;
}

//显示视图
- (void)showTheView
{
    CGFloat width = CGRectGetWidth(self.frame) > CGRectGetHeight(self.frame) ?
                                             CGRectGetHeight(self.frame) - 10:
                                             CGRectGetWidth(self.frame) - 10;
    self.talkButton.frame = CGRectMake(0, 0, width, width);
    self.talkButton.center = CGPointMake(self.bounds.size.width / 4+20, self.bounds.size.height / 2);
    
    self.cannelButton.frame = CGRectMake(CGRectGetWidth(self.frame) - 50, 0, 50, 50);
    
    self.dTalkButton.frame = self.talkButton.frame;
    self.dTalkButton.center = CGPointMake(self.bounds.size.width *3/ 4-20, self.bounds.size.height / 2);
    
    CGRect frame = self.frame;
    self.frame = CGRectOffset(frame, 0, frame.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = frame;
        self.cannelButton.transform = CGAffineTransformMakeRotation(M_PI_2);
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(openTalkView)]) {
            [self.delegate openTalkView];
        }
    }];
}


//关闭视图
- (void)cannelTheView {
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectOffset(self.frame, 0, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(closeTalkView)]) {
            [self.delegate closeTalkView];
        }
    }];
}

//打开通话
- (void)talkToOther:(id)sender {
    UIButton *button  = (UIButton*)sender;
    if (button.tag == 100) { //单向对讲
        button.highlighted = true;
        if ([self.delegate respondsToSelector:@selector(openTalk)]) {
            [self.delegate openTalk];
        }
    }else if (button.tag == 200) { //双向对讲
        //双向对讲按下时不做处理
    }
}

//关闭通话
- (void)cannelTalk:(id)sender {
    UIButton *button = (UIButton*)sender;
    if (button.tag == 100) { //单向对讲
        button.highlighted = false;
        if ([self.delegate respondsToSelector:@selector(closeTalk)]) {
            [self.delegate closeTalk];
        }
    }else if (button.tag == 200) { //双向对讲
        if (button.isSelected == NO) {
            button.selected = YES;
            if ([self.delegate respondsToSelector:@selector(startDouTalk)]) {
                [self.delegate startDouTalk]; //开始双向对讲
            }
        }else if (button.isSelected == YES) {
            button.selected = NO;
            if ([self.delegate respondsToSelector:@selector(stopDouTalk)]) {
                [self.delegate stopDouTalk]; //结束双向对讲
            }
        }
    }
}


@end
