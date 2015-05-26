//
//  MainViewController.m
//  DeanFundSystem
//
//  Created by teddy on 15/1/22.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "MainViewController.h"
#import "WaterViewController.h"
#import "SVProgressHUD.h"
#import "WaterObject.h"
#import "RainObject.h"
#import "CustomUntils.h"
#import "YQViewController.h"
#import "DamCheckController.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"主菜单";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _functionArr = @[@"水情",@"雨情",@"大坝监测"];
    //适配ios 7
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
#endif
    
    [self createLayoutAction];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//主页面布局
- (void)createLayoutAction
{
    for (int i=0; i<_functionArr.count; i++) {
        int row = i / 3;//表示行数
        int cloum = i % 3; //表示列数
       
        UIView *btn_view = [[UIView alloc] initWithFrame:CGRectMake((20 * (cloum + 1)+(Button_View_Width *cloum)), (25*(row + 1)+ Button_View_Height * row), Button_View_Width, Button_View_Height)];
        btn_view.layer.cornerRadius = 6.0f;
        btn_view.layer.borderWidth = 0.5f;
        btn_view.layer.borderColor = [UIColor colorWithRed:234/244.0 green:234/255.0 blue:234/255.0 alpha:1.0].CGColor;
        btn_view.layer.masksToBounds = YES;
        [self.view addSubview:btn_view];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor lightGrayColor];
        btn.frame = CGRectMake((Button_View_Width - Button_width)/2, 0, Button_width, Button_height);
        btn.tag = i;
        btn.layer.cornerRadius = 6.0f;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn_view addSubview:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2, btn.frame.origin.y+Button_height, Button_View_Width - 5, Button_View_Height - Button_height)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.text = [_functionArr objectAtIndex:i];
        [btn_view addSubview:label];
    }
}

- (void)clickButtonAction:(UIButton *)btn
{

    if (btn.tag == 0) {
        //加载水情
        [self loadSQWebData];
    }
    else if (btn.tag == 1)
    {
        //加载雨情
        [self loadYQWebData];
    }
    else if (btn.tag == 2)
    {
        //大坝检测
        [self loadDamDataAction];
    }

}

- (void)loadSQWebData
{
    if (_isLoad) {
        //先取消异步请求
        [self cancelRequestAction];
    }
    //水情
    NSString *str = [NSString stringWithFormat:@"%@t=GetSqInfo",Web_Server];
     NSURL *url = [NSURL URLWithString:str];
    _request = [ASIHTTPRequest requestWithURL:url];
    [_request setCompletionBlock:^{
        [SVProgressHUD dismiss];
        //调用成功
        if (_request.responseStatusCode == 200) {
            NSString *str = _request.responseString;
            NSArray *arr = [CustomUntils dealWithWebString:str];
            
            NSMutableArray *listArr = [NSMutableArray arrayWithCapacity:arr.count];
            for (int i=0; i<arr.count; i++) {
                NSDictionary *dic = (NSDictionary *)[arr objectAtIndex:i];
                WaterObject *water = [[WaterObject alloc] init];
                water.areaStr = [CustomUntils compareString:[dic objectForKey:@"area"]];
                water.stnmStr = [CustomUntils compareString:[dic objectForKey:@"stnm"] ];
                water.stcdStr = [CustomUntils compareString:[dic objectForKey:@"stcd"]];
                water.yesEighthourSWStr = [CustomUntils compareString:[dic objectForKey:@"yesEighthourSW"]];
                water.eighthourSWStr = [CustomUntils compareString:[dic objectForKey:@"eighthourSW"]];
                water.maxSWStr = [CustomUntils compareString:[dic objectForKey:@"maxSW_24"]];
                water.eighthourKRStr = [CustomUntils compareString:[dic objectForKey:@"eighthourKR"]];
                water.currentSWStr = [CustomUntils compareString:[dic objectForKey:@"newSW"]];
                water.currentTMStr = [CustomUntils compareString:[dic objectForKey:@"newTM"]];
                water.currentKRStr = [CustomUntils compareString:[dic objectForKey:@"newKR"]];
                water.txjjswStr = [CustomUntils compareString:[dic objectForKey:@"txjjsw"]];
                water.mxjjswStr = [CustomUntils compareString:[dic objectForKey:@"mxjjsw"]];
                water.llStr = [CustomUntils compareString:[dic objectForKey:@"LL"]];
                [listArr addObject:water];
            }
            WaterViewController *water = [[WaterViewController alloc] init];
            water.dataList = listArr;
            [self.navigationController pushViewController:water animated:YES];
            _isLoad = NO;
        }
    }];
    
    [_request setFailedBlock:^{
        //返回失败
        NSError *error = _request.error;
        NSLog(@"发生的错误是：%@",error);
        [SVProgressHUD dismissWithError:@"加载失败"];
        _isLoad = NO;
    }];
    [SVProgressHUD show];
    _isLoad = YES;
    //开始异步请求
    [_request startAsynchronous];
}

//加载雨情数据
- (void)loadYQWebData
{
    
    if (_isLoad) {
        //先取消异步请求
        [self cancelRequestAction];
    }
    NSString *str = [NSString stringWithFormat:@"%@t=GetYqInfo",Web_Server];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    _request = [ASIHTTPRequest requestWithURL:url];
    _request.timeOutSeconds = 30;
    [_request setCompletionBlock:^{
        //
        [SVProgressHUD dismissWithSuccess:nil];
        NSString *str = _request.responseString;
        NSArray *arr = [CustomUntils dealWithWebString:str];
        
        NSMutableArray *list = [NSMutableArray arrayWithCapacity:arr.count];
        for (int i=0; i<arr.count; i++) {
            NSDictionary *dic = [arr objectAtIndex:i];
            RainObject *rain = [[RainObject alloc] init];
            rain.area = [CustomUntils compareString:[dic objectForKey:@"area"]];
            rain.stnm = [CustomUntils compareString:[dic objectForKey:@"stnm"]];
            rain.stcd = [CustomUntils compareString:[dic objectForKey:@"stcd"]];
            rain.today = [CustomUntils compareString:[dic objectForKey:@"today"]];
            rain.yesterday = [CustomUntils compareString:[dic objectForKey:@"yesterday"]];
            rain.FifteenminYL = [CustomUntils compareString:[dic objectForKey:@"FifteenminYL"]];
            rain.thirtyminYL = [CustomUntils compareString:[dic objectForKey:@"thirtyminYL"]];
            rain.OnehourYL = [CustomUntils compareString:[dic objectForKey:@"OnehourYL"]];
            rain.threehourYL = [CustomUntils compareString:[dic objectForKey:@"threehourYL"]];
            rain.tweentyfourhourYL = [CustomUntils compareString:[dic objectForKey:@"tweentyfourhourYL"]];
            rain.OnehourWarnYL = [CustomUntils compareString:[dic objectForKey:@"OnehourWarnYL"]];
            rain.LL = [CustomUntils compareString:[dic objectForKey:@"LL"]];
            [list addObject:rain];
        }
        YQViewController *yqCtrl = [[YQViewController alloc] init];
        yqCtrl.dataList = list;
        [self.navigationController pushViewController:yqCtrl animated:YES];
        _isLoad = NO;
        
    }];
    
    [_request setFailedBlock:^{
        //
        [SVProgressHUD dismissWithError:@"加载失败"];
    }];
    [SVProgressHUD show];
    _isLoad = YES;
    //开始异步请求
    [_request startAsynchronous];
}

//加载大坝检测
- (void)loadDamDataAction
{
    if (_isLoad) {
        [self cancelRequestAction];
    }
    
    NSString *str = [NSString stringWithFormat:@"%@t=GetCdType",Dam_webServer];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    _request = [ASIHTTPRequest requestWithURL:url];
    _request.timeOutSeconds = 30;
    [_request setCompletionBlock:^{
        //完成
        [SVProgressHUD dismissWithSuccess:nil];
        NSString *str = _request.responseString;
        NSArray *arr = [CustomUntils dealWithWebString:str];
        
        NSMutableArray *list = [NSMutableArray arrayWithCapacity:arr.count];
        for (int i =0; i<arr.count; i++) {
            NSDictionary *dic = [arr objectAtIndex:i];
            NSString *name = [dic objectForKey:@"name"];
            [list addObject:name];
        }
        DamCheckController *damCheck = [[DamCheckController alloc] init];
        damCheck.functionArr = list;
        [self.navigationController pushViewController:damCheck animated:YES];
    }];
    
    [_request setFailedBlock:^{
        //
        [SVProgressHUD dismissWithError:@"加载失败"];
    }];
    
    [SVProgressHUD show];
    _isLoad = YES;
    [_request startAsynchronous];
    
}

//取消异步网络请求。同步请求是不能取消的
- (void)cancelRequestAction
{
    //[[ASIHTTPRequest sharedQueue] cancelAllOperations];
    [_request cancel];
    _isLoad = NO;
}


@end
