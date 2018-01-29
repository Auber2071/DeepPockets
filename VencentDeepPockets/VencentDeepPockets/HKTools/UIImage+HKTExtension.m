//
//  UIImage+HKTExtension.m
//  VencentDeepPockets
//
//  Created by hankai on 2018/1/29.
//  Copyright © 2018年 Vencent. All rights reserved.
//

#import "UIImage+HKTExtension.h"
#import "UIView+HKTExtension.h"

@implementation UIImage (HKTExtension)

/**
 UIColor转UIImage
 */
+ (instancetype)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage *)scaleImageWithWidth:(CGFloat)width {
    CGSize size = self.size;
    
    CGFloat scaleWidth = width;
    CGFloat scaleHeight = (scaleWidth / size.width) * size.height;
    CGSize scaleSize = CGSizeMake(scaleWidth, scaleHeight);
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(scaleSize);
    CGRect rectDraw = CGRectMake(0, 0, scaleWidth, scaleHeight);
    [self drawInRect:rectDraw];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}



+ (instancetype)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 1.加载原图
    UIImage *oldImage = image;
    
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width + 2 * borderWidth;
    CGFloat imageH = oldImage.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    UIImage *newImage = [UIImage circleImageWithImage:[UIImage imageNamed:name] borderWidth:borderWidth borderColor:borderColor];
    return newImage;
}


/**
 *  获取屏幕截图
 *
 *  @return 屏幕截图图像
 */
+ (UIImage *)screenShot {
    // 1. 获取到窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 2. 开始上下文
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, YES, 0);
    
    // 3. 将 window 中的内容绘制输出到当前上下文
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
    
    // 4. 获取图片
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5. 关闭上下文
    UIGraphicsEndImageContext();
    
    return screenShot;
}
@end
