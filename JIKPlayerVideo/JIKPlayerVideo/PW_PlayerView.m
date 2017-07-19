//
//  PW_PlayView.m
//  ThreeDimensional
//
//  Created by DFSJ on 17/3/8.
//  Copyright © 2017年 DFSJ. All rights reserved.
//

#import "PW_PlayerView.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "PW_ProgressView.h"
#import "PW_BrightnessView.h"
#import "PW_PlayView.h"

#define XJScreenH [UIScreen mainScreen].bounds.size.height
#define XJScreenW [UIScreen mainScreen].bounds.size.width
#define LeastMoveDistance 15
#define TotalScreenTime 90


@interface PW_PlayerView ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign)int number;

@property (nonatomic,assign ,getter=isMediaSliderBeingDragged) BOOL MediaSliderBeingDragged;

//获取系统的音量
@property (nonatomic, assign) CGFloat systemVolume;

/// 是否在调节音量
@property (nonatomic, assign) BOOL isVolumeAdjust;
//显示亮度View
@property (nonatomic,strong) PW_BrightnessView *brightnessV;

//时间进度显示
@property (nonatomic,strong) PW_ProgressView *progressV;

@property (nonatomic,strong) PW_PlayView *playView;

@end

@implementation PW_PlayerView

-(instancetype) initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        [self setupBtn];
        self.backgroundColor = [UIColor clearColor];
        
        [self configVolume];
        [self progressView];
    }

    return self;
}

-(void)progressView{

    self.progressV = [[PW_ProgressView alloc]initWithFrame:CGRectMake((self.bounds.size.width - 100)/2, (self.bounds.size.height - 60)/2, 100, 60)];
    [self addSubview:self.progressV];

    self.progressV.hidden = YES;
}

-(PW_ProgressView *)progressV{

    if (_progressV) {
        
    }

    return _progressV;
}

/// 获取系统音量控件
- (void)configVolume
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    //获取系统音量
    self.volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeViewSlider = (UISlider *)view;
            
            break;
        }
    }
    
    self.systemVolume = self.volumeViewSlider.value;

}



#pragma mark ---- <创建按钮>
- (void)setupBtn {

    // 返回
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor redColor];
    backBtn.frame = CGRectMake(10, 10, 50, 50);
   
    [backBtn setImage:[UIImage imageNamed:@"comment_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(GoBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    backBtn.layer.shadowOffset = CGSizeMake(0, 0);
    backBtn.layer.shadowOpacity = 0.5;
    backBtn.layer.shadowRadius = 1;
    [self addSubview:backBtn];
    
    [self addSubview:self.playView];
    [self addSubview:self.brightnessV];
    
        
     [self.playView.playButton addTarget:self action:@selector(play_btn:) forControlEvents:(UIControlEventTouchUpInside)];
        
    //设置slider的方法
    [self.playView.slider addTarget:self action:@selector(didSliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    
    [self.playView.slider addTarget:self action:@selector(didSliderTouchCancel:) forControlEvents:UIControlEventTouchCancel];
    
    [self.playView.slider addTarget:self action:@selector(didSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.playView.slider addTarget:self action:@selector(didSliderTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
    [self.playView.slider addTarget:self action:@selector(didSliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //添加手势
 
        UIPanGestureRecognizer *panGes=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
        [self addGestureRecognizer:panGes];
}


- (void)didSliderTouchDown:(id)sender {
    self.MediaSliderBeingDragged = YES;
    
    NSLog(@"didSliderTouchDown ");
}
- (void)didSliderTouchCancel:(id)sender {
    self.MediaSliderBeingDragged = NO;
    
    NSLog(@"didSliderTouchCancel ");
}
- (void)didSliderTouchUpOutside:(id)sender {
    self.MediaSliderBeingDragged = NO;
    
    NSLog(@"didSliderTouchUpOutside ");
}
- (void)didSliderTouchUpInside:(id)sender {
    
    self.delegatePlayer.currentPlaybackTime = self.playView.slider.value;
    
    self.MediaSliderBeingDragged = NO;
    
    [self refreshMediaControl];
    [self.delegatePlayer play];
    [self.delegatePlayer isPlaying];
    self.progressV.hidden = YES;
}

- (void)didSliderValueChanged:(id)sender {
    
       NSLog(@"didSliderValueChanged 滑动");
    self.progressV.hidden = NO;
}


-(void) refreshMediaControl{
    
    NSTimeInterval duration = self.delegatePlayer.duration;
    
    NSInteger intDuration = duration ;
    
    if (intDuration > 0) {
        
        self.playView.slider.maximumValue = intDuration;
        
    } else {
        
        self.playView.slider.maximumValue = 0.0f;
    
    }
    
    NSTimeInterval position;
    
    if (self.MediaSliderBeingDragged) {
        
        position = self.playView.slider.value;
    
    } else {
    
        position = self.delegatePlayer.currentPlaybackTime;
    }
    
    NSInteger intPosition = position;
    
    if (intDuration > 0) {
        
        self.playView.slider.value = intPosition;
        NSString *playDurationString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(intPosition/3600),((intPosition%3600)/60),(intPosition%60)];
        
        self.playView.playDurationLabel.text = [NSString stringWithFormat:@"%@",playDurationString];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *sumTime = [NSString stringWithFormat:@"%zd",intPosition];
        [user setObject:sumTime forKey:@"sumTime"];
        [user synchronize];
        
        NSString *duartionString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(intDuration/3600),((intDuration%3600)/60),(intDuration%60)];
        
        self.playView.duartionLabel.text = [NSString stringWithFormat:@"%@",duartionString];
        
        self.progressV.timeLabel.text = [NSString stringWithFormat:@"%@/%@",playDurationString,duartionString];
        
    } else {
        self.playView.slider.value = 0.0f;
        self.playView.playDurationLabel.text = @"--:--";
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
    
}



-(void)panDirection:(UIPanGestureRecognizer *)pan{
    CGPoint locationPoint = [pan locationInView:self];
    CGPoint veloctyPoint = [pan velocityInView:self];

    switch (pan.state) {
        case UIGestureRecognizerStateBegan: { // 开始移动
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            
            if (x > y) { // 水平移动
                self.panDirection = ZXPanDirectionHorizontal;
                self.sumTime = self.delegatePlayer.currentPlaybackTime; // sumTime初值
                [self.delegatePlayer pause];
                [self stopDurationTimer];
                
            } else if (x < y) { // 垂直移动
                
                self.panDirection = ZXPanDirectionVertical;
                if (locationPoint.x > self.bounds.size.width / 2) { // 音量调节
                    
                    self.isVolumeAdjust = YES;
                } else { // 亮度调节
                    self.isVolumeAdjust = NO;
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged: { // 正在移动
            switch (self.panDirection) {
                case ZXPanDirectionHorizontal: {
                    
                    self.progressV.hidden = NO;
                    [self horizontalMoved:veloctyPoint.x];
                
                }
                    break;
                case ZXPanDirectionVertical: {
                
                    [self verticalMoved:veloctyPoint.y];
                
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case UIGestureRecognizerStateEnded: { // 移动停止
            switch (self.panDirection) {
                case ZXPanDirectionHorizontal: {
                    //获取值 完成之后放入播放器   更新播放器显示时间
                    [self.delegatePlayer setCurrentPlaybackTime:self.sumTime];
                    
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    NSString *sumTime = [NSString stringWithFormat:@"%zd",self.sumTime];
                    [user setObject:sumTime forKey:@"sumTime"];
                    [user synchronize];
                    
                    [self.delegatePlayer play];
                    [self.delegatePlayer isPlaying];
                    [self startDurationTimer];
                    self.progressV.hidden = YES;
                }
                    break;
                case ZXPanDirectionVertical: {
                    break;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

/// pan垂直移动
- (void)verticalMoved:(CGFloat)value
{
    if (self.isVolumeAdjust) {
        // 调节系统音量
        self.volumeViewSlider.value -= value / 10000;
    }else {
        // 亮度
        [UIScreen mainScreen].brightness -= value / 10000;
    }
}

/// pan水平移动
- (void)horizontalMoved:(CGFloat)value
{
    // 每次滑动叠加时间
    self.sumTime += value / 200;
    // 容错处理
    if (self.sumTime > self.delegatePlayer.duration) {
        
        self.sumTime = self.delegatePlayer.duration;
        
    } else if (self.sumTime < 0) {
        
        self.sumTime = 0;
    }
    // 时间更新
    NSInteger currentTime = self.sumTime;
    NSInteger totalTime = self.delegatePlayer.duration;
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    //     播放进度更新
    self.playView.slider.value = self.sumTime;
    // 快进or后退 状态调整
    ZXTimeIndicatorPlayState playState = ZXTimeIndicatorPlayStateRewind;
    
    if (value < 0) { // left
        
        playState = ZXTimeIndicatorPlayStateRewind;
        [self.progressV.arrowImageView setImage:[UIImage imageNamed:@"zx-video-player-rewind"]];
        
    } else if (value > 0) { // right
        
        playState = ZXTimeIndicatorPlayStateFastForward;

        [self.progressV.arrowImageView setImage:[UIImage imageNamed:@"zx-video-player-fastForward"]];

    }
}



/// 更新播放时间显示
- (void)setTimeLabelValues:(NSInteger)currentTime totalTime:(NSInteger)totalTime {
    
    //小时
    NSInteger hourElapsed = (currentTime/3600);
    NSInteger minutesElapsed = ((currentTime%3600)/60);
    NSInteger secondsElapsed = (currentTime%60);
    NSString *timeElapsedString = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", hourElapsed,minutesElapsed, secondsElapsed];
    
    
    NSInteger hourRemaining = (totalTime/3600);
    NSInteger minutesRemaining = ((totalTime%3600)/60);
    NSInteger secondsRemaining = (totalTime%60);
    //小时
    NSString *timeRmainingString = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", hourRemaining,minutesRemaining, secondsRemaining];
    self.progressV.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeElapsedString,timeRmainingString];
    
}

/// 开启定时器
- (void)startDurationTimer
{
    if (self.durationTimer) {
        
        [self.durationTimer setFireDate:[NSDate date]];
        
    } else {
        
        [self monitorVideoPlayback];
        
    }
}
/// 监听播放进度
- (void)monitorVideoPlayback
{
    NSInteger currentTime = self.delegatePlayer.currentPlaybackTime;
    NSInteger totalTime = self.delegatePlayer.duration;
    // 更新时间
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    // 更新播放进度
    self.playView.slider.value = ceil(currentTime);
    
}

/// 暂停定时器
- (void)stopDurationTimer
{
    if (_durationTimer) {
        [self.durationTimer setFireDate:[NSDate distantFuture]];
    }
}


-(PW_BrightnessView *)brightnessV{

    if (!_brightnessV) {
        _brightnessV = [[PW_BrightnessView alloc]init];
        _brightnessV.center = self.center;
    }
    return _brightnessV;
}

-(PW_PlayView *)playView{


    if (_playView == nil) {
        _playView = [[PW_PlayView alloc]init];
        _playView.frame = CGRectMake(0, self.bounds.size.height - 40, self.bounds.size.width, 40);
    }
    return _playView;
}

//播放和暂停按钮的切换
- (void)play_btn:(UIButton *)sender{
    
   sender.selected =! sender.selected;
    if (![self.delegatePlayer isPlaying]) {
        // 播放
         NSLog(@"播放");
        [self.delegatePlayer play];
    }else{
        // 暂停
        NSLog(@"暂停");
        [self.delegatePlayer pause];
    }
}



-(void) backButtonBlock:(BackButtonBlock)backBlock{
    
    self.backBlock = backBlock;
}
-(void) GoBack{
    __weak typeof(self) WeakSelf = self;

    if (WeakSelf.backBlock) {
        WeakSelf.backBlock();
    }
}
@end
