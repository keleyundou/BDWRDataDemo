//
//  ViewController.m
//  BDWRDataDemo
//
//  Created by 冰点 on 16/3/16.
//  Copyright © 2016年 冰点. All rights reserved.
//

#import "ViewController.h"
#import "BDDataInputStream.h"
#import "BDDataOutputStream.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //write...
    //eg1:
    BDDataOutputStream *outputStream = [[BDDataOutputStream alloc] init];
    [outputStream writeChar:9];
    
    DLog(@"**** writeChar: %@ ****", outputStream.getBytesArray);//**** writeChar: <09> ****
    BDDataInputStream *inputStream = [[BDDataInputStream alloc] initWithData:outputStream.getBytesArray];
    int n = [inputStream readChar];
    DLog(@"**** readChar: %d ****", n);//**** readChar: 9 ****

    /************************************************/
    
    //eg2:
//    BDDataOutputStream *outputStream2 = [[BDDataOutputStream alloc] init];
//    //时间
//    BDSTime bcdTime = [self getSystemTime];
//    [outputStream2 writeBCDTime:&bcdTime];
//    
//    DLog(@"**** bcdTime %@ ****", [outputStream2 getBytesArray]);//**** bcdTime <20160316 140340> ****
//    
//    BDDataInputStream *inputStream2 = [[BDDataInputStream alloc] initWithData:outputStream2.getBytesArray];
//    BDSTime bcd_time = [inputStream2 readBCDTime];
//    
//    DLog(@"%d 年 %d月 %d日 %d：%d：%d", bcd_time.year, bcd_time.month, bcd_time.day, bcd_time.hour, bcd_time.min, bcd_time.sec);//2016 年 3月 16日 14：3：40
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
//MARK: Init

//MARK: setter & getter

//MARK: loadData

//MARK: Action

//MARK: delegate

//MARK: Other
- (BDSTime)getSystemTime
{
    struct BDSTime bcdTime;
    bcdTime.year = [NSDate getCalendar].year;
    bcdTime.month = [NSDate getCalendar].month;
    bcdTime.day = [NSDate getCalendar].day;
    bcdTime.hour = [NSDate getCalendar].hour;
    bcdTime.min = [NSDate getCalendar].minute;
    bcdTime.sec = [NSDate getCalendar].second;
    return bcdTime;
}


@end
