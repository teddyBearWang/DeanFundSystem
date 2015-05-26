//
//  WaterObject.h
//  DeanFundSystem
//*****************水情对象*********************
//  Created by teddy on 15/1/23.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaterObject : NSObject

@property (nonatomic, strong) NSString *areaStr; //区域
@property (nonatomic, strong) NSString *stnmStr;//站名
@property (nonatomic, strong) NSString *stcdStr;//测站编号
@property (nonatomic, strong) NSString *yesEighthourSWStr;//昨日8小时水位
@property (nonatomic, strong) NSString *eighthourSWStr;//8小时水位
@property (nonatomic, strong) NSString *maxSWStr;//最大水位
@property (nonatomic, strong) NSString *eighthourKRStr;//8小时库容
@property (nonatomic, strong) NSString *currentSWStr;//最新水位
@property (nonatomic, strong) NSString *currentTMStr;// 水位时间
@property (nonatomic, strong) NSString *currentKRStr;//当前库容
@property (nonatomic, strong) NSString *txjjswStr;//台汛季节水位
@property (nonatomic, strong) NSString *mxjjswStr;//梅汛季节水位
@property (nonatomic, strong) NSString *llStr;//流量

//日水位对象
@property (nonatomic, strong) NSString *keyStr;
@property (nonatomic, strong) NSString *valueStr;


@end
