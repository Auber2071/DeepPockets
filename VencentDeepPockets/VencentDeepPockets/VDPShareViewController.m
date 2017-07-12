//
//  VDPShareViewController.m
//  VencentDeepPockets
//
//  Created by hankai on 2017/6/30.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "VDPShareViewController.h"

@interface VDPShareViewController ()

@end

@implementation VDPShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.VDPShareExtension"];
    if ([userDefault boolForKey:@"has-new-share"]) {
        HKSLog(@"宿主App————分享URL:%@",[userDefault valueForKey:@"publicURL"]);
        [userDefault setBool:NO forKey:@"has-new-share"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
