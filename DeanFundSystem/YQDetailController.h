//
//  YQDetailController.h
//  DeanFundSystem
//
//  Created by teddy on 15/1/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RainObject.h"
#import "DateActionSheet.h"

@interface YQDetailController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
    int flag;//选择标志位；1表示主要，2表示日雨量，3表示月雨量，4表示年雨量
    NSMutableArray *_dataList; //数据源
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) RainObject *rain;

@end
