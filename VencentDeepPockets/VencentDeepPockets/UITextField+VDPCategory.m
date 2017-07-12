//
//  UITextField+VDPCategory.m
//  VencentDeepPockets
//
//  Created by hankai on 2017/6/15.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "UITextField+VDPCategory.h"

@implementation UITextField (VDPCategory)
- (void)changetext:(NSString *)text {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *start = self.selectedTextRange.start;
    UITextPosition *end = self.selectedTextRange.end;
    NSInteger startIndex = [self offsetFromPosition:beginning toPosition:start];
    NSInteger endIndex = [self offsetFromPosition:beginning toPosition:end];
    NSString *originText = self.text;
    NSString *firstPart = [originText substringToIndex:startIndex];
    NSString *secondPart = [originText substringFromIndex:endIndex];
    
    NSInteger offset;
    
    if (![text isEqualToString:@""]) {
        offset = text.length;
    } else {
        if (startIndex == endIndex) {
            if (startIndex == 0) {
                return;
            }
            offset = -1;
            firstPart = [firstPart substringToIndex:(firstPart.length - 1)];
        } else {
            offset = 0;
        }
    }
    NSString *newText = [NSString stringWithFormat:@"%@%@%@", firstPart, secondPart, text];
    self.text = newText;
    UITextPosition *now = [self positionFromPosition:start offset:offset];
    UITextRange *range = [self textRangeFromPosition:now toPosition:now];
    self.selectedTextRange = range;
}

@end
