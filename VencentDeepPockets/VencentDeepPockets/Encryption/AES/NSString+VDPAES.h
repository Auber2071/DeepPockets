//
//  NSString+VDPAES.h
//  VencentDeepPockets
//
//  Created by hankai on 2016/11/25.
//  Copyright © 2016年 Vencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (VDPAES)
//AES256
-(NSString *)aes256_encrypt:(NSString *)key;
-(NSString *)aes256_decrypt:(NSString *)key;
@end
