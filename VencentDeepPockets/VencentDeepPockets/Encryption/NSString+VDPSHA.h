//
//  NSString+VDPSHA.h
//  VencentDeepPockets
//
//  Created by hankai on 2016/11/25.
//  Copyright © 2016年 Vencent. All rights reserved.
//  MD5、SH1、SH224、SH256、SH384、SH512 编码

#import <Foundation/Foundation.h>

/**
 SHA即Secure Hash Algorithm（安全散列算法)
 有多种不同位数的实现，常见的有SHA224/SHA256/SHA384/SHA512等
 */
@interface NSString (VDPSHA)
/// 返回结果：32长度(128位，16字节，16进制字符输出则为32字节长度)   终端命令：md5 -s "123"
- (NSString *)md5Hash;

/// 返回结果：40长度   终端命令：echo -n "123" | openssl sha -sha1
- (NSString *)sha1Hash;

/// 返回结果：56长度   终端命令：echo -n "123" | openssl sha -sha224
- (NSString *)sha224Hash;

/// 返回结果：64长度   终端命令：echo -n "123" | openssl sha -sha256
- (NSString *)sha256Hash;

/// 返回结果：96长度   终端命令：echo -n "123" | openssl sha -sha384
- (NSString *)sha384Hash;

/// 返回结果：128长度   终端命令：echo -n "123" | openssl sha -sha512
- (NSString *)sha512Hash;

#pragma mark - HMAC

/// 返回结果：32长度  终端命令：echo -n "123" | openssl dgst -md5 -hmac "123"
- (NSString *)hmacMD5WithKey:(NSString *)key;

/// 返回结果：40长度   echo -n "123" | openssl sha -sha1 -hmac "123"
- (NSString *)hmacSHA1WithKey:(NSString *)key;
- (NSString *)hmacSHA224WithKey:(NSString *)key;
- (NSString *)hmacSHA256WithKey:(NSString *)key;
- (NSString *)hmacSHA384WithKey:(NSString *)key;
- (NSString *)hmacSHA512WithKey:(NSString *)key;
@end
