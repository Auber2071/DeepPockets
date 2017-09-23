//
//  VDPUpdateFileViewController.m
//  VencentDeepPockets
//
//  Created by hankai on 2017/8/3.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "VDPUpdateFileViewController.h"
#define kBOUNDARY   @"ABC"
@interface VDPUpdateFileViewController ()

@end

@implementation VDPUpdateFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)uploadFile:(NSString *)urlString fileName:(NSString *)fileName filePath:(NSString *)filePath{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *mutRequest = [NSMutableURLRequest requestWithURL:url];
    
    //设置post
    mutRequest.HTTPMethod = @"post";
    //设置请求头 Content-Type:multipart/form-data; boundary=----WebKitFormBoundarykERdvnmjDlWxWzHF
    [mutRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBOUNDARY] forHTTPHeaderField:@"Content-Type"];
    
    //设置请求体
    mutRequest.HTTPBody = [self makeBody:fileName filePath:filePath];

    [NSURLConnection sendAsynchronousRequest:mutRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            HKSLog(@"链接错误:%@",connectionError);
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200 || httpResponse.statusCode == 304) {
            //解析数据
        }else{
            HKSLog(@"服务器内部错误");
        }
    }];
}

-(NSData *)makeBody:(NSString *)fileName filePath:(NSString *)filePath {
    NSMutableData *data = [NSMutableData data];
    
    //第一部分
    NSMutableString *mString = [NSMutableString string];
    [mString appendFormat:@"--%@\r\n",kBOUNDARY];
    [mString appendFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\n",fileName,[filePath lastPathComponent]];
    [mString appendString:@"Content-Type: image/jpeg\r\n"];
    [mString appendString:@"\r\n"];
    
    [data appendData:[mString dataUsingEncoding:NSUTF8StringEncoding]];
    //第二部分
    //加载文件
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    [data appendData:fileData];
    
    
    //第三部分
    NSString *end = [NSString stringWithFormat:@"\r\n--%@--",kBOUNDARY];
    [data appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    return [data copy];
}

@end
