//
//  LoginViewController.m
//  DeanFundSystem
//
//  Created by teddy on 15/2/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "LoginViewController.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"
#import "MainViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender
{
    if (self.userField.text.length == 0 || self.passwordField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"用户名或者密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //http://122.226.205.102/sbskSer/data_ht.ashx?t=CheckUserInfo&results=admin$sfsk123
    
    NSString *str = [NSString stringWithFormat:@"%@t=CheckUserInfo&results=%@$%@",Web_Server,self.userField.text,self.passwordField.text];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.timeOutSeconds = 30;
    [request setCompletionBlock:^{
        NSString *str = request.responseString;
        NSString *str1 = [str stringByReplacingOccurrencesOfString:@"(" withString:@"["];
        NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@")" withString:@"]"];
        NSData *data = [str2 dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        for (int i=0; i<arr.count; i++) {
            NSDictionary *dic = (NSDictionary *)[arr objectAtIndex:i];
            NSString *userID = [dic objectForKey:@"sid"];
            //保存到本地
            [self saveToUserDefault:userID];
            if ([[dic objectForKey:@"success"] isEqualToString:@"true"]) {
                [SVProgressHUD dismissWithSuccess:@"登陆成功"];
                MainViewController *main = [[MainViewController alloc] init];
                [self.navigationController pushViewController:main animated:YES];
            }else{
                [SVProgressHUD dismissWithSuccess:@"登陆失败"];
            }
        }
    }];
    
    [request setFailedBlock:^{
        //失败
        [SVProgressHUD dismissWithError:@"登录失败"];
    }];
    
    [SVProgressHUD show];
    [request startAsynchronous];
}

//单击背景取消键盘
- (IBAction)tapBackbroundAction:(id)sender
{
    [self.userField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

//将登陆获取到得userId保存在本地
- (void)saveToUserDefault:(NSString *)userID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userID forKey:@"userID"];
    //同步
    [defaults synchronize];
}
@end
