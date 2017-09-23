//
//  VDPSeparateNaviViewController.m
//  VencentDeepPockets
//
//  Created by hankai on 2017/8/23.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "VDPSeparateNaviViewController.h"

@interface VDPSeparateNaviViewController ()

@end

@implementation VDPSeparateNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) [self setEdgesForExtendedLayout:UIRectEdgeTop];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi750.png"]];
    [imageView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [self.view addSubview:imageView];
    
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back.png"]];
    [backImageView setFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+4, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-68)];
    [self.view addSubview:backImageView];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
