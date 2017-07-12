//
//  UIScrollView+VDPTouchUp.m
//  VencentDeepPockets
//
//  Created by hankai on 2017/6/15.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "UIScrollView+VDPTouchUp.h"

@implementation UIScrollView (VDPTouchUp)

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![self isMemberOfClass:[UIScrollView class]]) {

    }else{
        [[self nextResponder] touchesBegan:touches withEvent:event];
        if ([super respondsToSelector:@selector(touchesBegan:withEvent:)]) {
            [super touchesBegan:touches withEvent:event];
        }
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![self isMemberOfClass:[UIScrollView class]]) {
        
    }else{
        [[self nextResponder]touchesMoved:touches withEvent:event];
        if ([super respondsToSelector:@selector(touchesMoved:withEvent:)]) {
            [super touchesMoved:touches withEvent:event];
        }
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![self isMemberOfClass:[UIScrollView class]]) {
        
    }else{
        [[self nextResponder]touchesEnded:touches withEvent:event];
        if ([super respondsToSelector:@selector(touchesEnded:withEvent:)]) {
            [super touchesEnded:touches withEvent:event];
        }
    }
}

@end
