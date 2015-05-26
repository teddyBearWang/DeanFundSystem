//
//  CustomUntils.m
//  DeanFundSystem
//
//  Created by teddy on 15/1/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "CustomUntils.h"
#import <objc/runtime.h>


@implementation CustomUntils

- (id)init
{
    self = [super init];
    if (self) {
        [self getCalendar];
    }
    return self;
}

- (void)getCalendar
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;//可以取到年月日
    comp = [calendar components:unitFlags fromDate:[NSDate date]];
    
    self.days = (int)comp.day;//当前的天数
    self.month = (int)comp.month;//当前的月份
    self.year = (int)comp.year;//当前的年份
}

//获取当前的日期
+ (NSString *)getNowDate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowDate = [formatter stringFromDate:now];
    return nowDate;
}

//检查str是否为空，为空的话则赋值@"--"
+ (NSString *)compareString:(NSString *)str
{
    NSString *results = nil;
    if (str.length == 0) {
        results = @"--";
    }else{
        results = str;
    }
    return results;

}

//根据传递进去的对象，遍历出所有的自定义属性
+ (NSMutableArray *)properties:(NSObject *)obj
{
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        //将char类型的字符转成NSString类型
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
    }
    free(properties);
    
    return props;
}

//根据穿入的对象，遍历出所有的自定以属性和对应的值
+ (NSMutableArray *)properties_aps:(NSObject *)obj
{
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        //将char类型的字符转成NSString类型
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        //属性名对象的属性值
        id propertyValue = [obj valueForKey:(NSString *)propertyName];
       if (propertyValue) [props addObject:propertyValue];
        //if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    //将区域，ll移除
    [props removeObjectAtIndex:0];
    [props removeLastObject];
    return props;
}

//解析字符串
+ (NSArray *)dealWithWebString:(NSString *)string
{
    NSRange range = NSMakeRange(1, string.length - 2);
    NSString *str = [string substringWithRange:range];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return arr;
}

@end
