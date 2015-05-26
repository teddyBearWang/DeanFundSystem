//
//  WaterViewController.h
//  DeanFundSystem
//***************水情******************
//  Created by teddy on 15/1/22.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_myTable;
    NSMutableArray *_dataList;//数据源
}

@property (nonatomic, strong) UITableView *myTable;
@property (nonatomic, strong) NSMutableArray *dataList;
@end
