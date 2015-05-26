//
//  ChartViewController.m
//  DeanFundSystem
//
//  Created by teddy on 15/1/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ChartViewController.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"
#import "CustomUntils.h"
#import "DamObject.h"
#import "SelectedTimeController.h"

@interface ChartViewController ()
{
    ASIHTTPRequest *_request;
    BOOL _isload;
    
    NSString *_st;//开始时间
    NSString *_et;//结束时间
    UIScrollView *_scrollView;
    NSString *_type;//查询类型
    
}

@end

@implementation ChartViewController

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
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, Screen_Width, Screen_Height-IOS7TopMargin-200)];
    _scrollView.contentSize = CGSizeMake(Screen_Width*2, Screen_Height-IOS7TopMargin-200);
    [self.view addSubview:_scrollView];
    
    _type = [self.typeArr componentsJoinedByString:@","];
    NSString *nowTime = [CustomUntils getNowDate];
    NSString *etTime = [NSString stringWithFormat:@"%@ 09:00",nowTime];
    NSString *stTime = [self getTheSevenDayAgo];
    _st = stTime;
    _et = etTime;
    
    [self getWebDataWithType:_type withStartTime:stTime withEndTime:etTime];
}

//计算7天之前的值
- (NSString *)getTheSevenDayAgo
{
    NSDate *agoDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*7*24];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 09:00"];
    NSString *ago = [formatter stringFromDate:agoDate];
    return ago;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *time_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    time_btn.frame = (CGRect){0,0,60,30};
    time_btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [time_btn setTitle:@"日期选择" forState:UIControlStateNormal];
    [time_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [time_btn addTarget:self action:@selector(selectTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:time_btn];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - draw Chart
- (void)drawnChartView
{
   // self.chartView = [[SHLineGraphView alloc] initWithFrame:CGRectMake(0, 100, Screen_Width, Screen_Height-IOS7TopMargin-200)];
    self.chartView = [[SHLineGraphView alloc] initWithFrame:CGRectMake(0, 20, Screen_Width, Screen_Height-IOS7TopMargin-100)];
    /*各个参数的含义
     *kXAxisLabelColorKey ：X轴标签的字体颜色
     *kXAxisLabelFontKey : X轴标签的子体样式
     *kYAxisLabelColorKey: Y轴标签的字体颜色
     *kYAxisLabelFontKey :y轴标签的字体样式
     *kYAxisLabelSideMarginsKey :Y轴距离屏幕左边的距离
     *kPlotBackgroundLineColorKye ：背景线条的颜色
     */
    NSDictionary *_themeAttributes = @{
                                       kXAxisLabelColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                                       kXAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:8],
                                       kYAxisLabelColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                                       kYAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                                       kYAxisLabelSideMarginsKey : @1,
                                       kPlotBackgroundLineColorKye : [UIColor colorWithRed:209/255.0 green:236/255.0 blue:155/255.0 alpha:0.4]
                                       };
    self.chartView.themeAttributes = _themeAttributes;
    //最大值
    self.chartView.yAxisRange = [NSNumber numberWithFloat:[self getTheMax]];
    //单位
    self.chartView.yAxisSuffix = @"(mm)";
    
    //获得两个日期之间的详细日期
    NSMutableArray *Xdaysarr = [self getDetailDaysStringBetween:_st withDay2:_et];
    //X坐标数组
    NSMutableArray *XValues = [NSMutableArray arrayWithCapacity:Xdaysarr.count];
    for (int i=1; i<Xdaysarr.count+1; i++) {
        NSString *str = [Xdaysarr objectAtIndex:(i-1)];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:str forKey:@(i)];
        [XValues addObject:dic];
    }
    //设置X坐标
    self.chartView.xAxisValues = XValues;
    
    //画线
    [self drawnplots:Xdaysarr];
    
    [self.chartView setupTheView];
    [self.view addSubview:self.chartView];
    
}

/*
 * 将折线添加到视图
 * 参数： days 包含了两个时间段之间的详细日期
 */
- (void)drawnplots:(NSMutableArray *)days
{
    /*
     *参数含义：
     *kPlotFillColorKey : 线条下部分填充背景的颜色
     *kPlotStrokeWidthKey :线条的粗细
     *kPlotStrokeColorKey :线条的颜色
     * kPlotPointFillColorKey :线条上得圆点填充物的颜色
     * kPlotPointValueFontKey ：线条上面标注字体的大小
     */
    NSDictionary *_plotThemeAttributes = @{
                                           kPlotFillColorKey : [UIColor clearColor],
                                           kPlotStrokeWidthKey : @2,
                                           kPlotStrokeColorKey : [UIColor redColor],
                                           kPlotPointFillColorKey : [UIColor lightGrayColor],
                                           kPlotPointValueFontKey : [UIFont fontWithName:@"TrebuchetMS" size:18]
                                           };
    
    for (NSString *type in self.typeArr) {
        NSMutableArray *dataArr = [self getTypesArray:type];//一条线的数组
        NSMutableArray *plots = [self getYValuesWith:dataArr withDays:days];
        SHPlot *plot = [[SHPlot alloc] init];
        plot.plotThemeAttributes = _plotThemeAttributes;
        plot.plottingValues = plots;
        //将线添加到图表上面
        [self.chartView addPlot:plot];
    }
}

/*得到线的数据点数组
 *参数：dataArr   包含了数据点，由这些点组成的线
 *     dates:   两个时间段之间的详细日期组成的数组
 */
- (NSMutableArray *)getYValuesWith:(NSMutableArray *)dataArr withDays:(NSMutableArray *)dates
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:dates.count];
    for (int i=0; i<dates.count; i++) {
        NSString *date = [dates objectAtIndex:i];
        NSDictionary *dic = nil;
        for (int j=0; j<dataArr.count; j++) {
            DamObject *dam = (DamObject *)[dataArr objectAtIndex:j];
            if ([dam.chartTime isEqualToString:date]) {
                float result = [dam.chartResult floatValue];
                dic = [NSDictionary dictionaryWithObject:@(result) forKey:@(i+1)];
                break;//跳出当前循环
            }else{
                //若是没有数据，则等于数组最后一个元素的数据
                dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@(i+1)];
            }
        }
        [arr addObject:dic];
    }
    return arr;
}

//计算两个时间之间相隔的天数
- (int)getDaysBetweenDay1:(NSString *)day1 withDay2:(NSString *)day2
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date1 = [formatter dateFromString:day1];
    NSDate *date2 = [formatter dateFromString:day2];
    NSTimeInterval interval = [date2 timeIntervalSinceDate:date1]; //秒数
    NSInteger beginDays=((NSInteger)interval)/(3600*24);
    return (int)beginDays;
}

//得到两个时间段时间详细的日期
- (NSMutableArray *)getDetailDaysStringBetween:(NSString *)day1 withDay2:(NSString *)day2
{
    int days = [self getDaysBetweenDay1:day1 withDay2:day2];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:days];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date1 = [formatter dateFromString:day1];
    for (int i=0; i<days; i++) {
        NSDate *date = [date1 dateByAddingTimeInterval:3600*23*i];
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"yyyy-MM-dd"];
        NSString *day = [formatter1 stringFromDate:date];
        [arr addObject:day];
    }
    return arr;
}

//得到相同类型的数据
-(NSMutableArray *)getTypesArray:(NSString *)type
{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<_dataList.count; i++) {
        DamObject *dam = [_dataList objectAtIndex:i];
        if ([dam.chartType isEqualToString:type]) {
            [arr addObject:dam];
        }
    }
    //每一条线的数据
    return arr;
}

//得到最大的数据
- (float)getTheMax
{
    float max = 0.0;
    for (int i=0; i<_dataList.count; i++) {
        DamObject *dam = (DamObject *)[_dataList objectAtIndex:i];
        float results = [dam.chartResult floatValue];
        if (results > max) {
            max = results;
        }
    }
    return max;
}

#pragma mark - Button_action
//选择时间
- (void)selectTimeAction:(UIButton *)btn
{
    SelectedTimeController *select = [[SelectedTimeController alloc] init];
    [select setBlock:^(NSMutableArray *arr) {
        //回掉传值
        _st = [arr objectAtIndex:0];
        _et = [arr objectAtIndex:1];
        [self getWebDataWithType:_type withStartTime:_st withEndTime:_et];
        
    }];
    [self presentViewController:select animated:YES completion:nil];
}

#pragma mark - WebServer
- (void)getWebDataWithType:(NSString *)type withStartTime:(NSString *)st withEndTime:(NSString *)et
{
    if (_isload) {
        [self cancelRequest];
    }
    
    //http://122.226.205.102/SfBzSer/Data.ashx?t=GetCdTypeChildSearch&results=R1$2014-12-01 09:00$2014-12-07 09:00
    NSString *str = [NSString stringWithFormat:@"%@t=GetCdTypeChildSearch&results=%@$%@$%@",Dam_webServer,type,st,et];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    _request = [ASIHTTPRequest requestWithURL:url];
    _request.timeOutSeconds = 30;
    
    [_request setCompletionBlock:^{
        [SVProgressHUD dismissWithSuccess:nil];
        //complete
        NSString *str = _request.responseString;
        NSArray *arr = [CustomUntils dealWithWebString:str];
        
        NSMutableArray *list = [NSMutableArray arrayWithCapacity:arr.count];
        for (int i=0; i<arr.count; i++) {
            NSDictionary *dic = (NSDictionary *)[arr objectAtIndex:i];
            DamObject *dam = [[DamObject alloc] init];
            
            dam.chartType = [dic objectForKey:@"type"];
            NSString *time = [dic objectForKey:@"时间"];
            dam.chartTime = [time substringToIndex:10];
            dam.chartTemperture = [dic objectForKey:@"温度值"];
            dam.chartResult = [dic objectForKey:@"结果"];
            dam.chartResult_1 = [dic objectForKey:@"结果1"];
            dam.link_id = [dic objectForKey:@"link_id"];
            dam.chartPressure = [dic objectForKey:@"扬压力系数"];
            [list addObject:dam];
        }
        _dataList = list;
        if (self.view.subviews.count != 0) {
            [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        [self drawnChartView];
        
    }];
    
    [_request setFailedBlock:^{
        //fail
        [SVProgressHUD dismissWithError:@"加载失败"];
        NSError *error = _request.error;
        NSLog(@"错误代码：%@",error);
    }];
    
    [SVProgressHUD show];
    _isload = YES;
    [_request startAsynchronous];
                  
}

- (void)cancelRequest
{
    [_request cancel];
    _isload = NO;
}

@end
