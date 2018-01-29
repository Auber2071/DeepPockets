//
//  UIBarButtonItem+HKTExtension.h
//  VencentDeepPockets
//
//  Created by hankai on 2018/1/29.
//  Copyright © 2018年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (HKTExtension)

/**
 没有图片调整的按钮

 @param image 正常图
 @param highImage 高亮图
 */
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;


/**
 按钮为圆形
 
 @param image 正常图
 @param highImage 高亮图
 */
+(instancetype)cycloItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;


/**
 返回没有调整图片
 
 @param imageName 正常图片名称
 @param highImageName 高亮图片名称
 */
+ (instancetype)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:target action:(SEL)action;


/**
 没有文字调整的按钮
 */
+ (instancetype)itemWithName:(NSString *)Name font:(CGFloat)font backcolor:(UIColor *)backcolor titleColor:(UIColor *)titleColor target:target action:(SEL)action;

@end
