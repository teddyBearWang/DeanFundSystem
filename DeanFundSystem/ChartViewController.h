//
//  ChartViewController.h
//  DeanFundSystem
// **************图标****************
//  Created by teddy on 15/1/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHLineGraphView.h"
#import "SHPlot.h"

@interface ChartViewController : UIViewController
{
    NSMutableArray *_dataList;
}

@property (nonatomic, strong) NSMutableArray *typeArr;//类型数组
@property (nonatomic, nonatomic)  SHLineGraphView *chartView;

@end
