//
//  VDPStudent.m
//  VencentDeepPockets
//
//  Created by hankai on 2017/6/22.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "VDPStudent.h"

@interface VDPStudent ()

@end

@implementation VDPStudent

-(id)copyWithZone:(NSZone *)zone{
    
    VDPStudent *student = [[[self class] allocWithZone:zone] init];
    student.studentID = _studentID;
    return student;
}
@end
