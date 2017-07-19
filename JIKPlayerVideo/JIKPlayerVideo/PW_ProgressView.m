//
//  PW_ProgressView.m
//  JIKPlayerVideo
//
//  Created by DFSJ on 17/3/10.
//  Copyright © 2017年 Oriental Horizon. All rights reserved.
//

#import "PW_ProgressView.h"

@implementation PW_ProgressView

-(instancetype) initWithFrame:(CGRect)frame{


    if (self = [super initWithFrame:frame]) {
        
        self.arrowImageView = [[UIImageView alloc]init];
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 44)/2, 0, 44, 24)];
        
        _arrowImageView.backgroundColor = [UIColor redColor];
        [self addSubview:_arrowImageView];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_arrowImageView.frame) + 5, kVideoTimeIndicatorViewSide, 12)];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor orangeColor];
        [self addSubview:_timeLabel];
        
    }

    return self;
}

@end
