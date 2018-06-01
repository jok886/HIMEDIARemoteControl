//
//  HMDLanguageTool.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/31.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//
#define HMDGetStringWithKeyFromTable(key, tbl) [[FGLanguageTool sharedInstance] getStringForKey:key withTable:tbl]
#import <Foundation/Foundation.h>

@interface HMDLanguageTool : NSObject
+(HMDLanguageTool *)sharedInstance;

/**
 *  返回table中指定的key的值
 *
 *  @param key   key
 *  @param table table
 *
 *  @return 返回table中指定的key的值
 */
-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;

/**
 *  改变当前语言
 */
-(void)changeNowLanguage;

/**
 *  设置新的语言
 *
 *  @param language 新语言
 */
-(void)setNewLanguage:(NSString*)language;
@end
