//
//  NSDate+BDAddition.h
//  BDSocketIM
//
//  Created by 冰点 on 16/2/24.
//  Copyright © 2016年 冰点. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (BDAddition)

///时间戳
+ (long)getTimestamp;

///日历时间
+ (NSDateComponents *)getCalendar;

@end
