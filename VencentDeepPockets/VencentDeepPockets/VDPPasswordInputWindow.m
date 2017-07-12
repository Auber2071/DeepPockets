//
//  VDPPasswordInputWindow.m
//  VencentDeepPockets
//
//  Created by hankai on 2017/5/21.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "VDPPasswordInputWindow.h"

@implementation VDPPasswordInputWindow

+(VDPPasswordInputWindow *)sharedInstance{
    static VDPPasswordInputWindow *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedInstance;
}
-(void)show{
    [self makeKeyWindow];
    self.hidden = NO;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *img = [UIImage imageNamed:@"iPhonePortraitiOS89_414x736pt@3x"];
        UIImageView *imgView = [[UIImageView alloc]init];
        [imgView setImage:img];
        [imgView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imgView.userInteractionEnabled = YES;
        [self addSubview:imgView];
        
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"进入" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setFrame:CGRectMake((SCREEN_WIDTH - 80)/2.f, SCREEN_HEIGHT - 120, 80, 40)];
        [btn.layer setCornerRadius:5.f];
        [btn.layer setBorderColor:[UIColor grayColor].CGColor];
        [btn.layer setBorderWidth:1.f];
        
        [btn addTarget:self action:@selector(completeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:btn];
    }
    return self;
}
-(void)completeButtonPressed:(UIButton *)sender{
    [self resignKeyWindow];
    self.hidden = YES;
}


@end
