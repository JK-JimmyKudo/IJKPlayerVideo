//
//  PW_PlayerVideoView.m
//  JIKPlayerVideo
//
//  Created by DFSJ on 17/3/10.
//  Copyright © 2017年 Oriental Horizon. All rights reserved.
//
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

#import "PW_PlayerVideoView.h"
#import "PW_PlayerView.h"

@interface PW_PlayerVideoView ()

@property (weak, nonatomic) UIView *PlayerView;
@property (nonatomic, assign)int number;

@property (nonatomic, assign)CGFloat heartSize;

@property (nonatomic, strong)UIImageView *dimIamge;

@property (nonatomic, strong) NSArray *fireworksArray;

@property (nonatomic, weak) CALayer *fireworksL;

@property (nonatomic,strong) PW_PlayerView *pw_playView;

/** 系统菊花 */
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic,assign) NSInteger broadcastingIndex;


@end

static BOOL  change = YES;

@implementation PW_PlayerVideoView

-(instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)url title:(NSString *)title{


    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        // 播放视频
        [self goPlaying:url];
        // 创建按钮
        [self setupBtn];
        
        [self AttemptingGradient];
        
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        [self addGestureRecognizer:tapGes];
    }


    return self;
}


-(void)tapClick{
    
    if (change) {
        
        
        [UIView animateWithDuration:2 delay:1 options:UIViewAnimationOptionOverrideInheritedOptions animations:^{
            self.pw_playView.hidden = change;
            change = !change;
            
        } completion:nil];
        
        
    }else{
       
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionOverrideInheritedOptions animations:^{
            
            self.pw_playView.hidden = change;
            change = !change;
            
        } completion:nil];
    }
}




- (void)goPlaying:(NSURL *)url{
    
    // 设置Log信息打印
    [IJKFFMoviePlayerController setLogReport:YES];
    // 设置Log等级
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
    // 检查当前FFmpeg版本是否匹配
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    // IJKFFOptions 是对视频的配置信息
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    //获取url
//    self.url = [NSURL URLWithString:_liveUrl];
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
    
    NSLog(@"%@",url);
    
    UIView *playerview = [self.player view];
    UIView *displayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.PlayerView = displayView;
    [self addSubview:self.PlayerView];
    
    if (self.player) {
        
        [self.activity startAnimating];
        
    }
    
    // 自动调整自己的宽度和高度
    playerview.frame = self.PlayerView.bounds;
    playerview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.PlayerView insertSubview:playerview atIndex:1];
    [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
    // 开启通知
    [self installMovieNotificationObservers];
    [self PlayVideoAnimated];
    
    [self performSelector:@selector(hide) withObject:nil afterDelay:5];
}

- (void)hide
{
    self.pw_playView.hidden = YES;
    change = !change;
    [self cancelDelayedHide];
}

- (void)cancelDelayedHide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
}

- (void)setupBtn {
    
    self.pw_playView = [[PW_PlayerView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width , self.bounds.size.height)];
    
    [self addSubview:self.pw_playView];
    
    self.pw_playView.delegatePlayer = self.player;
    
    [self.pw_playView backButtonBlock:^{

        [self  GoBack];
        
    }];
}


// 返回
- (void)GoBack
{
    // 停播
    [self.player pause];
    [self.player shutdown];
    [self removeMovieNotificationObservers];
    [self removeFromSuperview];
    
    
    
    
}

//视图即将显示开始播放
- (void)PlayVideoAnimated {
    
    if (![self.player isPlaying]) {
        //准备播放
        [self.player prepareToPlay];
    }
}


- (void)playerWillShow
{
    if (!self.player) {
        [self.player prepareToPlay];
    }
    
    [self installMovieNotificationObservers];
    [self.player prepareToPlay];
    
}


- (void)playerWillHide
{
//    if (self.player) {
//        [self.player shutdown];
        [self removeMovieNotificationObservers];
//    }
    
}

#pragma Install Notifiacation
- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

-(void) refreshMediaControl{
    
    [self.pw_playView refreshMediaControl];
}

#pragma mark - remove Notification  移除通知
- (void)removeMovieNotificationObservers {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
}

#pragma Install Notifiacation- -播放器依赖的相关监听
- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"---------------------加载状态改变通知: IJKMovieLoadStatePlayThroughOK(加载成功): %d\n",(int)loadState);
        
        if (self.player) {
            
            [self.activity stopAnimating];
            
        }
        
        [self refreshMediaControl];
        
        
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        if (self.player) {
            
            [self.activity startAnimating];
            
        }
        NSLog(@"---------------------加载状态改变通知: IJKMPMovieLoadStateStalled(加载停滞): %d\n", (int)loadState);
    } else {
        NSLog(@"---------------------加载状态改变通知: 其他状态: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackFinish:(NSNotification*)notification {
    
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"---------------------播放结束状态通知: IJKMPMovieFinishReasonPlaybackEnded(播放结束): %d\n", reason);
#pragma mark -- 播放结束发送通知给控制器，监听结束信息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IJKMPMovieFinishReasonPlaybackEnded" object:nil];
            [self viewDidDisappear];
            
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"---------------------播放结束状态通知: IJKMPMovieFinishReasonUserExited(用户退出): %d\n", reason);
            
            
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            
            NSLog(@"---------------------播放结束状态通知: IJKMPMovieFinishReasonPlaybackError(播放出错): %d\n", reason);
            break;
            
        default:
            NSLog(@"---------------------播放结束状态通知: 其他原因: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"---------------------准备播放状态改变通知\n");
    
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    
    
    switch (_player.playbackState) {
            
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"---------------------播放状态改变通知 %d: stoped(播放结束)", (int)_player.playbackState);
            
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"---------------------播放状态改变通知 %d: playing(播放中)", (int)_player.playbackState);
        
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"---------------------播放状态改变通知 %d: paused(播放暂停)", (int)_player.playbackState);
            
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"---------------------播放状态改变通知 %d: interrupted(播放中断)", (int)_player.playbackState);
            
            
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            
            NSLog(@"---------------------播放状态改变通知 %d: seeking", (int)_player.playbackState);
            
            break;
        }
            
        default: {
            NSLog(@"---------------------播放状态改变通知 %d: 其他状态", (int)_player.playbackState);
            break;
        }
    }
}


- (void)viewDidDisappear{

    [self removeMovieNotificationObservers];
    
}

//#pragma mark - 横屏代码
//- (BOOL)shouldAutorotate{
//    
//    return NO;
//} //NS_AVAILABLE_IOS(6_0);当前viewcontroller是否支持转屏
//
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    
//    return UIInterfaceOrientationMaskLandscapeRight;
//} //当前viewcontroller支持哪些转屏方向
//
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationLandscapeRight;
//}
//
//- (BOOL)prefersStatusBarHidden
//{
//    return NO; // 返回NO表示要显示，返回YES将hiden
//}
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}
//



- (UIActivityIndicatorView *)activity
{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activity.frame = CGRectMake((self.bounds.size.width - 200)/2, (self.bounds.size.height-200)/2, 200, 200);
        [self addSubview:_activity];
    }
    return _activity;
}


- (void)AttemptingGradient{
    
    CGFloat width,height;
    width = kScreenWidth>kScreenHeight?kScreenWidth:kScreenHeight;
    height = kScreenWidth>kScreenHeight?kScreenHeight:kScreenWidth;
    
    UIColor *colorOne = [UIColor clearColor];
    UIColor *colorTwo = [[UIColor blackColor]colorWithAlphaComponent: 0.85];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor,  nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = CGRectMake(0, self.PlayerView.bounds.size.height - 50, self.pw_playView.frame.size.width, 50);
    
    
    NSArray *colors1 = [NSArray arrayWithObjects:(id)colorTwo.CGColor, colorOne.CGColor,  nil];
    NSNumber *stopOne1 = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo1 = [NSNumber numberWithFloat:1.0];
    NSArray *locations1 = [NSArray arrayWithObjects:stopOne1, stopTwo1, nil];
    CAGradientLayer *headerLayer1 = [CAGradientLayer layer];
    headerLayer1.colors = colors1;
    headerLayer1.locations = locations1;
    headerLayer1.frame = CGRectMake(0, 0, self.pw_playView.frame.size.width, 50);
    
    
    [self.pw_playView.layer insertSublayer:headerLayer above:0];
    [self.pw_playView.layer insertSublayer:headerLayer1 above:0];
    
    
}

@end
