//
//  PW_ProgressView.h
//  JIKPlayerVideo
//
//  Created by DFSJ on 17/3/10.
//  Copyright © 2017年 Oriental Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>


static const CGFloat kVideoTimeIndicatorViewSide = 96;
static const CGFloat kViewSpacing = 15.0;
static const CGFloat kTimeIndicatorAutoFadeOutTimeInterval = 1.0;

@interface PW_ProgressView : UIView

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIImageView *arrowImageView;
@end
