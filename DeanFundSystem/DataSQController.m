//
//  DataSQController.m
//  DeanFundSystem
//
//  Created by teddy on 15/1/23.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "DataSQController.h"
#import "RTLabel.h"
#import "MyCell.h"
#import "DateActionSheet.h"
#import "SVProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "CustomUntils.h"

@interface DataSQController ()
{
    ASIHTTPRequest *_request;
    BOOL _isLoad;//是否正在加载
}

@end

@implementation DataSQController
@synthesize myTableView = _myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = self.water.stnmStr;
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
    
    _functionArr1 = @[@"站名",@"测站编号",@"昨日8点水位",@"8点水位",@"流量",@"8点库容",@"当前水位",@"水位时间",@"当前库容",@"台汛水位",@"梅汛水位"];
    _valueArray = @[self.water.stnmStr,self.water.stcdStr,self.water.yesEighthourSWStr,self.water.eighthourSWStr,self.water.llStr,self.water.eighthourKRStr,self.water.currentSWStr,self.water.currentTMStr,self.water.currentKRStr,self.water.txjjswStr,self.water.mxjjswStr];
    
    _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height-IOS7TopMargin-NavigationBar_height, Screen_Width, NavigationBar_height)];
    _selectView.backgroundColor = [UIColor colorWithRed:27/255.0 green:136/255.0 blue:245/255.0 alpha:1.0f];
    [self.view addSubview:_selectView];
    
    flag = 1;//默认是选择主要按钮
    UIButton *main_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    main_btn.frame = (CGRect){0,0,Screen_Width/2,NavigationBar_height-3};
    main_btn.backgroundColor = [UIColor clearColor];
    [main_btn setTitle:@"主要" forState:UIControlStateNormal];
    [main_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [main_btn addTarget:self action:@selector(selectedMainBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_selectView addSubview:main_btn];
    
    _flagView1 = [[UIView alloc] initWithFrame:CGRectMake((Screen_Width/2 - 10)/2, NavigationBar_height-3, 10, 3)];
    _flagView1.alpha = 1.0;
    _flagView1.backgroundColor = [UIColor whiteColor];
    [_selectView addSubview:_flagView1];
    
    UIButton *data_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    data_btn.frame = (CGRect){Screen_Width/2,0,Screen_Width/2,NavigationBar_height-2};
    data_btn.backgroundColor = [UIColor clearColor];
    [data_btn setTitle:@"日水位" forState:UIControlStateNormal];
    [data_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [data_btn addTarget:self action:@selector(selectedDataBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_selectView addSubview:data_btn];
    
    _flagView2 = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width/2+(Screen_Width/2 - 10)/2, NavigationBar_height-3, 10, 3)];
    _flagView2.alpha = 0.0;
    _flagView2.backgroundColor = [UIColor whiteColor];
    [_selectView addSubview:_flagView2];
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-IOS7TopMargin-NavigationBar_height) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    
    //日期选择
    UIButton *date_btn = [UIButton buttonWithType:UIButtonTypeSystem];
    date_btn.frame = CGRectMake(0, 0, 100, NavigationBar_height-14);
    [date_btn addTarget:self action:@selector(dataPickAction:) forControlEvents:UIControlEventTouchUpInside];
    [date_btn setTitle:@"日期选择" forState:UIControlStateNormal];
    [date_btn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    date_btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:date_btn];
    self.navigationItem.rightBarButtonItem = right;
    //默认设置成隐藏
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button_Action
//主要
- (void)selectedMainBtnAction:(UIButton *)btn
{
    if (flag != 1) {
        //点击了主要按钮
        flag = 1;
        NSLog(@"点击了主要按钮 >>>>>>>flag = 1");
        _flagView1.alpha = 1.0f;
        _flagView2.alpha = 0.0f;
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        
        //重新刷新标示图
        [self.myTableView reloadData];
    }
}

//日水位
- (void)selectedDataBtnAction:(UIButton *)btn
{
    if (flag != 2) {
        //点击了日水位按钮
        flag = 2;
        NSLog(@"点击了日水位按钮 >>>>>>>flag = 2");
        _flagView1.alpha = 0.0f;
        _flagView2.alpha = 1.0f;
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        NSString *current = [CustomUntils getNowDate];
        SelectedTime = current;//时间赋值
        [self getDataSWAction:current];
        
    }
}

//选择了日期选择按钮
- (void)dataPickAction:(id)sender
{
    if (!_isShow) {
        DateActionSheet *sheet = [[DateActionSheet alloc] initWithTitle:nil delegate:self];
        [sheet showInView:self.view];
        _isShow = YES;
    }
}

//获得日水位网络请求
- (void)getDataSWAction:(NSString *)date
{
    //http://122.226.205.102/sbskSer/data_ht.ashx?t=GetStSwInfo&results=2015-01-26$6612
    if (_isLoad) {
        [self cancelRequestAction];
    }
    
    NSString *str = [NSString stringWithFormat:@"%@t=GetStSwInfo&results=%@$%@",Web_Server,date,self.water.stcdStr];
    
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    _request = [ASIHTTPRequest requestWithURL:url];
    _request.timeOutSeconds = 30;
    
    [_request setCompletionBlock:^{
        [SVProgressHUD dismissWithSuccess:nil];
            NSString *res = _request.responseString;
            NSArray *arr = [CustomUntils dealWithWebString:res];
        
            NSMutableArray *listArr = [NSMutableArray array];
            NSDictionary *rootDic = [arr objectAtIndex:0];
            NSArray *rootArr = [rootDic objectForKey:@"HourSW"];//详细日水位数组
            WaterObject *water = [[WaterObject alloc] init];
            water.keyStr = @"站名";
            water.valueStr = [rootDic objectForKey:@"stnm1"];
            [listArr addObject:water];
        
            WaterObject *water1 = [[WaterObject alloc] init];
            water1.keyStr = @"测站编号";
            water1.valueStr = [rootDic objectForKey:@"stcd1"];
            [listArr addObject:water1];
            for (int i=0; i<rootArr.count; i++) {
                NSDictionary *dic = [rootArr objectAtIndex:i];
                WaterObject *water = [[WaterObject alloc] init];
                water.keyStr = [dic objectForKey:@"time"];
                water.valueStr = [CustomUntils compareString:[dic objectForKey:@"value"]];
                [listArr addObject:water];
            }
            _dateArr = listArr;
            [self.myTableView reloadData];
        _isLoad = NO;
    }];
    
    [_request setFailedBlock:^{
        //
        NSError *error = _request.error;
        NSLog(@"出现的错误是：%@",error);
        [SVProgressHUD dismissWithError:@"加载失败"];
        _isLoad = NO;
    }];
    
    [SVProgressHUD show];
    _isLoad = YES;
    [_request startAsynchronous];
    
}

- (void)cancelRequestAction
{
    [_request cancel];
    _isLoad = NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (flag == 1) {
        return _functionArr1.count;
    }
    else
    {
        return _dateArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *inditifier = @"myCusCell";
    MyCell *cell = (MyCell *)[tableView dequeueReusableCellWithIdentifier:inditifier];
    //需要定制cell
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCusCell" owner:self options:nil] lastObject];
    }
   
    if (flag == 1) {
        //主要
        cell.keyLabel.text = [_functionArr1 objectAtIndex:indexPath.row];
        cell.valueLabel.text = [_valueArray objectAtIndex:indexPath.row];
    }else if(flag == 2){
        //日水位
        WaterObject *water = [_dateArr objectAtIndex:indexPath.row];
        cell.keyLabel.text = water.keyStr;
        cell.valueLabel.text = water.valueStr;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (flag == 2) {
        //日水位
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
        view.backgroundColor = [UIColor lightGrayColor];
        RTLabel *timeLabel = [[RTLabel alloc] initWithFrame:CGRectMake(0, 5, Screen_Width, 30)];
        timeLabel.text = SelectedTime;
        [view addSubview:timeLabel];
        return view;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (flag == 2) {
        //日水位
        return 40;
    }else{
        return 0;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DateActionSheet *dateAction = (DateActionSheet *)actionSheet;
    if (buttonIndex == 1) {
        NSString *time = dateAction.selectedDate.date;
        NSLog(@"选择的时间是：%@",time);
        SelectedTime = time;
        [self getDataSWAction:time];
    }
    _isShow = NO;
}

@end
