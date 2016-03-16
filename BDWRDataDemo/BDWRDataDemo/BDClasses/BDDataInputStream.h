//
//  BDDataInputStream.h
//  BDSocketIM
//
//  Created by 冰点 on 16/2/22.
//  Copyright © 2016年 冰点. All rights reserved.
//  从输入流中读取基本数据 以便解组自定义值类型
//

#import <Foundation/Foundation.h>

@interface BDDataInputStream : NSObject
{
    @private
    NSData *data;
    NSInteger len;
}

- (instancetype)initWithData:(NSData *)aData;

+ (instancetype)dataInputStreamWithData:(NSData *)aData;

- (int16_t)readFpsHeadTag;
- (int8_t)readSubcontract;
- (BDSTime)readBCDTime;
- (int8_t)readChar;
- (int16_t)readShort;
- (int32_t)readInt;
- (int64_t)readLong;
- (NSString *)readUTF8;
- (NSString *)readPort;
- (NSData *)readDataWithLength:(int)len;
- (NSData *)readLastData;

@property (nonatomic, readonly) NSUInteger availabelLength;

@end
