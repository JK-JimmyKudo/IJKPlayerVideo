//
//  PW_PlayerVideoView.h
//  JIKPlayerVideo
//
//  Created by DFSJ on 17/3/10.
//  Copyright © 2017年 Oriental Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface PW_PlayerVideoView : UIView

@property (atomic, retain) id <IJKMediaPlayback> player;
@property (nonatomic,copy)NSString * imageUrl;
@property (nonatomic,copy)NSString *playDuration;

- (instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)url title:(NSString *)title;

- (void)playerWillShow;
- (void)playerWillHide;


@end
