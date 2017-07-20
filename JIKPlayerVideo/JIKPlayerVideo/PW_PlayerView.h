//
//  PW_PlayView.h
//  ThreeDimensional
//
//  Created by DFSJ on 17/3/8.
//  Copyright © 2017年 DFSJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZXPanDirection){
    ZXPanDirectionHorizontal, // 横向移动
    ZXPanDirectionVertical,   // 纵向移动
};

typedef NS_ENUM(NSUInteger, ZXTimeIndicatorPlayState) {
    ZXTimeIndicatorPlayStateRewind,      // 左
    ZXTimeIndicatorPlayStateFastForward, // 右
};


typedef void(^BackButtonBlock)();


@protocol IJKMediaPlayback;

@interface PW_PlayerView : UIView
/// pan手势移动方向
@property (nonatomic, assign) ZXPanDirection panDirection;
//左右移动方向
@property (nonatomic, assign, readwrite) ZXTimeIndicatorPlayState playState;


/// 快进退的总时长
@property (nonatomic, assign) NSTimeInterval sumTime;

/// 系统音量slider
@property (nonatomic, strong) UISlider *volumeViewSlider;

@property(nonatomic,weak) id<IJKMediaPlayback> delegatePlayer;

@property (nonatomic,copy) BackButtonBlock backBlock;

/// player duration timer
@property (nonatomic, strong) NSTimer *durationTimer;

//时长
@property (nonatomic,copy) NSString * duartion;

@property (nonatomic,copy) NSString *playableDuration;


@property (nonatomic, strong) UIButton       *fullBtn;


-(void) backButtonBlock:(BackButtonBlock) backBlock;



- (void)refreshMediaControl;

@end
