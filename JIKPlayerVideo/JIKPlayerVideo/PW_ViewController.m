//
//  PW_ViewController.m
//  JIKPlayerVideo
//
//  Created by DFSJ on 17/3/10.
//  Copyright © 2017年 Oriental Horizon. All rights reserved.
//
#define kDWidth [UIScreen mainScreen].bounds.size.width

#define TopMargin 20

#define MinPlayerHeight (kDWidth / 16 * 9)


#import "PW_ViewController.h"
#import "PW_PlayerVideoView.h"


@interface PW_ViewController ()

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,copy) NSString *mvUrl;

@property (nonatomic,strong) NSArray *arr;

@property (nonatomic,strong) PW_PlayerVideoView *pw_playerView;

@end

@implementation PW_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.index = 0;
    [self playerVideo:self.index];
    //接受通知，执行方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IJKMPMovieFinishReasonPlaybackEnded) name:@"IJKMPMovieFinishReasonPlaybackEnded" object:nil];
    
}

-(void) playerVideo:(NSInteger) index{
    
    self.arr = @[@"http://app.video.3dov.cn/2016/7/26/0A5AB713C5E7D520D652C5DE8F8B831B_1469534951203.mp4",
                 @"http://app.video.3dov.cn/2017/1/09/9FEC148F4757D2DDA0BD358D928057D2_1483946974860.mp4",
                 @"http://app.video.3dov.cn/2016/12/19/FB39FC7797AC2BAD875DDAC1BF17EC77_1482134005256.mp4",
                 @"http://app.video.3dov.cn/2017/3/10/A7C0FE44B7A56DCBD0154C508D6616E3_1489099434353.mp4",
                 @"http://app.video.3dov.cn/2016/12/19/0F69BFB583E3A6603386B0370797E865_1482136218476.mp4"];
    
    self.mvUrl = self.arr[self.index];
    
    
    self.pw_playerView = [[PW_PlayerVideoView alloc]initWithFrame:CGRectMake(0, 64, kDWidth, MinPlayerHeight) URL:[NSURL URLWithString:self.mvUrl] title:@"哈哈哈哈哈"];
    
    [self.view addSubview:self.pw_playerView];
}

-(void) IJKMPMovieFinishReasonPlaybackEnded{
    
    NSLog(@"IJKMPMovieFinishReasonPlaybackEnded");
    
    [self PlayShutdown];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.index ++;
        NSLog(@"self.index  %ld      %ld",self.index,self.arr.count);
        
        [self.pw_playerView removeFromSuperview];
        if (self.index >= self.arr.count) {
            
            [self deallocNSNotificationCenter];
            return ;
        }else{

            [self playerVideo:self.index];
            
        }
        
    });
    
    
    
}

-(void) deallocNSNotificationCenter{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self PlayShutdown];

}

-(void)PlayShutdown{
[self.pw_playerView.player shutdown];
}
//-(void) viewDidDisappear:(BOOL)animated{
//
//    [self.pw_playerView.player shutdown];
//
//}
@end
