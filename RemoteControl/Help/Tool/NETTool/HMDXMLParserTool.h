//
//  HMDXMLParserTool.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//  XML解析器

#import <Foundation/Foundation.h>
typedef void(^XMLParserfinishBlock)(BOOL success);           //XML解析结束
@interface HMDXMLParserTool : NSObject
-(void)startParserWithXMLData:(NSData *)xmlData;
@end
