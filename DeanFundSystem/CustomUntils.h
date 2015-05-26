//
//  CustomUntils.h
//  DeanFundSystem
//
//  Created by teddy on 15/1/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomUntils : NSObject

@property (nonatomic, assign) int days;//当前的天数
@property (nonatomic, assign) int month;//当前的月份
@property (nonatomic, assign) int year;//当前的年份


//获取当前的日期;2015-01-27
+ (NSString *)getNowDate;

//检查str是否为空，为空的话则赋值@"--"
+ (NSString *)compareString:(NSString *)str;

//根据传递进去的对象，遍历出所有的自定义属性
+ (NSMutableArray *)properties:(NSObject *)obj;

//根据穿入的对象，遍历出所有的自定以属性和对应的值
+ (NSMutableDictionary *)properties_aps:(NSObject *)obj;

+ (NSArray *)dealWithWebString:(NSString *)string;

@end
