//
//  NSData+VDPAES.h
//  VencentDeepPockets
//
//  Created by hankai on 2016/11/25.
//  Copyright © 2016年 Vencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (VDPAES)
//AES256
-(NSData *)aes256_encrypt:(NSString *)key;
-(NSData *)aes256_decrypt:(NSString *)key;
@end
