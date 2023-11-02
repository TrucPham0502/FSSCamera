//
//  PlayView.m
//  XMEye
//
//  Created by XM on 2018/7/21.
//  Copyright © 2018年 Megatron. All rights reserved.
//

#import "PlayView.h"

@implementation PlayView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor blackColor];
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _activityView.hidesWhenStopped = YES;
    [self addSubview:_activityView];
    
    _activityView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *centerConstraintX = [NSLayoutConstraint constraintWithItem:_activityView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerConstraintY = [NSLayoutConstraint constraintWithItem:_activityView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    [self addConstraint:centerConstraintX];
    [self addConstraint:centerConstraintY];
    
    return self;
}
#pragma mark  刷新界面和图标
- (void)refreshView:(int)index {
    self.tag = index;
}
- (void)playViewBufferIng { //正在缓冲
    [self.activityView stopAnimating];
}
- (void)playViewBufferEnd {//缓冲完成
    [self.activityView stopAnimating];
}
- (void)playViewBufferStop {//预览失败
    [self.activityView stopAnimating];
}



+(Class)layerClass{
    return [CAEAGLLayer class];
}
@end
