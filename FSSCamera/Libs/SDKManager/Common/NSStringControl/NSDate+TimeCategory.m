//
//  NSDate+TimeCategory.m
//  XMEye
//
//  Created by XM on 2017/3/2.
//  Copyright © 2017年 Megatron. All rights reserved.
//

#import "NSDate+TimeCategory.h"

static NSDateFormatter *dateFormatter;

@implementation NSDate (TimeCategory)

+(NSDateFormatter *)defaultFormatter{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc]init];
    });
    return dateFormatter;
}

+ (NSDate *)dateFromString:(NSString *)timeStr
                    format:(NSString *)format{
    NSDateFormatter *dateFormatter = [NSDate defaultFormatter];
    [dateFormatter setDateFormat:format];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    return date;
}

+ (int)getUnitTimeByStringDate:(NSString*)dateString
                    format:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    NSTimeInterval timeInMiliseconds = [dateFromString timeIntervalSince1970];
    return (int) timeInMiliseconds;
}

+ (NSInteger)cTimestampFromDate:(NSDate *)date{
    return (long)[date timeIntervalSince1970];
}


+(NSInteger)cTimestampFromString:(NSString *)timeStr
                          format:(NSString *)format{
    NSDate *date = [NSDate dateFromString:timeStr format:format];
    return [NSDate cTimestampFromDate:date];
}

+ (NSString *)dateStrFromCstampTime:(NSInteger)timeStamp
                     withDateFormat:(NSString *)format{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    return [NSDate datestrFromDate:date withDateFormat:format];
}

+ (NSString *)datestrFromDate:(NSDate *)date withDateFormat:(NSString *)format {
    NSDateFormatter* dateFormat = [NSDate defaultFormatter];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}

//通过传入的时间提取出年月日
+ (int)getYearFormDate:(NSDate*)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//[NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear) fromDate:date];
    int year = (int)[components year];
    if(year > 0){
        return year;
    }
    return 2017;
}
+ (int)getMonthFormDate:(NSDate*)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//[NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth) fromDate:date];
    int month = (int)[components month];
    if(month > 0){
        return month;
    }
    return 1;
}
+ (int)getDayFormDate:(NSDate*)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//[NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay) fromDate:date];
    int day = (int)[components day];
    if(day > 0){
        return day;
    }
    return 1;
}
+ (int)getHourFormDate:(NSDate*)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//[NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour) fromDate:date];
    int hour = (int)[components hour];
    if(hour > 0){
        return hour;
    }
    return 0;
}
+ (int)getMinuteFormDate:(NSDate*)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//[NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMinute) fromDate:date];
    int minute = (int)[components minute];
    if(minute > 0){
        return minute;
    }
    return 0;
}
+ (int)getSecondFormDate:(NSDate*)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//[NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitSecond) fromDate:date];
    int second = (int)[components second];
    if(second > 0){
        return second;
    }
    return 0;
}
+(NSArray*)getDateAray:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DateFormatter];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSArray *array = [dateString componentsSeparatedByString:@"-"];
    if (array == nil || array.count <3) {
        array = [NSArray arrayWithObjects:@"2017",@"1",@"1", nil];
    }
    return array;
}
+(NSArray*)getTimeAray:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:TimeFormatter2];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSArray *array = [dateString componentsSeparatedByString:@":"];
    if (array == nil || array.count <3) {
        array = [NSArray arrayWithObjects:@"0",@"0",@"0", nil];
    }
    return array;
}
//NSDate日期比较，是否是同一天，同一月，同一年
+ (BOOL)checkDate:(NSDate*)date1 WithDate:(NSDate*)date2{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return (([comp1 day] == [comp2 day]) && ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]));
}
//获取从1970年到现在的时间数
- (double)getCurrentDateInterval{
    NSDate *senddate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval index = [senddate timeIntervalSince1970] * 1000; //毫秒
    return index;
}
@end
