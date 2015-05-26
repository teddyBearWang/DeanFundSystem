//
//  DamCheckController.m
//  DeanFundSystem
//
//  Created by teddy on 15/1/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "DamCheckController.h"
#import "SelectedViewController.h"
#import "ModuleViewController.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"
#import "CustomUntils.h"
#import "DamObject.h"

#define Item_Width 100
#define Item_Height 80

@interface DamCheckController ()
{
    UIScrollView *_scrollView;
    ASIHTTPRequest *_request;
    BOOL _isload;
}

@end

@implementation DamCheckController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"检测部位";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:@"userID"];
    [self getMyCdTypeWebAction:userId];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-IOS7TopMargin)];
    _scrollView.backgroundColor = [UIColor lightGrayColor];
    _scrollView.contentSize = CGSizeMake(Screen_Width, Screen_Height - IOS7TopMargin);
    [self.view addSubview:_scrollView];
    
    [self createSelectItemView];
    
    [self changeScrollViewContentSize];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createSelectItemView
{
    for (int i=0; i<self.functionArr.count+1; i++) {
        int row = i / 2;
        int colum = i% 2;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = (CGRect){(40*(colum + 1)+colum*Item_Width), (50*(row + 1)+ row*Item_Height),Item_Width,Item_Height};
        if (i == self.functionArr.count) {
            [btn setTitle:@"+" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:24];
        }else{
            [btn setTitle:[self.functionArr objectAtIndex:i] forState:UIControlStateNormal];
        }
        btn.tag = i;
        btn.layer.borderWidth = 0.5f;
        btn.layer.cornerRadius = 5.0f;
        [btn addTarget:self action:@selector(selecteditemAction:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
    }
}

- (void)changeScrollViewContentSize
{
    int row = 0;
    int count = (self.functionArr.count+1) % 2;
    if (count == 0) {
        row = (int)(self.functionArr.count+1) / 2;
    }else{
        row = (int)(self.functionArr.count+1) / 2 + 1;
    }
    float height = 50*(row + 1)+ row*Item_Height;
    NSLog(@"屏幕高度：%f",Screen_Height);
    if (height > Screen_Height - IOS7TopMargin) {
        _scrollView.contentSize = CGSizeMake(Screen_Width, height);
    }
}

- (void)selecteditemAction:(UIButton *)btn
{
    if (btn.tag == self.functionArr.count) {
        SelectedViewController *select = [[SelectedViewController alloc] init];
        select.selectArr = self.functionArr;//传递到选择控制器
        [self presentViewController:select animated:YES completion:nil];
    } else {
        //选择的时其中一个功能
        [self getWebDataAction:[btn currentTitle]];
    }
}

//选择其中一个选项获得详细的web数据
#pragma mark - WebServer
- (void)getWebDataAction:(NSString *)name
{
    if (_isload) {
        [self cancelRequestAction];
    }
    //http://122.226.205.102/SfBzSer/Data.ashx?t=GetCdTypeChild&results=name
    NSString *str = [NSString stringWithFormat:@"%@t=GetCdTypeChild&results=%@",Dam_webServer,name];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    _request = [ASIHTTPRequest requestWithURL:url];
    _request.timeOutSeconds = 30;
    
    [_request setCompletionBlock:^{
        [SVProgressHUD dismissWithSuccess:nil];
        NSString *str = _request.responseString;
        NSArray *arr = [CustomUntils dealWithWebString:str];
        
        NSMutableArray *list = [NSMutableArray arrayWithCapacity:arr.count];
        for (int i=0; i<arr.count; i++) {
            DamObject *dam = [[DamObject alloc] init];
            NSDictionary *dic = (NSDictionary *)[arr objectAtIndex:i];
            dam.idNum = [dic objectForKey:@"id"];
            dam.name = [dic objectForKey:@"name"];
            dam.type = [dic objectForKey:@"type"];
            [list addObject:dam];
        }
        ModuleViewController *module = [[ModuleViewController alloc] init];
        module.dataList = list;
        [self.navigationController pushViewController:module animated:YES];
    }];
    
    [_request setFailedBlock:^{
        NSError *error = _request.error;
        NSLog(@"访问出错:%@",error);
        [SVProgressHUD dismissWithError:@"访问失败"];
    }];
    
    [SVProgressHUD show];
    _isload = YES;
    [_request startAsynchronous];
}

#pragma mark - 得到自己的监测类型

- (void)getMyCdTypeWebAction:(NSString *)ssid
{
    if (_isload) {
        [self cancelRequestAction];
    }
    NSString *str = [NSString stringWithFormat:@"%@t=GetMyCdType&results=%@",Dam_webServer,ssid];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    _request = [ASIHTTPRequest requestWithURL:url];
    _request.timeOutSeconds = 30;
    
    [_request setCompletionBlock:^{
        //OK
        [SVProgressHUD dismissWithSuccess:nil];
        NSString *str = _request.responseString;
        NSArray *arr = [CustomUntils dealWithWebString:str];
        
        self.functionArr = [NSMutableArray arrayWithCapacity:arr.count];
        for (int i=0; i<arr.count; i++) {
            NSDictionary *dic = (NSDictionary *)[arr objectAtIndex:i];
            NSString *titile = [dic objectForKey:@"title"];
            [self.functionArr addObject:titile];
        }
        //取得数据的同时，刷新UI界面
        if (_scrollView.subviews.count != 0) {
            //删除_scrollView上得所有子视图
            [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        [self createSelectItemView];
        [self changeScrollViewContentSize];
    }];

    [_request setFailedBlock:^{
        //failure
        [SVProgressHUD dismissWithError:@"获取监测类型失败"];
    }];
    [SVProgressHUD show];
    [_request startAsynchronous];
}

- (void)cancelRequestAction
{
    [_request cancel];
    _isload = NO;
}
@end
