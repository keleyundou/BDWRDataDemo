//
//  BDDataOutputStream.m
//  BDSocketIM
//
//  Created by 冰点 on 16/2/22.
//  Copyright © 2016年 冰点. All rights reserved.
//

#import "BDDataOutputStream.h"

@implementation BDDataOutputStream

- (instancetype)init
{
    if (self = [super init]) {
        data = [[NSMutableData alloc] init];
        len = 0;
    }
    return self;
}

/*!
 *  @brief 将 1 byte 数值写入输出流中， 先写入高位
 *
 *  @param v char 数值类型
 */
- (void)writeChar:(int8_t)v;
{
    int8_t ch[1];
    ch[0] = (v & 0x0FF);
    [data appendBytes:ch length:sizeof(ch)];
    len++;
}

/*!
 *  @brief 将 2 byte 数值写入输出流中， 先写入高位
 *
 *  @param v short 数值类型
 */
- (void)writeShort:(int16_t)v;
{
    int8_t ch[2];
    ch[0] = (v & 0x0FF00) >> 8;
    ch[1] = (v & 0x0FF);
    [data appendBytes:ch length:sizeof(ch)];
    len += sizeof(ch);
}

/*!
 *  @brief 将 4 byte 数值写入输出流中， 先写入高位
 *
 *  @param v int 数值类型
 */
- (void)writeInt:(int32_t)v;
{
    int8_t ch[4];
    for (int32_t i = 0; i < sizeof(ch); i++) {
        ch[i] = ((v >> ((3-i) * 8)) & 0x0FF);
    }
    [data appendBytes:ch length:sizeof(ch)];
    len += sizeof(ch);
}

/*!
 *  @brief 将 8 byte 数值写入输出流中， 先写入高位
 *
 *  @param v long 数值类型
 */
- (void)writeLong:(int64_t)v;
{
    int8_t ch[8];
    for (int32_t i = 0; i < sizeof(ch); i++) {
        ch[i] = ((v >> ((7-i) * 8)) & 0x0FF);
    }
    [data appendBytes:ch length:sizeof(ch)];
    len += sizeof(ch);
}

/*!
 *  @brief 将 BCD时钟 写入输出流中
 *
 *  @param time 时间结构体
 */
- (void)writeBCDTime:(BDSTime *)time;
{
    //write year
    [self writeYearBCDTime:time -> year];
    //write month
    [self writeOtherBCDTime:time -> month];
    //write day
    [self writeOtherBCDTime:time -> day];
    //write hour
    [self writeOtherBCDTime:time -> hour];
    //write min
    [self writeOtherBCDTime:time -> min];
    //write sec
    [self writeOtherBCDTime:time -> sec];
}

/*!
 *  @brief 将 AA 作为帧头标识 写入输出流中
 */
- (void)writeFpsHeadTag;
{
    int8_t ch[1];
    ch[0] = 0xAA;
    [data appendBytes:ch length:sizeof(ch)];
    len++;
}

/*!
 *  @brief 将 分包状态 写入输出流中
 */
- (void)writeSubcontract;
{
    int8_t ch[1];
    ch[0] = 0x00;
    [data appendBytes:ch length:sizeof(ch)];
    len++;
}

- (void)writeSubcontract:(int8_t)v
{
    int8_t ch[1];
    ch[0] = v;
    [data appendBytes:ch length:sizeof(ch)];
    len++;
}

/*!
 *  @brief 将 String 写入输出流中
 *
 *  @param v String类型
 */
- (void)writeUTF8:(NSString *)v;
{
    NSData *d = [v dataUsingEncoding:NSUTF8StringEncoding];
    uint16_t s_len = (uint16_t)[d length];
    
    [self writeShort:s_len];
    [data appendData:d];
    len += s_len;
}

/*!
 *  @brief 将 NSData 写入输出流中
 *
 *  @param v NSData
 */
- (void)writeBytes:(NSData *)v;
{
    int32_t d_len = (int32_t)[v length];
    [self writeInt:d_len];
    [data appendData:v];
    len += d_len;
}

- (void)directWriteBytes:(NSData *)v;
{
    int32_t d_len = (int32_t)[v length];
    [data appendData:v];
    len += d_len;
}

/*!
 *  @brief 将 帧长 写入输出流中
 */
- (void)writeFpsLength;
{
    int8_t ch[4];
    for (int32_t i = 0; i < sizeof(ch); i++) {
        ch[i] = (((len+4) >> ((3-i) * 8)) & 0x0FF);
    }
    NSData *fpslen = [[NSData alloc] initWithBytes:ch length:sizeof(ch)];
    NSData *fps = [data subdataWithRange:NSMakeRange(0, 1)];
    NSData *otherData = [data subdataWithRange:NSMakeRange(1, len - 1)];
    NSMutableData *d = [NSMutableData dataWithData:fps];
    [d appendData:fpslen];
    [d appendData:otherData];
    data = [d copy];
}

/*!
 *  @brief 获取 1帧 数据
 *
 *  @return Data
 */
- (NSMutableData *)getBytesArray;
{
    return [[NSMutableData alloc] initWithData:data];
}

#pragma mark -
#pragma mark -private -M
//unsigned int intToBCD(unsigned int i){
//    unsigned int o=0, m=1;
//    while(i>0){
//        o += i % 10 * m;
//        m <<= 4;
//        i /= 10;
//    }
//    return o;
//}

Byte int_toBCD(unsigned int v) {
    Byte d1 = v / 10;
    Byte d2 = v % 10;
    Byte d = (d1 << 4) | d2;
    return d;
}

- (void)writeYearBCDTime:(int16_t)v
{
    unsigned int high, low;
    high = v / 100;
    low = v % 100;
    
    int8_t ch[2];
    ch[0] = int_toBCD(high);
    ch[1] = int_toBCD(low);
    [data appendBytes:ch length:sizeof(ch)];
    len += sizeof(ch);
}

- (void)writeOtherBCDTime:(int8_t)v
{
    int8_t ch[1];
    ch[0] = int_toBCD(v);
    [data appendBytes:ch length:sizeof(ch)];
    len += sizeof(ch);
}

@end
