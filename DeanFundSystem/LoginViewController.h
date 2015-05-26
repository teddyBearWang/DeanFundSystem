//
//  LoginViewController.h
//  DeanFundSystem
//
//  Created by teddy on 15/2/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)loginAction:(id)sender;
- (IBAction)tapBackbroundAction:(id)sender;
@end
