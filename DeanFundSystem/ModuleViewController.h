//
//  ModuleViewController.h
//  DeanFundSystem
//**************被选择的模块****************
//  Created by teddy on 15/1/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModuleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_myTableView;
    NSMutableArray *_dataList; //数据源
}

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *selectArr; //被选择的类型数组

@end
