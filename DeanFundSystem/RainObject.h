//
//  RainObject.h
//  DeanFundSystem
//*****************雨情信息**********************
//  Created by teddy on 15/1/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RainObject : NSObject

@property (nonatomic, strong) NSString *area;//区域
@property (nonatomic, strong) NSString *stnm;//测站名
@property (nonatomic, strong) NSString *stcd;//测站编号
@property (nonatomic, strong) NSString *today;//今日
@property (nonatomic, strong) NSString *yesterday;//昨日
@property (nonatomic, strong) NSString *FifteenminYL;//十五分钟最小雨量
@property (nonatomic, strong) NSString *thirtyminYL;//三十分钟最小雨量
@property (nonatomic, strong) NSString *OnehourYL;//一小时雨量
@property (nonatomic, strong) NSString *threehourYL;//三小时雨量
@property (nonatomic, strong) NSString *tweentyfourhourYL;//二十四小时雨量
@property (nonatomic, strong) NSString *OnehourWarnYL;//一小时警戒值                    
@property (nonatomic, strong) NSString *LL;

//日雨量对象
@property (nonatomic, strong) NSString *keyStr;
@property (nonatomic, strong) NSString *valueStr;
@end
