//
//  BDDataOutputStream.h
//  BDSocketIM
//
//  Created by 冰点 on 16/2/22.
//  Copyright © 2016年 冰点. All rights reserved.
//  将基本数据写入到输出流中
//

#import <Foundation/Foundation.h>


@interface BDDataOutputStream : NSObject
{
    @private
    NSMutableData *data;
    NSInteger len;//==local
}

/*!
 *  @brief 将 1 byte 数值写入输出流中， 先写入高位
 *
 *  @param v char 数值类型
 */
- (void)writeChar:(int8_t)v;

/*!
 *  @brief 将 2 byte 数值写入输出流中， 先写入高位
 *
 *  @param v short 数值类型
 */
- (void)writeShort:(int16_t)v;

/*!
 *  @brief 将 4 byte 数值写入输出流中， 先写入高位
 *
 *  @param v int 数值类型
 */
- (void)writeInt:(int32_t)v;

/*!
 *  @brief 将 8 byte 数值写入输出流中， 先写入高位
 *
 *  @param v long 数值类型
 */
- (void)writeLong:(int64_t)v;

/*!
 *  @brief 将 BCD时钟 写入输出流中
 *
 *  @param time 时间结构体
 */
- (void)writeBCDTime:(BDSTime *)time;

/*!
 *  @brief 将 AA 作为帧头标识 写入输出流中
 */
- (void)writeFpsHeadTag;

/*!
 *  @brief 将 分包状态 写入输出流中
 *  NOTE: default 00 -> 0000 0000 
 *  0-3字节为：不分包标识（值为0）
 *  4-7字节为特殊命令
 */
- (void)writeSubcontract;
- (void)writeSubcontract:(int8_t)v;

/*!
 *  @brief 将 String 写入输出流中
 *
 *  @param v String类型
 */
- (void)writeUTF8:(NSString *)v;

/*!
 *  @brief 将 NSData 写入输出流中
 *
 *  @param v NSData
 */
- (void)writeBytes:(NSData *)v;
- (void)directWriteBytes:(NSData *)v;
/*!
 *  @brief 将 帧长 写入输出流中
 */
- (void)writeFpsLength;

/*!
 *  @brief 获取 1帧 数据
 *
 *  @return Data
 */
- (NSMutableData *)getBytesArray;

@end
