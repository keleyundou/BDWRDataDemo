//
//  BDDataInputStream.m
//  BDSocketIM
//
//  Created by 冰点 on 16/2/22.
//  Copyright © 2016年 冰点. All rights reserved.
//

#import "BDDataInputStream.h"

@implementation BDDataInputStream

- (instancetype)init
{
    if (self = [super init]) {
        len = 0;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)aData;
{
    if (self = [super init]) {
        data = [[NSData alloc] initWithData:aData];
    }
    return self;
}

+ (instancetype)dataInputStreamWithData:(NSData *)aData;
{
    BDDataInputStream *inputStream = [[BDDataInputStream alloc] initWithData:aData];
    return inputStream;
}

- (int32_t)read
{
    int8_t v;
    [data getBytes:&v range:NSMakeRange(len,1)];
    len++;
    return ((int32_t)v & 0x0FF);
}

- (int16_t)readFpsHeadTag
{
    int8_t v;
    [data getBytes:&v range:NSMakeRange(len, 1)];
    len++;
    return (int16_t)(v & 0xff);
}

- (BDSTime)readBCDTime
{
    struct BDSTime bcdTime;
    Byte year[2];
    Byte month[1], day[1], hour[1], min[1], sec[1];
    
    [data getBytes:&year range:NSMakeRange(len, sizeof(year))];
    len += sizeof(year);
    
    [data getBytes:&month range:NSMakeRange(len, sizeof(month))];
    len += sizeof(month);
    
    [data getBytes:&day range:NSMakeRange(len, sizeof(day))];
    len += sizeof(day);
    
    [data getBytes:&hour range:NSMakeRange(len, sizeof(hour))];
    len += sizeof(hour);
    
    [data getBytes:&min range:NSMakeRange(len, sizeof(min))];
    len += sizeof(min);
    
    [data getBytes:&sec range:NSMakeRange(len, sizeof(sec))];
    len += sizeof(sec);
    
    bcdTime.year = [self readBCDToYear:year];
    
    bcdTime.month = bcdToInt(month, sizeof(month));
    bcdTime.day = bcdToInt(day, sizeof(day));
    bcdTime.hour = bcdToInt(hour, sizeof(hour));
    bcdTime.min = bcdToInt(min, sizeof(min));
    bcdTime.sec = bcdToInt(sec, sizeof(sec));

    return bcdTime;
}

///bcd转int
unsigned int  bcdToInt(const unsigned char *bcd, int length)
{
    int tmp;
    unsigned int dec = 0;
    
    for(int i = 0; i < length; i++)
    {
        tmp = ((bcd[i] >> 4) & 0x0F) * 10 + (bcd[i] & 0x0F);
        dec += tmp * pow(100, length - 1 - i);
    }
    
    return dec;
}

- (int16_t)readBCDToYear:(Byte *)dt
{
    Byte *year = dt;
    Byte y_high = year[0];
    Byte y_low = year[1];

    int16_t high = bcdToInt(&y_high, sizeof(y_high));
    int16_t low = bcdToInt(&y_low, sizeof(y_low));
    return high*100+low;
}


- (int8_t)readSubcontract
{
    int8_t v;
    [data getBytes:&v range:NSMakeRange(len, 1)];
    len++;
    return v;
}


- (int8_t)readChar;
{
    int8_t v;
    [data getBytes:&v range:NSMakeRange(len, 1)];
    len++;
    return (v & 0x0FF);
}

- (int16_t)readShort;
{
    int32_t ch1 = [self read];
    int32_t ch2 = [self read];
    if ((ch1 | ch2) < 0) {
        @throw [NSException exceptionWithName:@"Exception" reason:@"EOFException" userInfo:nil];
    }
    return (int16_t)((ch1 << 8) + (ch2 << 0));
}

- (int32_t)readInt;
{
    int32_t ch1 = [self read];
    int32_t ch2 = [self read];
    int32_t ch3 = [self read];
    int32_t ch4 = [self read];
    if ((ch1 | ch2 | ch3 | ch4) < 0){
        @throw [NSException exceptionWithName:@"Exception" reason:@"EOFException" userInfo:nil];
    }
    return ((ch1 << 24) + (ch2 << 16) + (ch3 << 8) + (ch4 << 0));
}

- (int64_t)readLong;
{
    int8_t ch[8];
    [data getBytes:&ch range:NSMakeRange(len,8)];
    len += 8;
    
    return (((int64_t)ch[0] << 56) +
            ((int64_t)(ch[1] & 255) << 48) +
            ((int64_t)(ch[2] & 255) << 40) +
            ((int64_t)(ch[3] & 255) << 32) +
            ((int64_t)(ch[4] & 255) << 24) +
            ((ch[5] & 255) << 16) +
            ((ch[6] & 255) <<  8) +
            ((ch[7] & 255) <<  0));
}

- (NSString *)readUTF8;
{
    int32_t utfLength = [self readInt];
    NSData *d = [data subdataWithRange:NSMakeRange(len,utfLength)];
    NSString *str = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    len += utfLength;
    return str;
}

- (NSString *)readPort
{
    int16_t utf_len = [self readShort];
    NSData *d = [data subdataWithRange:NSMakeRange(len, utf_len)];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    len += utf_len;
    return s;
}

- (NSData *)readDataWithLength:(int)length;
{
    DLog(@"================>>>> lenght: %ld len:%d",(long)len,length);
    NSData *d =[data subdataWithRange:NSMakeRange(len, length)];
    len += length;
    return d;
}

- (NSData *)readLastData;
{
    DLog(@"=====>>> length %ld data's length %ld",(long)len,(unsigned long)[data length]);
    if ([data length] > len) {
        NSData *d =[data subdataWithRange:NSMakeRange(len, [data length])];
        len = [data length];
        return d;
    }
    return  nil;
}

- (NSUInteger)availabelLength
{
    return [data length];
}

#pragma mark -
#pragma mark -private -M
//unsigned int intToBCD(unsigned int i){
//    unsigned int o=0, m=1;
//    while(i>0){
//        o += i % 10 * m; m <<= 4; i /= 10;
//    }
//    return o;
//}

//- (void)writeYearBCDTime:(int16_t)v
//{
//    unsigned int high, low;
//    high = v / 100;
//    low = v % 100;
//    
//    int8_t ch[2];
//    ch[0] = intToBCD(high);
//    ch[1] = intToBCD(low);
////    [data appendBytes:ch length:sizeof(ch)];
//    len += sizeof(ch);
//}
//
//- (void)writeOtherBCDTime:(int8_t)v
//{
//    int8_t ch[1];
//    ch[0] = intToBCD(v);
////    [data appendBytes:ch length:sizeof(ch)];
//    len += sizeof(ch);
//}
@end
