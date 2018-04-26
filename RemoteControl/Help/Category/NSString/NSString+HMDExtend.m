//
//  NSString+HMDExtend.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/26.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "NSString+HMDExtend.h"

@implementation NSString (HMDExtend)
- (CGFloat)calculateRowWidthWithHight:(CGFloat)hight fontSize:(NSInteger)font{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(0, hight)options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

- (CGFloat)calculateRowHeightWithWidth:(CGFloat)width fontSize:(NSInteger)fontSize{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}

/*
 *  时间戳对应的NSDate
 */
-(NSDate *)dateSince1970{
    
    NSTimeInterval timeInterval=self.floatValue/1000.0;
    
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

-(NSString *)timeSince1970_yyyy_MM_dd_hh_mm_ss{
    return [self timeSince1970WithDateFormat:@"yyyy-MM-dd hh:mm:ss"];
}

-(NSString *)timeSince1970_yyyy_MM_dd{
    return [self timeSince1970WithDateFormat:@"yyyy-MM-dd"];
}
-(NSString *)timeSince1970WithDateFormat:(NSString *)dateFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =dateFormat;
    return [formatter stringFromDate:[self dateSince1970]];
}
//今日
-(BOOL)isTodayTime{
    if ([[self timeSince1970_yyyy_MM_dd] isEqualToString:[self getCurTimeyyyy_MM_dd]]){
        return YES;
    }else{
        return NO;
    }
}
//昨日
-(BOOL)isYesterday{
    NSDate *todayDate = [NSDate date];
    NSDate *yesterdayDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:todayDate];
    NSString *yesterday = [self getTimeyyyy_MM_ddWithDate:yesterdayDate];
    NSString *timeStr = [self timeSince1970_yyyy_MM_dd];

    if ([timeStr isEqualToString:yesterday]) {
        return YES;
    }else{
        return NO;
    }
}
//今年
-(BOOL)isThisYear{

    NSString *today = [self getCurTimeyyyy_MM_dd];
    //年月
    NSString *todayYYYY = [today substringWithRange:NSMakeRange(0, 4)];
    
    NSString *timeStr = [self timeSince1970_yyyy_MM_dd];
    NSString *timeYYYY = [timeStr substringWithRange:NSMakeRange(0, 4)];
    if ([todayYYYY isEqualToString:timeYYYY]) {
        return YES;
    }else{
        return NO;
    }
}
//一周内
-(BOOL)isInAWeek{
    NSDate *todayDate = [NSDate date];
    NSDate *weekDate = [NSDate dateWithTimeInterval:-24*60*60*7 sinceDate:todayDate];
    NSString *weekStr = [self getTimeyyyy_MM_ddWithDate:weekDate];
    NSString *timeStr = [self timeSince1970_yyyy_MM_dd];

    if ([weekStr isEqualToString:timeStr]) {
        return YES;
    }else{
        return NO;
    }
}

-(NSString *)getCurTimeyyyy_MM_dd{
    return [self getTimeyyyy_MM_ddWithDate:[NSDate date]];
}

-(NSString *)getTimeyyyy_MM_ddWithDate:(NSDate *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *curTime = [formatter stringFromDate:time];
    return curTime;
}
@end
