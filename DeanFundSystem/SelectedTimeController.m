//
//  SelectedTimeController.m
//  DeanFundSystem
//
//  Created by teddy on 15/2/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "SelectedTimeController.h"
#import "DateActionSheet.h"
#import "DateObject.h"
#import "CustomUntils.h"

@interface SelectedTimeController ()
{
    BOOL _isShow;
    int flag ; //标识哪个button, 1表示st_btn;2表示et_btn
}

@end

@implementation SelectedTimeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 44+20)];
    bar.barTintColor = [[UIColor colorWithRed:27/255.0 green:146/255.0 blue:245/255.0 alpha:1.0f] colorWithAlphaComponent:0.8f];
    bar.translucent = NO;
    [self.view addSubview:bar];
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED >=70000
    if (IOS7_OR_LATER) {
        bar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
#endif
    
    NSString *nowTime = [CustomUntils getNowDate];
    NSString *etTime = [NSString stringWithFormat:@"%@",nowTime];
    NSString *stTimeStr = [self getTheSevenDayAgo];
    NSString *stTime = [stTimeStr substringToIndex:10];
    
    self.st_label.layer.borderColor = [UIColor blackColor].CGColor;
    self.et_label.layer.borderColor = [UIColor blackColor].CGColor;
    self.st_label.layer.borderWidth = 1.0f;
    self.et_label.layer.borderWidth = 1.0f;
    
    [self.st_btn setTitle:stTime forState:UIControlStateNormal];
    self.st_btn.layer.borderWidth = 1.0;
    self.st_btn.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self.et_btn setTitle:etTime forState:UIControlStateNormal];
    self.et_btn.layer.borderColor = [UIColor blackColor].CGColor;
    self.et_btn.layer.borderWidth = 1.0f;
    
    
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"请选择查询时间"];
    [bar pushNavigationItem:navItem animated:YES];
    
    UIButton *comfirm_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirm_btn.frame = CGRectMake(0, 0, 60, 30);
    [comfirm_btn setTitle:@"确定" forState:UIControlStateNormal];
    [comfirm_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [comfirm_btn addTarget:self action:@selector(comfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:comfirm_btn];
    navItem.rightBarButtonItem = right;
    
    
    UIButton *cancel_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel_btn.frame = CGRectMake(0, 0, 60, 30);
    [cancel_btn setTitle:@"取消" forState:UIControlStateNormal];
    [cancel_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancel_btn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:cancel_btn];
    navItem.leftBarButtonItem = left;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)setBlock:(ReturnBlock)block
{
    self.returnBlock = block;
}

- (IBAction)selectStTimeAction:(id)sender
{
    if (_isShow == NO) {
        DateActionSheet *sheet = [[DateActionSheet alloc] initWithTitle:nil delegate:self];
        [sheet showInView:self.view];
        flag = 1;
        _isShow = YES;
    }
}

- (IBAction)SelectEtTimeAction:(id)sender
{
    if (_isShow == NO) {
        DateActionSheet *sheet = [[DateActionSheet alloc] initWithTitle:nil delegate:self];
        [sheet showInView:self.view];
        flag = 2;
        _isShow = YES;
    }
}

- (void)comfirmAction:(UIButton *)btn
{
    NSString *st = [NSString stringWithFormat:@"%@ 09:00",self.st_btn.currentTitle];
    NSString *et = [NSString stringWithFormat:@"%@ 09:00",self.et_btn.currentTitle];
    int days = [self getDaysBetweenDay1:st withDay2:et];
    if (days >= 0) {
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:st,et,nil];
        [self dismissViewControllerAnimated:YES completion:^{
            //结束
            self.returnBlock(arr);
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"开始时间不能晚于结束时间，请重新选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
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

- (void)cancelAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
            case 1:
                [self.st_btn setTitle:time forState:UIControlStateNormal];
                break;
            case 2:
                [self.et_btn setTitle:time forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    _isShow = NO;
}
@end
