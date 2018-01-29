//
//  UIBarButtonItem+HKTExtension.m
//  VencentDeepPockets
//
//  Created by hankai on 2018/1/29.
//  Copyright © 2018年 Vencent. All rights reserved.
//

#import "UIBarButtonItem+HKTExtension.h"
#import "UIView+HKTExtension.h"

@implementation UIBarButtonItem (HKTExtension)

/**
 *  没有图片调整的按钮
 */
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

/**
 *  按钮为圆形
 */
+(instancetype)cycloItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:highImage forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    button.layer.cornerRadius = button.width/2.f;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

/**
 返回没有调整图片
 
 @param imageName 正常图片名称
 @param highImageName 高亮图片名称
 */
+ (instancetype)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage: [UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    //button.adjustsImageWhenHighlighted = NO;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

/**
 *  没有文字调整的按钮
 */
+ (instancetype)itemWithName:(NSString *)Name font:(CGFloat)font backcolor:(UIColor *)backcolor titleColor:(UIColor *)titleColor target:target action:(SEL)action
{
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn setTitle:Name forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setBackgroundColor:backcolor];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.adjustsImageWhenHighlighted = NO;
    return [[self alloc] initWithCustomView:btn];
}


@end
