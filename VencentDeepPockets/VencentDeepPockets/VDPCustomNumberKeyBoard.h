//
//  VDPCustomNumberKeyBoard.h
//  VencentDeepPockets
//
//  Created by hankai on 2017/6/15.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol VDPCustomNumberKeyBoardDelegate <NSObject>

-(void)changeTextField:(UITextField *)textField;

@end



@interface VDPCustomNumberKeyBoard : UIView
- (instancetype)initWithFrame:(CGRect)frame;

+(instancetype)shareNumberKeyBoard;
typedef void (^VDPKeyBoardCompletedBlock)(NSString *btnText,NSInteger btnTag);
@property (nonatomic,copy)VDPKeyBoardCompletedBlock completeBlock;



@end
