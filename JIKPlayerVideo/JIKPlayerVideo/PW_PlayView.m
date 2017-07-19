//
//  PW_PlayView.m
//  JIKPlayerVideo
//
//  Created by DFSJ on 17/3/10.
//  Copyright © 2017年 Oriental Horizon. All rights reserved.
//

#import "PW_PlayView.h"

@implementation PW_PlayView

-(instancetype) initWithFrame:(CGRect)frame{


    if (self = [super initWithFrame:frame]) {
        
        self.bounds = frame;
        
        CGFloat Y = (40-30)/2;
        CGFloat H = 30;
        
        // 暂停
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playButton.frame = CGRectMake(0, 0, 33, 40);
        [self.playButton setImage:[UIImage imageNamed:@"suspend"] forState:(UIControlStateNormal)];
        [self.playButton setImage:[UIImage imageNamed:@"播放"] forState:(UIControlStateSelected)];
        self.playButton.selected = NO;
        self.playButton.layer.shadowColor = [UIColor blackColor].CGColor;
        self.playButton.layer.shadowOffset = CGSizeMake(0, 0);
        self.playButton.layer.shadowOpacity = 0.5;
        self.playButton.layer.shadowRadius = 1;
        [self addSubview:self.playButton];

        
        //播放时间
        self.playDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.playButton.frame) + 5,Y, 90, H)];
        
        self.playDurationLabel.backgroundColor = [UIColor orangeColor];
        self.playDurationLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.playDurationLabel];
        self.playDurationLabel.textColor = [UIColor redColor];
        
        
        //视频总时间
        self.duartionLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 90, Y, 90, H)];
        self.duartionLabel.backgroundColor = [UIColor redColor];
        self.duartionLabel.textAlignment = NSTextAlignmentCenter;
        self.duartionLabel.textColor = [UIColor orangeColor];
        [self addSubview:self.duartionLabel];
        
       //进度条
        self.slider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.playDurationLabel.frame), Y, ([UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(self.playDurationLabel.frame) - 90), H)];
        [self.slider setThumbImage:[UIImage imageNamed:@"BFJinDuTiao"] forState:UIControlStateNormal];
        self.slider.minimumTrackTintColor=[UIColor orangeColor];
        [self addSubview:self.slider];

        
    }
    return self;
}
@end
