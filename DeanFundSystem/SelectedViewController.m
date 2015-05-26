//
//  SelectedViewController.m
//  DeanFundSystem
//
//  Created by teddy on 15/1/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "SelectedViewController.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"

@interface SelectedViewController ()
{
    NSMutableArray *_func;
}

@end

@implementation SelectedViewController

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
    _func = [NSMutableArray arrayWithObjects:@"测缝针",@"量水堰",@"渗压计",@"温度计",@"扬压力", nil];
    
    self.mytableView.delegate = self;
    self.mytableView.dataSource = self;
    self.mytableView.allowsMultipleSelection = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _func.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [_func objectAtIndex:indexPath.row];
    if ([self.selectArr containsObject:cell.textLabel.text]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectArr removeObject:[_func objectAtIndex:indexPath.row]];
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectArr addObject:[_func objectAtIndex:indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)comfirmAction:(id)sender
{
    [self setMyCdTypeAction:self.selectArr];
}

#pragma mark - web Action
- (void)setMyCdTypeAction:(NSMutableArray *)list
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:@"userID"];
    
    NSString *str = [list componentsJoinedByString:@","];
    NSString *urlStr = [NSString stringWithFormat:@"%@t=SetMyCdType&results=%@$%@",Dam_webServer,userId,str];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.timeOutSeconds = 30;
    [request setCompletionBlock:^{
        //ok
        NSString *res = request.responseString;
        NSRange range = [res rangeOfString:@"true"];
        if (range.location != NSNotFound) {
            //表示包含
            //添加成功
            [SVProgressHUD dismissWithSuccess:nil];
            [self dismissViewControllerAnimated:YES completion:NULL];
        }else{
            [SVProgressHUD dismissWithError:@"添加失败"];
        }
    }];
    
    [request setFailedBlock:^{
        //failure
        [SVProgressHUD dismissWithError:@"添加失败"];
    }];
    
    [SVProgressHUD show];
    [request startAsynchronous];
}
@end
