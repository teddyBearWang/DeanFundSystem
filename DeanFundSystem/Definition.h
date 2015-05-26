//
//  Definition.h
//  DeanFundSystem
//
//  Created by teddy on 15/1/22.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Margin 5
#define Padding 10
#define IOS7TopMargin 64 //导航栏44，状态栏20

#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)

#define Screen_Height   [UIScreen mainScreen].bounds.size.height
#define Screen_Width     [UIScreen mainScreen].bounds.size.width

#define Button_View_Height 100 //buttonView的高度
#define Button_View_Width 80    //buttonView的宽度

#define Button_height 70
#define Button_width 70

#define Cell_height 50 //单元格高度
#define NavigationBar_height 44  //导航栏的高度
#define Web_Server @"http://122.226.205.102/sbskSer/data_ht.ashx?" //水雨情数据的服务地址
#define Dam_webServer @"http://122.226.205.102/SfBzSer/Data.ashx?"

#define NavigationItem_TitleColor [UIColor whiteColor] //导航栏上item得字体颜色
