//
//  UIImage+HKTExtension.h
//  VencentDeepPockets
//
//  Created by hankai on 2018/1/29.
//  Copyright © 2018年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HKTExtension)
/**
 UIColor转UIImage
 */
+ (instancetype)createImageWithColor:(UIColor *)color;

/**
 *  根据宽度进行比例压缩返回小图片
 *
 *  @param width 指定图片宽
 */
- (UIImage *)scaleImageWithWidth:(CGFloat)width;


+ (instancetype)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;


/**
 *  获取屏幕截图
 *
 *  @return 屏幕截图图像
 */
+ (UIImage *)screenShot;
@end
