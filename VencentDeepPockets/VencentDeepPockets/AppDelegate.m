//
//  AppDelegate.m
//  VencentDeepPockets
//
//  Created by hankai on 2016/11/25.
//  Copyright © 2016年 Vencent. All rights reserved.
//

#import "AppDelegate.h"
#import "VDPPasswordInputWindow.h"//对window的使用
#import "VDPIndexViewController.h"//主控制器
#import "VDPPrisonBreakWarning.h"
#import "VDPScreenShotWarning.h"



/*
 *极光推送
 */
#import "JPUSHService.h"// 引入JPush功能所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>// iOS10注册APNs所需头文件
#endif

static NSString *appKey = @"";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

/*
 * 友盟分享
 */
#import <UMSocialCore/UMSocialCore.h>//友盟分享(微信、QQ、新浪微博、短信、邮件)

#define USHARE_APPKEY @"59238fb9734be47ebc001c4c"//百宝袋 友盟分享appKey


@interface AppDelegate ()<JPUSHRegisterDelegate>
@property (nonatomic, strong) VDPScreenShotWarning *screenShotObj;

@end

@implementation AppDelegate


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    /*
    annotation method——url:MainDemoWebToDeepPockets://aciton?params=1$second=2
    URLquery:params=1$second=2
    sourceApplication:com.bonc.MainDemoWeb
    */
    HKSLog(@"\nannotation method——url:%@",url);
    HKSLog(@"\nURLquery:%@",[url query]);
    HKSLog(@"\nsource Application BundleID:%@",sourceApplication);
    
    if ([url.scheme isEqualToString:@"MainDemoWebToDeepPockets"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(500 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[[NSNotificationCenter defaultCenter] postNotificationName:<#(nonnull NSNotificationName)#> object:nil];
        });
    }
    return YES;
}


-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    /*
    options method——url:MainDemoWebToDeepPockets://aciton?params=1$second=2
    URLquery:params=1$second=2
    source applicationID:com.bonc.MainDemoWeb
     //网页调用app时会取值
    UIApplicationOpenURLOptionsOpenInPlaceKey :
     */
    
    /*
     safari 调用
    options method——url:    maindemowebtodeeppockets://com.Vencent.VencentDeepPockets
    URLquery:(null)
    source application BundleID:    com.apple.mobilesafari
    UIApplicationOpenURLOptionsOpenInPlaceKey :0
     */
    
    HKSLog(@"options method——url:%@",url);
    HKSLog(@"URLquery:%@",[url query]);
    HKSLog(@"source application BundleID:%@",[options objectForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"]);
    HKSLog(@"UIApplicationOpenURLOptionsOpenInPlaceKey :%@",[options objectForKey:@"UIApplicationOpenURLOptionsOpenInPlaceKey"]);
    //NSArray *array = [[url query] componentsSeparatedByString:@"="];
    //进行字符串的拆分，通过&来拆分，把每个参数分开
    
    if ([[url query] containsString:@"&"]) {
        
    }else if([[url query] containsString:@"="]){
        
    }
    
    
    NSRange range = [[url query] rangeOfString:@"&"];
    if (range.location != NSNotFound) {
        //ios7系统下也适用
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@")application:(UIApplication *)app openURL:(NSURL *)url options:" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];

    
    NSArray *subArray = [[url query] componentsSeparatedByString:@"&"];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (int j = 0 ; j < subArray.count; j++) {
        NSArray *dicArray = [subArray[j] componentsSeparatedByString:@"="];
        [tempDic setObject:dicArray[1] forKey:dicArray[0]];
    }
    HKSLog(@"打印参数列表生成的字典：\n%@", tempDic);

    return YES;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#pragma clang diagnostic push
#pragma clang diagnostic ignored    "-Warc-performSelector-leaks"
    id overlayClass =NSClassFromString(@"UIDebuggingInformationOverlay");
    [overlayClass performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];
#pragma clang diagnostic pop
    
    /*******************************************************************************************/
    #pragma mark - 初始化友盟分享
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_APPKEY];
    [self configUSharePlatforms];
    [self confitUShareSettings];
    
    
    /*******************************************************************************************/
    #pragma mark - 创建Window
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    VDPIndexViewController *VC = [[VDPIndexViewController alloc] init];
    VDPNavigationController *naviV = [[VDPNavigationController alloc]initWithRootViewController:VC];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = naviV;
    [self.window makeKeyAndVisible];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"didFinishLaunchingWithOptions" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    
    /******************************************************************************************/
    #pragma mark - 极光推送      添加初始化APNs代码
    // Required
    // notice: 3.0.0及以后版本注册可以这样写，也可以继续 旧的注册 式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加 定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    #pragma mark - 添加初始化JPush代码
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使 IDFA直接传nil
    // 如需继续使 pushConfig.plist 件声明appKey等配置内容，请依旧使 [JPUSHService setupWithOption:launchOptions] 式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
        }else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
    /******************************************************************************************/
    #pragma mark - 检测越狱
    //VDPPrisonBreakWarning *prisonBreakWarning = [VDPPrisonBreakWarning new];
    //[prisonBreakWarning checkPrisonBreak];//检测越狱
    
    /******************************************************************************************/
    
    
    HKSLog(@"程序已经启动：DidFinishLaunching");
//    self.screenShotObj = [VDPScreenShotWarning shareVDPScreenShotWarning];
//    [self.screenShotObj checkScreenShot];
    
    [self launchAnimation];
    return YES;
}

#pragma mark - 启动图动画

- (void)launchAnimation {
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen1" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    
    UIView *launchView = viewController.view;
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    launchView.frame = mainWindow.frame;
    [mainWindow addSubview:launchView];
    
    [UIView animateWithDuration:0.5f delay:1.f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        launchView.alpha = 0.0f;
        launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0f, 2.0f, 1.0f);
    } completion:^(BOOL finished) {
        [launchView removeFromSuperview];
    }];
    //*****************************LaunchImage*****************************
    /*
    CGSize viewSize = self.window.bounds.size;
    NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
    NSString *launchImage = nil;
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    UIImageView *launchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    launchImageView.frame = self.window.bounds;
    launchImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.window addSubview:launchImageView];
    
    [UIView animateWithDuration:2.0f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
         launchImageView.alpha = 0.0f;
         launchImageView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
    } completion:^(BOOL finished) {
         [launchImageView removeFromSuperview];
    }];
     */
}


//禁用扩展(Extension),如：三方键盘(搜狗输入法)
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(UIApplicationExtensionPointIdentifier)extensionPointIdentifier{
    
    return YES;
}




#pragma mark - 注册APNs成功并上报DeviceToken
//请在AppDelegate.m实现该回调 法并添加回调 法中的代码
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

//Optional  注册APNs失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark - JPUSHRegisterDelegate    添加处理APNs通知回调方法
//请在AppDelegate.m实现该回调方法并添加回调方法中的代码
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }else{
        //本地通知
        UNNotificationRequest *request = notification.request; // 收到推送的请求
        UNNotificationContent *content = request.content; // 收到推送的消息内容
        
        NSNumber *badge = content.badge;  // 推送消息的角标
        NSString *body = content.body;    // 推送消息体
        UNNotificationSound *sound = content.sound;  // 推送消息的声音
        NSString *subtitle = content.subtitle;  // 推送消息的副标题
        NSString *title = content.title;  // 推送消息的标题
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }

    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }else{
        //本地通知
        UNNotificationRequest *request = response.notification.request; // 收到推送的请求
        UNNotificationContent *content = request.content; // 收到推送的消息内容
        
        NSNumber *badge = content.badge;  // 推送消息的角标
        NSString *body = content.body;    // 推送消息体
        UNNotificationSound *sound = content.sound;  // 推送消息的声音
        NSString *subtitle = content.subtitle;  // 推送消息的副标题
        NSString *title = content.title;  // 推送消息的标题
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler();// 系统要求执行这个方法
}
#endif



#pragma mark - 收到远程推送
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1

//此方法，前台、后台、退出 都会调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {//此方法调用完需要调用completionHandler()方法
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    if (application.applicationState == UIApplicationStateActive) {
        /**
         userInfo 字典，2个键值对，
         第二个为
         aps={
            alert = xxxxx；
            badge = 角标;
            sound = default;
         }
         */
        NSDictionary *apsDict = userInfo[@"aps"];
        NSDictionary *alertDict = apsDict[@"alert"];
        if (alertDict.count != 0) {
            NSString *titleStr = [NSString stringWithFormat:@"%@",alertDict[@"title"]];
            NSString *bodyStr = [NSString stringWithFormat:@"%@",alertDict[@"body"]];
            UIAlertView *aleartView = [[UIAlertView alloc]initWithTitle:titleStr message:bodyStr delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [aleartView show];
        }
    }

    /**
     告知是否处理成功，默认传UIBackgroundFetchResultNewData就可以
     UIBackgroundFetchResultNewData,
     UIBackgroundFetchResultNoData,
     UIBackgroundFetchResultFailed
     */
    completionHandler(UIBackgroundFetchResultNewData);
    
}//此方法实现后，需要打开，Capabilities——>BackgroundModes——>remote notification
#endif

//此方法,前台、后台 才会调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    if (application.applicationState == UIApplicationStateActive) {
        NSDictionary *apsDict = userInfo[@"aps"];
        NSDictionary *alertDict = apsDict[@"alert"];
        if (alertDict.count != 0) {
            NSString *titleStr = [NSString stringWithFormat:@"%@",alertDict[@"title"]];
            NSString *bodyStr = [NSString stringWithFormat:@"%@",alertDict[@"body"]];
            UIAlertView *aleartView = [[UIAlertView alloc]initWithTitle:titleStr message:bodyStr delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [aleartView show];
        }
    }
}




#pragma mark - UShare
- (void)confitUShareSettings{
    
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

- (void)configUSharePlatforms{
    
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://Ymobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
}



#pragma mark -

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    HKSLog(@"将要释放激活：WillResignActive")
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    [JPUSHService setBadge:0];
    [JPUSHService resetBadge];
    [application setApplicationIconBadgeNumber:0];
    HKSLog(@"已经进入后台：DidEnterBackground");
    

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

    [application setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    [JPUSHService resetBadge];

    [[VDPPasswordInputWindow sharedInstance] show];
    HKSLog(@"将要进入前台:WillEnterForeground");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    HKSLog(@"已经激活：DidBecomeActive");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    HKSLog(@"程序将要终止：WillTerminate");
}


@end
