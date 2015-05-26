//
//  ModuleViewController.m
//  DeanFundSystem
//
//  Created by teddy on 15/1/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ModuleViewController.h"
#import "ChartViewController.h"
#import "DamObject.h"


@interface ModuleViewController ()
{
    UIButton *_backBtn;
    UIButton *_comfirm_btn;
    NSArray *_list;
    
    BOOL _isMuitile;//是否在多选状态下
}

@end

@implementation ModuleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //初始化数组
    self.selectArr = [NSMutableArray array];
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
    
#endif
    
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-IOS7TopMargin)style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    
    _backBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = (CGRect){0,0,60,44};
    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [_backBtn setTitleColor:NavigationItem_TitleColor forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backOrCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _comfirm_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _comfirm_btn.frame = (CGRect){0,0,60,44};
    [_comfirm_btn setTitle:@"多选" forState:UIControlStateNormal];
    [_comfirm_btn setTitleColor:NavigationItem_TitleColor forState:UIControlStateNormal];
    [_comfirm_btn addTarget:self action:@selector(mutibleSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:_comfirm_btn];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.myTableView reloadData];
    if (self.selectArr.count != 0) {
        [self.selectArr removeAllObjects];
    }
}
#pragma mark - Button_action
- (void)backOrCancelAction:(UIButton *)btn
{
    if ([btn.currentTitle isEqualToString:@"返回"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //取消多选
        self.myTableView.allowsMultipleSelection = NO;//不允许多选
        [_comfirm_btn setTitle:@"多选" forState:UIControlStateNormal];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        //清空选择的数组
        [self.selectArr removeAllObjects];
        _isMuitile = NO;
    }
}

- (void)mutibleSelectedAction:(UIButton *)btn
{
    if ([btn.currentTitle isEqualToString:@"多选"]) {
        _isMuitile = YES;
        //设置可以多选
        self.myTableView.allowsMultipleSelection = YES;
        [_backBtn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        //多选完成
        ChartViewController *chart = [[ChartViewController alloc] init];
        chart.typeArr = self.selectArr;
        [self.navigationController pushViewController:chart animated:YES];
        
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setTitle:@"多选" forState:UIControlStateNormal];
        _isMuitile = NO;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    DamObject *dam = (DamObject *)[self.dataList objectAtIndex:indexPath.row];
    cell.textLabel.text = dam.type;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    DamObject *dam = (DamObject *)[self.dataList objectAtIndex:indexPath.row];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectArr addObject:dam.type];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectArr removeObject:dam.type];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //不在多选的情况下，点击之后可以直接推送到下一个控制器
    if (!_isMuitile) {
        ChartViewController *chart = [[ChartViewController alloc] init];
        chart.typeArr = self.selectArr;
        [self.navigationController pushViewController:chart animated:YES];
    }
}

@end
