//
//  TodayViewController.m
//  VDPTodayExtension
//
//  Created by hankai on 2017/6/16.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *contentsMutArr;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *toggleLineChartButton;
@property (nonatomic, strong) UILabel *priceChangeLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, assign) BOOL lineChartIsVisible;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefrashData:) name:@"TodayExtensionNeedRefrash" object:nil];
    self.preferredContentSize = CGSizeMake(0, 120);
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    [self loadContents];
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    completionHandler(NCUpdateResultNewData);
}

-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    return UIEdgeInsetsZero;
}
-(void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
        self.preferredContentSize = CGSizeMake(0, self.contentsMutArr.count * 44 -1);
    }else{
        self.preferredContentSize = maxSize;
    }
}



-(void)loadContents{

    self.contentsMutArr = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSUserDefaults *groupDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.GoodMorning"];
        self.contentsMutArr = [groupDefaults objectForKey:@"GoodMorningSnapshot"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.contentsMutArr.count == 0) {
                
            }else{
                self.preferredContentSize = CGSizeMake(0, self.contentsMutArr.count * 44 -1);
            }
            [self.tableView reloadData];

        });
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentsMutArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *AppExtensionCell = @"AppExtensionTodayCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AppExtensionCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AppExtensionCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.contentsMutArr[indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.extensionContext openURL:[NSURL URLWithString:[NSString stringWithFormat:@"GoodMorning://row:%ld",(long)indexPath.row]] completionHandler:^(BOOL success) {
        
    }];
}

-(void)RefrashData:(NSNotification *)notification{
    [self loadContents];
}

@end
