//
//  VDPScreenShotWarning.m
//  VencentDeepPockets
//
//  Created by hankai on 2017/6/21.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "VDPScreenShotWarning.h"
#import <UIKit/UIKit.h>



@implementation VDPScreenShotWarning

+(instancetype)shareVDPScreenShotWarning{
    static VDPScreenShotWarning *screenShotWarning = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (screenShotWarning == nil) {
            screenShotWarning = [[self alloc] init];
        }
    });
    return screenShotWarning;
}

-(void)checkScreenShot{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(warningMethod:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];//截屏提示
}

//截屏警告
-(void)warningMethod:(NSNotificationCenter *)notification{
    NSString *warningStr = @"可能有恶意软件对您的操作截屏，请谨慎操作！";
    [self alertMessageWith:warningStr content:@"截屏警告" btnName:@"忽略"];
}

-(void)alertMessageWith:(NSString *)title content:(NSString *)content btnName:(NSString *)btnName{
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:title message:content delegate:nil cancelButtonTitle:btnName otherButtonTitles: nil];
    [alertV show];
}
@end
