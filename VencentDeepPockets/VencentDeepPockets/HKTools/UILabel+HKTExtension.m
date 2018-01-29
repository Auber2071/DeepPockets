//
//  UILabel+HKTExtension.m
//  VencentDeepPockets
//
//  Created by hankai on 2018/1/29.
//  Copyright © 2018年 Vencent. All rights reserved.
//

#import "UILabel+HKTExtension.h"

@implementation UILabel (HKTExtension)

+ (instancetype)labelWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font backColor:(UIColor *)backColor{
    return [self labelWithTitle:title color:color font:font backColor:backColor alignment:NSTextAlignmentCenter];
}

+ (instancetype)labelWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font backColor:(UIColor *)backColor alignment:(NSTextAlignment)alignment
{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = color;
    label.backgroundColor = backColor;
    label.font = font;
    label.numberOfLines = 0;
    label.textAlignment = alignment;
    return label;
}
@end
