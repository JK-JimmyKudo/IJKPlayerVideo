//
//  PW_PlayView.h
//  JIKPlayerVideo
//
//  Created by DFSJ on 17/3/10.
//  Copyright © 2017年 Oriental Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PW_PlayView : UIView
//总时长
@property (nonatomic,strong) UILabel *duartionLabel;
//播放时长
@property (nonatomic,strong) UILabel *playDurationLabel;

@property (nonatomic,strong) UISlider *slider;

@property (nonatomic,strong) UIButton *playButton;


@end
