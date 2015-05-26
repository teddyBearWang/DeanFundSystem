//
//  YQViewController.m
//  DeanFundSystem
//
//  Created by teddy on 15/1/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "YQViewController.h"
#import "YQCell.h"
#import "RainObject.h"
#import "YQDetailController.h"

@interface YQViewController ()

@end

@implementation YQViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"雨情信息";
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
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
#endif
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - IOS7TopMargin) style:UITableViewStylePlain];
    self.myTableView.rowHeight = Cell_height;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
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
    static NSString *identifier = @"YQCell";
    YQCell *cell = (YQCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = (YQCell *)[[[NSBundle mainBundle] loadNibNamed:@"YQMyCell" owner:self options:nil] objectAtIndex:0];
    }
    RainObject *rain = (RainObject *)[self.dataList objectAtIndex:indexPath.row];
    cell.nameLabel.text = rain.stnm;
    cell.hourLabel.text = rain.OnehourYL;
    cell.todayLabel.text = rain.today;
    cell.yestodayLabel.text = rain.yesterday;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = (UIView *)[[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil] lastObject];
    view.backgroundColor = [UIColor lightGrayColor  ];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RainObject *rain = (RainObject *)[self.dataList objectAtIndex:indexPath.row];
    YQDetailController *detail = [[YQDetailController alloc] init];
    detail.rain = rain;
    [self.navigationController pushViewController:detail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
