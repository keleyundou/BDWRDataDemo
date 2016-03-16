//
//  NSDate+BDAddition.m
//  BDSocketIM
//
//  Created by 冰点 on 16/2/24.
//  Copyright © 2016年 冰点. All rights reserved.
//

#import "NSDate+BDAddition.h"

@implementation NSDate (BDAddition)

+ (long)getTimestamp
{
    return [[NSDate date] timeIntervalSince1970];
}

+ (NSDateComponents *)getCalendar
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *now = [NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    return comps;
}

@end
