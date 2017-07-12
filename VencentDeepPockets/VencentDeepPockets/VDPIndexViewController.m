//
//  VDPMainViewController.m
//  VencentDeepPockets
//
//  Created by hankai on 2017/6/19.
//  Copyright © 2017年 Vencent. All rights reserved.
//
//  http://www.jianshu.com/p/213702004d0d

#import "VDPIndexViewController.h"

#define kCellName   @"CellName"
#define kCellClassName  @"CellClassName"
#define kIsXib  @"isXib"

#define dataSourceArr   @[\
@{kCellName:@"导航颜色渐变&自定义数字键盘",kCellClassName:@"VDPViewController",kIsXib:@"NO"},\
@{kCellName:@"Xib StackView",kCellClassName:@"VDPStackViewController",kIsXib:@"YES"},\
@{kCellName:@"Code StackView",kCellClassName:@"VDPCodeStackViewController",kIsXib:@"NO"},\
@{kCellName:@"今日列表App Extension",kCellClassName:@"VDPAppExtensionViewController",kIsXib:@"NO"},\
@{kCellName:@"分享App Extension",kCellClassName:@"VDPShareViewController",kIsXib:@"YES"}\
]

@interface VDPIndexViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)  UITableView *tableView;

@end

@implementation VDPIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self p_addTableView];
    //[self checkScreenShot];

}

-(void)designRightNavItem{

}
-(void)checkScreenShot{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(warningMethod:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];//截屏提示
}

//截屏警告
-(void)warningMethod:(NSNotificationCenter *)notification{
    NSString *warningStr = @"可能有恶意软件对您的操作截屏，请谨慎操作！";
    [self alertMessageWith:warningStr content:@"截屏警告" btnName:@"忽略"];
}

-(void)alertMessageWith:(NSString *)title content:(NSString *)content btnName:(NSString *)btnName{
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:title message:content delegate:nil cancelButtonTitle:btnName otherButtonTitles: nil];
    [alertV show];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)p_addTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview: self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSourceArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Indentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.textLabel.text = [dataSourceArr[indexPath.row] objectForKey:kCellName];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *classStr = [dataSourceArr[indexPath.row] objectForKey:kCellClassName];
    Class class = NSClassFromString(classStr);
    BOOL isXib = [[dataSourceArr[indexPath.row] objectForKey:kIsXib] boolValue];
    if (isXib) {
        [self.navigationController pushViewController:[[class alloc]initWithNibName:classStr bundle:nil] animated:YES];
    }else{
        [self.navigationController pushViewController:[class new] animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
