//
//  VDPAppExtensionViewController.m
//  VencentDeepPockets
//
//  Created by hankai on 2017/6/19.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "VDPAppExtensionViewController.h"

@interface VDPAppExtensionViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation VDPAppExtensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSMutableArray arrayWithArray: @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"]];
    [self makeTodaySnapshot];
}


//数据变化后，通过此代码来更新Extension数据
-(void)makeTodaySnapshot{
    NSUInteger numberOfItemsInSnapshot = MIN(self.dataSource.count, self.dataSource.count/2);
    NSArray<NSString *> *snapshot = [self.dataSource subarrayWithRange:NSMakeRange(self.dataSource.count - numberOfItemsInSnapshot, numberOfItemsInSnapshot)];

    NSUserDefaults *groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.GoodMorning"];
    [groupDefaults setObject:snapshot forKey:@"GoodMorningSnapshot"];
    [groupDefaults synchronize];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 从数据源中删除
    [self.dataSource removeObjectAtIndex:indexPath.row];
    // 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    //更新userDefault 中存储的数据
    [self makeTodaySnapshot];
    //发送更新通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TodayExtensionNeedRefrash" object:nil];
}


@end
