//
//  NSString+HMDExtend.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/26.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HMDExtend)
/*
 *  时间戳对应的NSDate
 */
//@property (nonatomic,strong,readonly) NSDate *date;

//计算宽度
- (CGFloat)calculateRowWidthWithHight:(CGFloat)hight fontSize:(NSInteger)font;
//计算高度
- (CGFloat)calculateRowHeightWithWidth:(CGFloat)width fontSize:(NSInteger)fontSize;
//转换时间
-(NSString *)timeSince1970_yyyy_MM_dd_hh_mm_ss;
//今日
-(BOOL)isTodayTime;
//昨日
-(BOOL)isYesterday;
//今年
-(BOOL)isThisYear;
//一周内
-(BOOL)isInAWeek;
@end
