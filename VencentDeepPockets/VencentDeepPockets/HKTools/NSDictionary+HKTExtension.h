//
//  NSDictionary+HKTExtension.h
//  VencentDeepPockets
//
//  Created by hankai on 2018/1/29.
//  Copyright © 2018年 Vencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (HKTExtension)

- (id)getValue:(NSString *)key as:(Class)type;

- (id)getValue:(NSString *)key as:(Class)type defaultValue:(id)defaultValue;

@end
