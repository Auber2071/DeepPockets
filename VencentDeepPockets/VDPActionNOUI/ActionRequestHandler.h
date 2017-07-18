//
//  http://www.jianshu.com/p/37f23426bb04
//  ActionRequestHandler.h
//  VDPActionNOUI
//
//  Created by hankai on 2017/7/13.
//  Copyright © 2017年 Vencent. All rights reserved.
//  扩展处理类的头文件，对处理类型的声明描述。

#import <UIKit/UIKit.h>

// NSExtensionRequestHandling 是无UI的扩展对象必须要实现的协议，否则无法向处理类返回正确的回调。
@interface ActionRequestHandler : NSObject <NSExtensionRequestHandling>

@end
