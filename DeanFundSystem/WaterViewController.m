//
//  WaterViewController.m
//  DeanFundSystem
//
//  Created by teddy on 15/1/22.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WaterViewController.h"
#import "MyTableCell.h"
#import "RTLabel.h"
#import "WaterObject.h"
#import "DataSQController.h"

@interface WaterViewController ()

@end

@implementation WaterViewController
@synthesize dataList = _dataList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"水情信息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
#endif
    
    self.myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-IOS7TopMargin) style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.rowHeight = Cell_height;
    [self.view addSubview:self.myTable];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indetifier = @"myCell";
    MyTableCell *cell = (MyTableCell *)[tableView dequeueReusableCellWithIdentifier:indetifier];
    if (cell == nil) {
        //cell = [[MyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
        //用xib文件加载自定义cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CusCell" owner:self options:nil] lastObject];
    }
    WaterObject *water = [self.dataList objectAtIndex:indexPath.row];
    cell.platLabel.text = water.stnmStr;
    cell.lastestLabel.text = water.currentSWStr;
    cell.eightLabel.text = water.eighthourSWStr;
    cell.trafficeLabel.text = water.llStr;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WaterObject *water = [self.dataList objectAtIndex:indexPath.row];
    DataSQController *sq = [[DataSQController alloc] init];
    sq.water = water;
  //  sq.stcd = water.stcdStr;//水库编号
    [self.navigationController pushViewController:sq animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [self createTempView];
    return headView;
}

- (UIView *)createTempView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 50)];
    headView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0f];
    RTLabel *plat = [[RTLabel alloc] initWithFrame:CGRectMake(7, 10, 90, 30)];
    plat.text = @"测站";
    [headView addSubview:plat];
    
    RTLabel *lastest = [[RTLabel alloc] initWithFrame:CGRectMake(104, 10, 70, 30)];
    lastest.text = @"最新";
    [headView addSubview:lastest];
    
    RTLabel *eight = [[RTLabel alloc] initWithFrame:CGRectMake(176, 10, 70, 30)];
    eight.text = @"今日8时";
    [headView addSubview:eight];
    
    RTLabel *traffic = [[RTLabel alloc] initWithFrame:CGRectMake(249, 10, 70, 30)];
    traffic.text = @"流量";
    [headView addSubview:traffic];
    return headView;
}

@end
