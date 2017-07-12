//
//  VDPViewController.m
//  VencentDeepPockets
//
//  Created by hankai on 2016/11/25.
//  Copyright © 2016年 Vencent. All rights reserved.
//

#import "VDPViewController.h"
#import "UIScrollView+VDPTouchUp.h"
#import "UITextField+VDPCategory.h"




//*************Test****************
#import "LocationTracker.h"
#import "VDPPersion.h"
#import "FileHash.h"//用于完整性校验
#import "VDPCustomNumberKeyBoard.h"






const CGFloat userTextFieldTag = 10001;
const CGFloat pwdTextFieldTag = 10002;

const NSString *testConst = @"testConst";
@interface VDPViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIImageView *barImageView;
@property (nonatomic, strong) UIScrollView *mainBottomScrollView;



//*************Test****************
@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;

@property (nonatomic, strong) VDPPersion *persion;
@property (nonatomic, assign) CGFloat D_value;
@property (nonatomic, strong) VDPCustomNumberKeyBoard *numberKeyBoardView;
@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *pwdField;

@property (nonatomic, strong) NSString *testString;
@property (nonatomic, assign) int number;

@end

@implementation VDPViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) [self setEdgesForExtendedLayout:UIRectEdgeTop];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanTextFiled:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [self p_designNavigationCorrelationAttribute];
    [self p_designToolBar];
    [self p_searchBar];
    [self p_addMainBottomScrollView];
    
    //NSLog(@"%@",[[NSBundle mainBundle]resourcePath]);
    /********Test***********/
    
    //[self testTargetQueue];
    //[self testFoundationExchangeCoreFoundation];
    //[self testKVO];
    
    
    //对resource完整性校验
    [self addUserNameAndPasswordTextField];
    //[self getBundleFileHash];
    //[self p_testBlock];

    [self testenumDict];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
/**
 设置导航相关属性
 */
-(void)p_designNavigationCorrelationAttribute{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //设置导航标题字体颜色
    NSDictionary *dict = @{NSForegroundColorAttributeName:UIColorFromRGB(0xffffff),NSFontAttributeName:[UIFont systemFontOfSize:20.f]};
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    
    //设置导航颜色
    [self.navigationController.navigationBar setTintColor:[UIColor blueColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blueColor]];
    //设置导航背景为透明色
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    //获取barview中第一层的imageView
    self.barImageView = self.navigationController.navigationBar.subviews.firstObject;
    
}

//设置toolBar
-(void)p_designToolBar{
    //设置naviToolBar
    self.navigationController.toolbarHidden = NO;
    UIImage *toolBarImage = [UIImage imageNamed:@"navi"];
//    [self.navigationController.toolbar setBackgroundImage:toolBarImage forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefaultPrompt];
//    [self.navigationController.toolbar setTintColor:[UIColor orangeColor]];
    
    
    UIBarButtonItem *toolBarItem1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil];
    UIBarButtonItem *toolBarItem2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *toolBarItem3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:nil action:nil];
    UIBarButtonItem *toolBarItemSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[toolBarItemSpace,toolBarItem1,toolBarItemSpace,toolBarItem2,toolBarItemSpace,toolBarItem3,toolBarItemSpace];
}



-(void)p_searchBar{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH - 40, 30)];
    _searchBar.barStyle = UIBarStyleBlack;
    [_searchBar setImage:[UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [_searchBar setPlaceholder:@"请输入搜索"];
    _searchBar.layer.masksToBounds = YES;
    _searchBar.layer.cornerRadius = 15.f;
    
    self.navigationItem.titleView =_searchBar;
}

-(void)p_addMainBottomScrollView{
    self.mainBottomScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [_mainBottomScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 1.5*SCREEN_HEIGHT)];
    [_mainBottomScrollView setBackgroundColor:UIColorFromRGB(0x00ccff)];
    _mainBottomScrollView.delegate = self;
    
    [self.view addSubview:_mainBottomScrollView];
}



#pragma mark - jpg与png互转，并保存到相册
/**
 jpg与png互转，并保存到相册
 */
-(void)p_jpgAndPngExchangeThenSaveToPhotoAlbum{
    [self p_jpgChangeToPng];
    [self p_pngChangeToJpg];
}
/**
 jpg 转 png,并保存到相册
 */
-(void)p_jpgChangeToPng{
    UIImage *image = [UIImage imageNamed:@""];
    
    //jpg->png
    NSData *pngData = UIImagePNGRepresentation(image);
    UIImage *pngImg = [UIImage imageWithData:pngData];
    
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(pngImg, nil, nil, nil);
}

/**
 png 转 jpg，并保存到相册
 */
-(void)p_pngChangeToJpg{
    UIImage *image = [UIImage imageNamed:@""];
    
    //png->Jpg
    NSData *jpgData = UIImageJPEGRepresentation(image,1);
    UIImage *jpgImg = [UIImage imageWithData:jpgData];
    
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(jpgImg, nil, nil, nil);
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //设置导航渐变色
    CGFloat minAlphaOffset = 0;
    CGFloat maxAlphaOffset = CGRectGetHeight(self.view.frame)/2.f;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset)/(maxAlphaOffset - minAlphaOffset);
    
    [self.navigationController.navigationBar setBackgroundImage:[self p_imageWithColor:[[UIColor orangeColor] colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];

}

- (UIImage *)p_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *imgae = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgae;
}



#pragma mark - test

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    HKSLog(@"keyPath:%@,object:%@,change:%@,context:%@",keyPath,object,change,context);
}

- (void)testTargetQueue {
    //1.创建目标队列
    dispatch_queue_t targetQueue = dispatch_queue_create("test.target.queue", DISPATCH_QUEUE_SERIAL);
    
    //2.创建3个串行队列
    dispatch_queue_t queue1 = dispatch_queue_create("test.1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("test.2", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue3 = dispatch_queue_create("test.3", DISPATCH_QUEUE_SERIAL);
    
    //3.将3个串行队列分别添加到目标队列
    dispatch_set_target_queue(queue1, targetQueue);
    dispatch_set_target_queue(queue2, targetQueue);
    dispatch_set_target_queue(queue3, targetQueue);
    
    
    dispatch_async(queue1, ^{
        NSLog(@"1.0 in");
        [NSThread sleepForTimeInterval:3.f];
        NSLog(@"1.0 out");
    });
    
    dispatch_async(queue1, ^{
        NSLog(@"1.1 in");
        [NSThread sleepForTimeInterval:3.f];
        NSLog(@"1.1 out");
    });
    
    dispatch_async(queue1, ^{
        NSLog(@"1.2 in");
        [NSThread sleepForTimeInterval:3.f];
        NSLog(@"1.2 out");
    });
    
    dispatch_async(queue2, ^{
        NSLog(@"2.0 in");
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"2.0 out");
    });
    
    dispatch_async(queue2, ^{
        NSLog(@"2.1 in");
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"2.1 out");
    });
    
    dispatch_async(queue2, ^{
        NSLog(@"2.2 in");
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"2.2 out");
    });
    
    
    dispatch_async(queue2, ^{
        NSLog(@"2.3 in");
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"2.3 out");
    });
    
    dispatch_async(queue3, ^{
        NSLog(@"3.0 in");
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"3.0 out");
    });
    dispatch_async(queue3, ^{
        NSLog(@"3.1 in");
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"3.1 out");
    });
    dispatch_async(queue3, ^{
        NSLog(@"3.2 in");
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"3.2 out");
    });
}

-(void)testKVO{
    self.persion = [[VDPPersion alloc]init];
    self.persion.name = @"DeepPockets";
    
    [self.persion addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:@"person name"];
    
    sleep(5);
    self.persion.name = @"Jhon";
}
-(void)testFoundationExchangeCoreFoundation{
    //Foundation对象转换Core Foundation对象******************ARC
    //所有权Foundation保留
    NSString *testOC = [NSString stringWithFormat:@"test"];
    CFStringRef testC = (__bridge CFStringRef) testOC;
    HKSLog(@"bridge:%@   %@",testOC,testC);
    
    
    //所有权  移交给Core Foundation
    NSString *testOC2 = [NSString stringWithFormat:@"test2"];
    //CFStringRef testC2 = (__bridge_retained CFStringRef) testOC2;
    CFStringRef testC2 = CFBridgingRetain(testOC2);
    HKSLog(@"bridge retain:%@    %@",testOC2,testC2);
    CFRelease(testC2);
    
    //Core Foundation对象转换Foundation对象
    //所有权Core Foundation保留
    CFStringRef testC3 = CFStringCreateWithCString(CFAllocatorGetDefault(), "123456", kCFStringEncodingASCII);
    NSString *testOC3 = (__bridge NSString *)testC3;
    CFRelease(testC3);
    
    //所有权移交 Foundation
    CFStringRef testC4 = CFStringCreateWithCString(CFAllocatorGetDefault(), "123456", kCFStringEncodingASCII);
    //NSString *testOC4 = (__bridge_transfer NSString *)testC4;
    NSString *testOC4 = CFBridgingRelease(testC4);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//获得所有资源文件名
-(NSArray *)allFilesAtPath:(NSString *)dir{
    NSMutableArray * arr = [NSMutableArray array];
    NSFileManager * manager = [NSFileManager defaultManager];
    NSArray *temp = [manager contentsOfDirectoryAtPath:dir error:nil];
    
    for (NSString * fileName in temp) {
        BOOL flag = YES;
        NSString * fullpath = [dir stringByAppendingPathComponent:fileName];
        if ([manager fileExistsAtPath:fullpath isDirectory:&flag]) {
            if (!flag ) {
                [arr addObject:fileName];
            }
        }
    }
    return arr;
}

//生成资源文件名及对应的hash的字典， eg:@{@"appicon":@"wegdfser45t643232324234"}；
-(NSDictionary *)getBundleFileHash{
    NSMutableDictionary * dicHash = [NSMutableDictionary dictionary];
    NSArray * fileArr = [self allFilesAtPath:[[NSBundle mainBundle]resourcePath]];
    for (NSString * fileName in fileArr) {
        //对应的文件生成hash
        NSString * HashString = [FileHash md5HashOfFileAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName]];
        if (HashString != nil) {
            [dicHash setObject:HashString forKey:fileName];
        }
    }
    //所有资源文件的hash就保存在这数组里
    return dicHash;
}






-(void)addUserNameAndPasswordTextField{
    self.numberKeyBoardView = [VDPCustomNumberKeyBoard shareNumberKeyBoard];
    UIEdgeInsets textFieldInsets = UIEdgeInsetsMake(150, 50, 0, 50);
    
    self.userNameField = [[UITextField alloc]init];
    _userNameField.delegate = self;
    _userNameField.tag = userTextFieldTag;
    _userNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _userNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    _userNameField.borderStyle = UITextBorderStyleRoundedRect;
    _userNameField.placeholder = @"请输入用户名";
    [_userNameField setFrame:CGRectMake(textFieldInsets.left, textFieldInsets.top, SCREEN_WIDTH - textFieldInsets.left - textFieldInsets.right, 40)];
    [self.mainBottomScrollView addSubview:_userNameField];
    
    
    self.pwdField = [[UITextField alloc]init];
    _pwdField.delegate = self;
    _pwdField.secureTextEntry = NO;
    _pwdField.tag = pwdTextFieldTag;
    //_pwdField.inputView = _numberKeyBoardView;
    _pwdField.borderStyle = UITextBorderStyleRoundedRect;
    _pwdField.placeholder = @"请输入密码";
    [_pwdField setFrame:CGRectMake(CGRectGetMinX(_userNameField.frame), CGRectGetMaxY(_userNameField.frame)+10, CGRectGetWidth(_userNameField.frame), CGRectGetHeight(_userNameField.frame))];
    [self.mainBottomScrollView addSubview:_pwdField];
    
}

//当用户按下return键或者按回车键，keyboard消失
#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.tag != pwdTextFieldTag) return YES;
    
    self.numberKeyBoardView.completeBlock = ^(NSString *btnText,NSInteger btnTag){
        if (btnTag == 9 && textField.text.length > 0) {
            textField.text = [textField.text substringToIndex:textField.text.length - 1];
        }else if (btnTag != 9){
            [textField changetext:btnText];
        }
    };
    return YES;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.searchBar resignFirstResponder];
}

-(void)showKeyBoard:(NSNotification *)notification{
    self.mainBottomScrollView.scrollEnabled = NO;
    HKSLog(@"showKeyBoard Notification name:%@,userInfo:%@",notification.name,notification.userInfo);
    NSDictionary *tempDict = notification.userInfo;
    NSValue *beginFrame = [tempDict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyBoardBeginFrame = [beginFrame CGRectValue];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    id firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    CGRect tempFrame = CGRectZero;
    
    if ([firstResponder isMemberOfClass:[UITextField class]]) {
        UITextField *tempField = (UITextField *)firstResponder;
        tempFrame = tempField.frame;
        HKSLog(@"firstResponder orgin x:%f  y:%f",tempField.frame.origin.x,tempField.frame.origin.y);
    }
    
    if ((CGRectGetMaxY(tempFrame) - self.mainBottomScrollView.contentOffset.y) >CGRectGetMinY(keyBoardBeginFrame)) {
        self.D_value = 0.f;
        self.D_value = CGRectGetMaxY(tempFrame) - CGRectGetMinY(keyBoardBeginFrame);
        CGPoint tempOffSet = self.mainBottomScrollView.contentOffset;
        tempOffSet.y += self.D_value;
    
        NSValue *animationDurationValue = [tempDict objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        
        [UIView animateWithDuration:animationDuration animations:^{
            self.mainBottomScrollView.contentOffset = tempOffSet;
        }];
    }
}

-(void)hideKeyBoard:(NSNotification *)notification{
    self.mainBottomScrollView.scrollEnabled = YES;
    HKSLog(@"hideKeyBoard Notification name:%@,userInfo:%@",notification.name,notification.userInfo);
    CGPoint tempOffSet = self.mainBottomScrollView.contentOffset;
    tempOffSet.y -= self.D_value;
    
    
    NSDictionary *tempDict = notification.userInfo;
    NSValue *animationDurationValue = [tempDict objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.mainBottomScrollView.contentOffset = tempOffSet;
    } completion:^(BOOL finished) {
        self.D_value = 0.f;
    }];
}

-(void)cleanTextFiled:(NSNotification *)notification{
    self.userNameField.text = @"";
    self.pwdField.text = @"";
}


-(void)p_testBlock{
    _number = 1;
    _testString = @"1";
    [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        _testString = @"2";
        _number = 3;
        HKSLog(@"%@,%d",_testString,_number);
        
    }];
    HKSLog(@"%@",_testString);
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

/*
 name:UIKeyboardWillShowNotification,
 userInfo:{
 UIKeyboardAnimationCurveUserInfoKey = 7;
 UIKeyboardAnimationDurationUserInfoKey = "0.25";
 UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {320, 253}}";
 UIKeyboardCenterBeginUserInfoKey = "NSPoint: {160, 694.5}";
 UIKeyboardCenterEndUserInfoKey = "NSPoint: {160, 441.5}";
 UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 568}, {320, 253}}”;
 UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 315}, {320, 253}}”;
 UIKeyboardIsLocalUserInfoKey = 1;
 }

 
 name:UIKeyboardWillHideNotification,
 userInfo:{
 UIKeyboardAnimationCurveUserInfoKey = 7;
 UIKeyboardAnimationDurationUserInfoKey = "0.25";
 UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {320, 253}}";
 UIKeyboardCenterBeginUserInfoKey = "NSPoint: {160, 441.5}";
 UIKeyboardCenterEndUserInfoKey = "NSPoint: {160, 694.5}";
 UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 315}, {320, 253}}";
 UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 568}, {320, 253}}";
 UIKeyboardIsLocalUserInfoKey = 1;
 }
 */


-(void)testenumDict{
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
    [mutDict setValue:@"1111" forKey:@"test1"];
    [mutDict setValue:@"2222" forKey:@"test2"];
    [mutDict setValue:@"3333" forKey:@"test3"];
    [mutDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        HKSLog(@"%@",key);
        [mutDict removeObjectForKey:key];
        HKSLog(@"%@",mutDict);
    }];

    
}

@end
