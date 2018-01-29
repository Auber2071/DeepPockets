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
@{kCellName:@"导航背景图与body分离",kCellClassName:@"VDPSeparateNaviViewController",kIsXib:@"NO"},\
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
    self.navigationItem.title = @"DeepPockets";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = NO;
    } else {
        // Fallback on earlier versions
    }
    
    [self p_addTableView];
    //[self checkScreenShot];
    [self p_PrintCodeStyle];
    
}


-(void)p_PrintCodeStyle{
    /**
     * 检查自定义字体族是否成功加入
     */
    // 取出系统安装了的所有字体族名
    NSArray *familyNames = [UIFont familyNames];
    HKSLog(@"count:%ld,系统所有字体族名：%@", familyNames.count,familyNames);
    // 打印字体族的所有子字体名(每种字体族可能对应多个子样式字体，例如每种字体族可能有粗体、斜体、粗斜体等等样式)
    for(NSString *familyName in familyNames) {
        // 字体族的所有子字体名
        NSArray *detailedNames = [UIFont fontNamesForFamilyName:familyName];
        HKSLog(@"\n字体族%@的所有子字体名：%@", familyName,detailedNames);
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    BCSelectServiceProModel *model = _currentData[indexPath.section];
    //    if (model.ID.length<1) {
    //        return 44;
    //    }
    //    CGFloat height = [self.heightCalculator heightForCalculateheightModelIDAsKey:model.ID];
    //    if (height > 0) {
    //        return height;
    //    }
    //    BCProjectNameAtuoHeightTableViewCell *cell = self.prototypeCell;
    //    cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    //    [self configureCell:cell atIndexPath:indexPath];
    //
    //
    //    CGFloat contentViewWidth = CGRectGetWidth(_proNameTableView.bounds);
    //
    //
    //
    //    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
    //
    //
    //    CGFloat fittingHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    //    [cell.contentView removeConstraint:widthFenceConstraint];
    //    CGFloat cellHeight = fittingHeight + 2*1/[UIScreen mainScreen].scale + 10; //必须加上上下分割线的高度
    //    NSLog(@"fittingHeight:%f——cellHeight:%f",fittingHeight,cellHeight);
    //    if (cellHeight <44) {
    //        cellHeight = 44;
    //    }
    //
    //    [self.heightCalculator setHeight:cellHeight withCalculateheightModelIDAsKey:model.ID];
    //    return cellHeight;
    return 44.f;
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
