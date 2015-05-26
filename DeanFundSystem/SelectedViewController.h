//
//  SelectedViewController.h
//  DeanFundSystem
// **********添加控制器*************
//  Created by teddy on 15/1/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectedViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (nonatomic, strong) NSMutableArray *selectArr; //

- (IBAction)cancelAction:(id)sender;

- (IBAction)comfirmAction:(id)sender;
@end
