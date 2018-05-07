//
//  HMDVideoDataDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/18.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDVideoDataDao.h"

#import "HMDVideoModel.h"
#import "HMDTVClassifyModel.h"

#import "HMDVideoHistoryModel.h"
#import "NSString+HMDExtend.h"
@implementation HMDVideoDataDao
-(void)getRecommendVideoDataFinish:(HMDGetRecommendVideoDataFinishBlock)finish{
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"android",@"os",
                                @"m_chipset",@"chipset",
                                @"m_pid",@"pid",
                                @"",@"mac",
                                @"",@"version",
                                @"",@"aid",
                                @"mg,tx",@"mv_source",
                                nil];
//    NSString *parametersStr = [self encryptParameters:parameters];
    [session POST:HMD_DLAN_VIDEO_RECOMMEND_NETLIST parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
        if ([self successResponseFromHINAVI:responseDict]) {
            if ([[responseDict allKeys]containsObject:@"poster"]) {
                NSArray *posterArray = [responseDict objectForKey:@"poster"];
                NSArray *videoModelArray = [HMDVideoModel hmd_modelArrayWithKeyValuesArray:posterArray];
                if (finish) {
                    finish(YES,videoModelArray);
                }
            }else{
                if (finish) {
                    finish(YES,nil);
                }
            }
        }else{
            if (finish) {
                finish(NO,nil);
            }
        }
        


        NSLog(@"success");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finish) {
            finish(NO,nil);
        }
        NSLog(@"failure");
    }];
}

-(void)PostPlayNetPosterOrder:(HMDVideoModel *)videoModel finishBlock:(HMDPostPlayNetPosterOrderFinishBlock)finish{
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    
    
    NSString *recommendURL = [NSString stringWithFormat:HMD_DLAN_VIDEO_POSTER_PLAY,HMDCURLINKDEVICEIP];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                videoModel.source_package,@"source_package",
                                videoModel.callback_method,@"callback_method",
                                videoModel.callback_key,@"callback_key",
                                videoModel.callback_value,@"callback_value",
                                nil];
    [session POST:recommendURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (finish) {
            finish(YES);
        }
        NSLog(@"success");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finish) {
            finish(NO);
        }
        NSLog(@"failure");
    }];
}

-(void)getPlayHistoryFinishBlock:(HMDGetPlayHistoryFinishBlock)finishBlock{
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *recommendURL = [NSString stringWithFormat:HMD_DLAN_VIDEO_PLAY_HISTORY,HMDCURLINKDEVICEIP];
    [session GET:recommendURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *posterArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:nil];
        if (posterArray.count>0) {
            NSArray *videoModelArray = [HMDVideoHistoryModel hmd_modelArrayWithKeyValuesArray:posterArray];
            if (finishBlock) {
                finishBlock(YES,videoModelArray);
            }
        }else{
            if (finishBlock) {
                finishBlock(YES,nil);
            }
        }
        
        NSLog(@"success");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO,nil);
        }
        NSLog(@"failure");
    }];
}

-(void)playHistoryWithHistoryModel:(HMDVideoHistoryModel *)videoHistoryModel FinishBlock:(HMDPostPlayNetPosterOrderFinishBlock)finishBlock{
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *recommendURL = [NSString stringWithFormat:HMD_DLAN_VIDEO_PLAY_HISTORYVIDEO,HMDCURLINKDEVICEIP];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [videoHistoryModel.cmd mj_JSONString],@"cmd",
                                videoHistoryModel.videoSource,@"videoSource",
                                videoHistoryModel.videoImgUrl,@"videoImgUrl",
                                videoHistoryModel.extra,@"extra",
                                videoHistoryModel.videoCallback,@"videoCallback",
                                videoHistoryModel.date,@"date",
                                videoHistoryModel.videoAction,@"videoAction",
                                videoHistoryModel.videoName,@"videoName",
                                videoHistoryModel.vid,@"vid",
                                videoHistoryModel.week,@"week",
                                nil];
    [session POST:recommendURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (finishBlock) {
            finishBlock(YES);
        }
        NSLog(@"success");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO);
        }
        NSLog(@"failure");
    }];
}

-(void)getPosterCategoryFinishBlock:(HMDPosterCategoryFinishBlock)finishBlock{
    HMDWeakSelf(self)
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *recommendURL = [NSString stringWithFormat:HMD_DLAN_VIDEO_CATEGORY,HMDCURLINKDEVICEIP];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"/data/data/com.himedia.wallposter/shared_prefs/classifyxmlname.xml",@"posterCategory",
                                nil];
    [session POST:recommendURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responsDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *classifyModelArray = [NSMutableArray array];
        if ([responsDict isKindOfClass: [NSDictionary class]]) {
            if ([[responsDict allKeys] containsObject:@"category"]) {
                NSString *category = [responsDict objectForKey:@"category"];
                if ([category isEqualToString:@"net"]) {
                    if ([[responsDict allKeys] containsObject:@"content"]) {
                        NSString *content = [responsDict objectForKey:@"content"];
                        if ( content.length>1) {
                            NSDictionary *contentDict = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                            NSString *category = [contentDict objectForKey:@"category"];
                            NSArray *categoryArray = [NSJSONSerialization JSONObjectWithData:[category dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                            if ([categoryArray isKindOfClass:[NSArray class]] && categoryArray.count > 0) {
                                NSDictionary *categoryDict = [categoryArray firstObject];
                                NSArray *classify = [categoryDict objectForKey:@"classify"];
                                classifyModelArray = [NSMutableArray arrayWithArray:[HMDTVClassifyModel hmd_modelArrayWithKeyValuesArray:classify]];
                                NSLog(@"");
                            }
                        }

                    }
                }else{
                    if ([[responsDict allKeys] containsObject:@"content"]) {
                        NSString *content = [responsDict objectForKey:@"content"];
                        NSDictionary *contentDict = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                        NSArray *categoryArray = [contentDict objectForKey:@"category"];
                        if ([categoryArray isKindOfClass:[NSArray class]]) {
                            for (NSString *classify in categoryArray) {
                                HMDTVClassifyModel *classifyModel = [[HMDTVClassifyModel alloc] init];
                                classifyModel.flag = classify;
                                
                                classifyModel.title = classify;
                                [classifyModelArray addObject:classifyModel];
                            }
                        }
                    }
                }
            }

        }
        if (classifyModelArray.count >0){
            NSDictionary *classifyDict = [weakSelf reclassificationWithArray:classifyModelArray];
            if (finishBlock) {
                finishBlock(YES,classifyDict);
            }
            NSLog(@"success");
        }else {
            if (finishBlock) {
                finishBlock(NO,nil);
            }
            NSLog(@"failure");
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO,nil);
        }
        NSLog(@"failure");
    }];
}

-(NSDictionary *)reclassificationWithArray:(NSArray *)classifyModelArray{
    NSMutableArray *locationArray = [NSMutableArray array];
    NSMutableArray *typeArray = [NSMutableArray array];
    NSMutableArray *yearArray = [NSMutableArray array];
    for (HMDTVClassifyModel *classifyModel in classifyModelArray) {
        switch ([classifyModel.type integerValue]) {
            case 3:
            {
                [locationArray addObject:classifyModel];
            }
            break;
            default:
            {
                [typeArray addObject:classifyModel];
            }
            break;
        }
    }
    //年份以今年往前推10年
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components:unitFlags fromDate:dt];
    // 获取各时间字段的数值
    NSInteger year = comp.year;
    for (NSInteger i = year; i > year-10; i--) {

        HMDTVClassifyModel *classifyModel = [[HMDTVClassifyModel alloc] init];
        NSString *yearStr = [NSString stringWithFormat:@"%ld",(long)i];
        classifyModel.flag = yearStr;
        classifyModel.classifyID = yearStr;
        classifyModel.title = yearStr;
        classifyModel.type = @"5";
        [yearArray addObject:classifyModel];
    }
NSDictionary *classifyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              typeArray,@"type",
                              locationArray,@"location",
                              yearArray,@"year",
                              nil];
    return classifyDict;

}
@end
