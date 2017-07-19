//
//  ViewController.m
//  JIKPlayerVideo
//
//  Created by DFSJ on 17/3/10.
//  Copyright © 2017年 Oriental Horizon. All rights reserved.
//

#import "ViewController.h"
#import "PW_ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *btn = [[UIButton alloc]init];
    
    [btn setTitle:@"播放视频" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 100, 200, 200);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

-(void) btnClick{
    
    PW_ViewController *PW_VC = [[PW_ViewController alloc]init];

    [self.navigationController pushViewController:PW_VC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
