//
//  DataSQController.h
//  DeanFundSystem
//***********日水位********
//  Created by teddy on 15/1/23.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterObject.h"

@class DateActionSheet;
@interface DataSQController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView *_myTableView;
    UIView *_selectView;
    int flag;//1表示选择主要，2表示日水位
    UIView *_flagView1; //标志的view
    UIView *_flagView2;
    NSArray *_functionArr1; //主要功能下的数据源
    NSArray *_valueArray;//主要功能下的数据源
    NSMutableArray *_dateArr;//日水位下的数据源
    BOOL _isShow;//表示选择日期控件的显示情况
    NSString *SelectedTime;//选择的时间
    
}

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) WaterObject *water;//点击的水情对象
//@property (nonatomic, strong) NSString *stcd;//编号

@end
