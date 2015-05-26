//
//  DamObject.h
//  DeanFundSystem
//  ********大坝监测对象***********
//  Created by teddy on 15/1/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DamObject : NSObject

@property (nonatomic, strong) NSString *idNum;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;

//折线图对象
@property (nonatomic, strong) NSString *chartType; //类型
@property (nonatomic, strong) NSString *chartTime; //时间
@property (nonatomic, strong) NSString *chartTemperture; //温度值
@property (nonatomic, strong) NSString *chartResult; //结果
@property (nonatomic, strong) NSString *chartResult_1; //结果1
@property (nonatomic, strong) NSString *link_id; //link_id
@property (nonatomic, strong) NSString *chartPressure; //扬压力系数

@end
