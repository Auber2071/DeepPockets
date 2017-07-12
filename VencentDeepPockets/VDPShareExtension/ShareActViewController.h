//
//  ShareActViewController.h
//  VencentDeepPockets
//
//  Created by hankai on 2017/7/12.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareActViewController : UIViewController

- (void)onSelected:(void(^)(NSIndexPath *indexPath))handler;

@end
