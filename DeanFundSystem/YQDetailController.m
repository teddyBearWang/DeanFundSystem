//
//  YQDetailController.m
//  DeanFundSystem
//
//  Created by teddy on 15/1/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "YQDetailController.h"
#import "MyCell.h"
#import "CustomUntils.h"
#import "RTLabel.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"
#import "DateRain.h" //日雨量对象
#import "MonthRain.h"//月雨量对象
#import "YearRain.h" //年雨量
@interface YQDetailController ()
{
    //标志view
    UIView *_flagView1;
    UIView *_flagView2;
    UIView *_flagView3;
    UIView *_flagView4;
    NSArray *_functionArr;//主要 keyArr
    NSMutableArray *_valueArr;//主要 valueAr
    BOOL _isload;//是否正在加载数据
    BOOL _isShow;//actionSheet是否出现
    ASIHTTPRequest *_request;
    NSString *web_hour;//时
    NSString *selectTime;
}

@end

@implementation YQDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = self.rain.stnm;
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-IOS7TopMargin-NavigationBar_height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //创建底部视图
    [self createBarView];
    
    UIButton *selectDate_btn = [UIButton buttonWithType:UIButtonTypeSystem];
    selectDate_btn.frame = (CGRect){0,7,100,NavigationBar_height - 14};
    [selectDate_btn setTitle:@"日期选择" forState:UIControlStateNormal];
    [selectDate_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectDate_btn addTarget:self action:@selector(selectDateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:selectDate_btn];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;//先隐藏
    
    //初始化的值
    flag = 1;
    _functionArr = @[@"站名",@"测站编号",@"今日雨量",@"昨日雨量",@"15分钟雨量",@"30分钟雨量",@"1小时雨量",@"3小时雨量",@"24小时雨量",@"1小时警戒值",];
    _valueArr = (NSMutableArray *)[CustomUntils properties_aps:self.rain];
    self.dataList = (NSMutableArray *)_functionArr;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createBarView
{
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"BarView" owner:self options:nil] lastObject];
    view.frame = (CGRect){0,Screen_Height-IOS7TopMargin-NavigationBar_height,Screen_Width,NavigationBar_height};
    view.backgroundColor = [UIColor colorWithRed:27/255.0 green:136/255.0 blue:245/255.0 alpha:1.0f];
    UIButton *main_btn = (UIButton *)[view viewWithTag:200];//主要
    UIButton *day_btn = (UIButton *)[view viewWithTag:201]; //日雨量
    UIButton *month_btn = (UIButton *)[view viewWithTag:202];//月雨量
    UIButton *year_btn = (UIButton *)[view viewWithTag:203];//年雨量
    //标示视图
    _flagView1 = (UIView *)[view viewWithTag:300];
    _flagView2 = (UIView *)[view viewWithTag:301];
    _flagView3 = (UIView *)[view viewWithTag:302];
    _flagView4 = (UIView *)[view viewWithTag:303];
    [main_btn addTarget:self action:@selector(mainBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [day_btn addTarget:self action:@selector(dayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [month_btn addTarget:self action:@selector(monthBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [year_btn addTarget:self action:@selector(yearBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:view];
    
}

#pragma mark - button Action
- (void)mainBtnAction:(UIButton *)btn
{
    //主要
    if (flag != 1) {
        flag = 1;
        _flagView1.alpha = 1.0;
        _flagView2.alpha = 0.0;
        _flagView3.alpha = 0.0;
        _flagView4.alpha = 0.0;
        
        _functionArr = @[@"站名",@"测站编号",@"今日雨量",@"昨日雨量",@"15分钟雨量",@"30分钟雨量",@"1小时雨量",@"3小时雨量",@"24小时雨量",@"1小时警戒值",];
        self.dataList = (NSMutableArray *)_functionArr;
        _valueArr = (NSMutableArray *)[CustomUntils properties_aps:self.rain];
        [self.tableView reloadData];
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    }
}

- (void)dayBtnAction:(UIButton *)btn
{
    //日雨量
    if (flag != 2) {
        flag = 2;
        _flagView1.alpha = 0.0;
        _flagView2.alpha = 1.0;
        _flagView3.alpha = 0.0;
        _flagView4.alpha = 0.0;
        selectTime = [CustomUntils getNowDate];//当前显示的日期

        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        NSString *newdate = [CustomUntils getNowDate];
        [self getDateRainAction:newdate];
    }
}

- (void)monthBtnAction:(UIButton *)btn
{
    //月雨量
    if (flag != 3) {
        flag = 3;
        _flagView1.alpha = 0.0;
        _flagView2.alpha = 0.0;
        _flagView3.alpha = 1.0;
        _flagView4.alpha = 0.0;
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        NSString *newdate = [CustomUntils getNowDate];
        selectTime = [newdate substringToIndex:newdate.length -3];//当前显示的月份
        //传入的参数为当前月份，例如：2015-01-01
        NSString *date = [self getCurrentMonth:newdate];
        [self getMonthRainAction:date];
    }
}

//传入时间值，返回特定格式的月份,传入：2015-01-28，返回：2015-01-01
- (NSString *)getCurrentMonth:(NSString *)date
{
    if (![date hasSuffix:@"01"]) {
        //date不是以01结尾
        NSArray *arr = [date componentsSeparatedByString:@"-"];
        NSString *newDate = [NSString stringWithFormat:@"%@-%@-01",[arr objectAtIndex:0],[arr objectAtIndex:1]];
        return newDate;
    }
    return date;
}

- (void)yearBtnAction:(UIButton *)btn
{
    //年雨量
    if (flag != 4) {
        flag = 4;
        _flagView1.alpha = 0.0;
        _flagView2.alpha = 0.0;
        _flagView3.alpha = 0.0;
        _flagView4.alpha = 1.0;
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        NSString *nowdate = [CustomUntils getNowDate];
        selectTime = [nowdate substringToIndex:nowdate.length - 6];
        //将年份传入，即2015
        [self getYearRainAction:selectTime];
    }
}

- (void)selectDateAction:(UIButton *)btn
{
    if (!_isShow) {
        DateActionSheet *sheet = [[DateActionSheet alloc] initWithTitle:nil delegate:self];
        [sheet showInView:self.view];
        _isShow = YES;
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCusCell";
    MyCell *cell = (MyCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = (MyCell *)[[[NSBundle mainBundle] loadNibNamed:@"MyCusCell" owner:self options:nil] lastObject];
    }
    cell.keyLabel.font = [UIFont systemFontOfSize:13];
    if (flag == 1 || flag == 2) {
        //主要，日雨量
    cell.keyLabel.text = [self.dataList objectAtIndex:indexPath.row];
    cell.valueLabel.text = [_valueArr objectAtIndex:indexPath.row];
    }
    else if(flag == 3)
    {
      //月雨量
        MonthRain *mon = (MonthRain *)[self.dataList objectAtIndex:indexPath.row];
        cell.keyLabel.text = mon.dd;
        cell.valueLabel.text = mon.RN;
    }
    else if (flag == 4)
    {
        YearRain *year = (YearRain *)[self.dataList objectAtIndex:indexPath.row];
        cell.keyLabel.text = year.mm;
        cell.valueLabel.text = year.RN;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (flag != 1) {
        return 40;
    }
    else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (flag == 1) {
        return  nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    NSString *titleStr = nil;
    switch (flag) {
        case 2:
            titleStr = [NSString stringWithFormat:@"日期：%@ %@",selectTime,web_hour];
            break;
        case 3:
            titleStr = [NSString stringWithFormat:@"%@月逐日雨量",selectTime];
            break;
        case 4:
            titleStr = [NSString stringWithFormat:@"%@年逐月雨量",selectTime];
            break;
        default:
            break;
    }
    RTLabel *headerLabel = [[RTLabel alloc] initWithFrame:(CGRect){0,5,Screen_Width,40-5*2}];
    headerLabel.text = titleStr;
    [view addSubview:headerLabel];
    return view;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //确定
        DateActionSheet *sheet = (DateActionSheet *)actionSheet;
        NSString *time = sheet.selectedDate.date;
        NSLog(@"选择的时间是：%@",time);
        switch (flag) {
            case 2:
                //日雨量
                selectTime = time;
                [self getDateRainAction:selectTime];
                break;
            case 3:
                [self getMonthRainAction:[self getCurrentMonth:time]];
                selectTime = [time substringToIndex:time.length - 3];
                break;
            case 4:
                selectTime = [time substringToIndex:time.length - 6];
                [self getYearRainAction:selectTime];
                break;
            default:
                break;
        }
    }
    _isShow = NO;
}

#pragma mark - getWebDataAction
//将当前的日期按照选择的时间减小1
- (NSString *)appendStringWithDate:(NSString *)date with:(int)index
{
    NSArray *arr = [date componentsSeparatedByString:@"-"];
    int obc = [[arr objectAtIndex:index] intValue];
    obc--;
    NSString *newDate = nil;
    if (index == 0) {
        //修改年
       newDate = [NSString stringWithFormat:@"%d-%.2d-%.2d",obc,[[arr objectAtIndex:index+1] intValue],[[arr objectAtIndex:index+2] intValue]];
    }
    else if (index == 2)
    {
        //修改日
        newDate = [NSString stringWithFormat:@"%d-%.2d-%.2d",[[arr objectAtIndex:index-2] intValue],[[arr objectAtIndex:index-1] intValue],obc];
    }
    else
    {
        //修改月
        if (obc == 0) {
            //原来的obc为1，这时候obc应为12，而年份减少1
            newDate = [NSString stringWithFormat:@"%d-%.2d",[[arr objectAtIndex:index-1] intValue]-1,obc+12];
        }else{
            newDate = [NSString stringWithFormat:@"%d-%.2d",[[arr objectAtIndex:index-1] intValue],obc];
        }
    }
    return newDate;
}
//日雨量
- (void)getDateRainAction:(NSString *)date
{
    
    NSString *newdate = [self appendStringWithDate:date with:2];
    NSString *yesStr = [NSString stringWithFormat:@"%@日累计雨量",newdate];
    NSString *todStr = [NSString stringWithFormat:@"%@日累计雨量",date];
    if (_isload) {
        [self cancelRequestAction];
    }
    //日雨量 http://122.226.205.102/sbskSer/data_ht.ashx?t=GetStDayRain&results=2015-01-22$3299
    NSString *urlstr = [NSString stringWithFormat:@"%@t=GetStDayRain&results=%@$%@",Web_Server,date,self.rain.stcd];
    NSURL *url = [NSURL URLWithString:[urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    _request = [ASIHTTPRequest requestWithURL:url];
    _request.timeOutSeconds = 30;
    
    [_request setCompletionBlock:^{
        //成功
        [SVProgressHUD dismissWithSuccess:nil];
        NSString *str = _request.responseString;
        NSArray *arr = [CustomUntils dealWithWebString:str];
        
        //存在问题~~目前只是取网络数据的第一组数据
        NSDictionary *dic = (NSDictionary *)[arr objectAtIndex:0];
        DateRain *daterain = [[DateRain alloc] init];
        daterain.name = [CustomUntils compareString:[dic objectForKey:@"stnm"]];
        daterain.stcd = [CustomUntils compareString:[dic objectForKey:@"stcd"]];
        daterain.yesterdaySum = [CustomUntils compareString:[dic objectForKey:@"yesterday"]];
        daterain.sum = [CustomUntils compareString:[dic objectForKey:@"sum"]];
        daterain.hour = [CustomUntils compareString:[dic objectForKey:@"hour"]];
        web_hour = [NSString stringWithString:daterain.hour]; //赋值
        _functionArr = @[@"站名",@"测站编号",yesStr,@"时",todStr];
        _valueArr = [NSMutableArray arrayWithObjects:daterain.name,daterain.stcd,daterain.yesterdaySum,daterain.hour,daterain.sum, nil];
        self.dataList = (NSMutableArray *)_functionArr;
        [self.tableView reloadData];
        _isload = NO;
    }];
    
    [_request setFailedBlock:^{
        //失败
        [SVProgressHUD dismissWithError:nil];
        NSError *error = _request.error;
        NSLog(@"错误信息是:%@",error);
        _isload = NO;
    }];
    
    [SVProgressHUD show];
    _isload = YES;
    [_request startAsynchronous];
}

//获取月雨量数据
- (void)getMonthRainAction:(NSString *)date
{
    //http://122.226.205.102/sbskSer/data_ht.ashx?t=GetStMonthRain&results=2015-01-01$3299
    if (_isload) {
        [self cancelRequestAction];
    }
    NSString *str = [NSString stringWithFormat:@"%@t=GetStMonthRain&results=%@$%@",Web_Server,date,self.rain.stcd];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    _request = [ASIHTTPRequest requestWithURL:url];
    _request.timeOutSeconds = 30;
    
    [_request setCompletionBlock:^{
        //成功
        [SVProgressHUD dismissWithSuccess:nil];
        NSString *res = _request.responseString;
        NSArray *arr = [CustomUntils dealWithWebString:res];
        
        //取得测站的基本信息
        NSDictionary *dic = [arr objectAtIndex:0];
        NSMutableArray *listArr = [NSMutableArray arrayWithCapacity:arr.count + 4];
        MonthRain *month1 = [MonthRain alloc];
        month1.dd = @"站名";
        month1.RN = [dic objectForKey:@"stnm"];
        [listArr addObject:month1];
        
        MonthRain *month2 = [MonthRain alloc];
        month2.dd = @"测站编号";
        month2.RN = [dic objectForKey:@"stcd"];
        [listArr addObject:month2];
        
        MonthRain *month3 = [MonthRain alloc];
        //修改月份
        NSString *lastMonth = [self appendStringWithDate:date with:1];
        month3.dd = [NSString stringWithFormat:@"%@月累计雨量",lastMonth];
        month3.RN = [dic objectForKey:@"lastMonth"];
        [listArr addObject:month3];
        
        for (int i=0; i<arr.count; i++) {
            NSDictionary *dic = [arr objectAtIndex:i];
            MonthRain *month = [[MonthRain alloc] init];
           // month.stnm = [CustomUntils compareString:[dic objectForKey:@"stnm"]];
            //month.stcd = [CustomUntils compareString:[dic objectForKey:@"stcd"]];
           // month.lastMonth = [CustomUntils compareString:[dic objectForKey:@"lastMonth"]];
            month.dd = [NSString stringWithFormat:@"%@日",[CustomUntils compareString:[dic objectForKey:@"dd"]]];
            month.RN = [CustomUntils compareString:[dic objectForKey:@"RN"]];
           // month.sum = [CustomUntils compareString:[dic objectForKey:@"sum"]];
            [listArr addObject:month];
        }
        
        MonthRain *month4 = [MonthRain alloc];
        month4.dd = [NSString stringWithFormat:@"%@月累计雨量",selectTime];
        month4.RN = [dic objectForKey:@"sum"];
        [listArr addObject:month4];
        
        self.dataList = listArr;
        [self.tableView reloadData];
        _isload = NO;
    }];
    
    [_request setFailedBlock:^{
        //失败
        [SVProgressHUD dismissWithError:@"加载失败"];
        NSError *error = _request.error;
        NSLog(@"错误的代码是：%@",error);
        _isload = NO;
    }];
    
    [SVProgressHUD show];
    _isload = YES;
    [_request startAsynchronous];
}

//获取年雨量数据
- (void)getYearRainAction:(NSString *)year
{
    if (_isload) {
        [self cancelRequestAction];
    }
    
    //http://122.226.205.102/sbskSer/data_ht.ashx?t=GetStYearRain&results=2015$3299
    NSString *str = [NSString stringWithFormat:@"%@t=GetStYearRain&results=%@$%@",Web_Server,year,self.rain.stcd];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    _request = [ASIHTTPRequest requestWithURL:url];
    _request.timeOutSeconds = 30;
    
    [_request setCompletionBlock:^{
        //完成
        [SVProgressHUD dismissWithSuccess:nil];
        NSString *res = _request.responseString;
        NSArray *arr = [CustomUntils dealWithWebString:res];
        
        NSMutableArray *list = [NSMutableArray arrayWithCapacity:arr.count+4];
        NSDictionary *dic = [arr objectAtIndex:0];
        YearRain *yearRain1 = [[YearRain alloc] init];
        yearRain1.mm = @"站名";
        yearRain1.RN = [dic objectForKey:@"stnm"];
        [list addObject:yearRain1];
        
        YearRain *yearRain2 = [[YearRain alloc] init];
        yearRain2.mm = @"测站编号";
        yearRain2.RN = [dic objectForKey:@"STCD"];
        [list addObject:yearRain2];
        
        YearRain *yearRain3 = [[YearRain alloc] init];
        yearRain3.mm = [NSString stringWithFormat:@"%d年累计雨量",[year intValue]-1];
        yearRain3.RN = [dic objectForKey:@"lastYear"];
        [list addObject:yearRain3];
        for (int i=0; i<arr.count; i++) {
            YearRain *year = [[YearRain alloc] init];
            NSDictionary *dic = [arr objectAtIndex:i];
            year.mm = [NSString stringWithFormat:@"%@月",[dic objectForKey:@"mm"]];
            year.RN = [dic objectForKey:@"RN"];
            [list addObject:year];
        }
        
        YearRain *yearRain4 = [[YearRain alloc] init];
        yearRain4.mm = [NSString stringWithFormat:@"%@年累计雨量",year];
        yearRain4.RN = [dic objectForKey:@"sum"];
        [list addObject:yearRain4];
        
        self.dataList = list;
        [self.tableView reloadData];
        _isload = NO;
    }];
    
    [_request setFailedBlock:^{
        //失败
        [SVProgressHUD dismissWithError:@"加载失败"];
        NSError *error = _request.error;
        NSLog(@"错误的代码是：%@",error);
        _isload = NO;

    }];
    
    [SVProgressHUD show];
    _isload = YES;
    [_request startAsynchronous];
}

- (void)cancelRequestAction
{
    [_request cancel];
    _isload = NO;
}

@end
