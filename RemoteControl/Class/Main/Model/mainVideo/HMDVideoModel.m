//
//  HMDVideoModel.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/18.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDVideoModel.h"
@interface HMDVideoModel()
@property (nonatomic,strong) NSDictionary *callback_value_dict;
@end
@implementation HMDVideoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"videoID":@"id",
//             @"video_id":@"callback_value.video_id",
//             @"video_type":@"callback_value.video_type",
//             @"video_duration":@"callback_value.video_duration",
//             @"video_index":@"callback_value.video_index",
//             @"video_index_name":@"callback_value.video_index_name",
//             @"video_ui_style":@"callback_value.video_ui_style",
//             @"played_time":@"callback_value.played_time",
             };

}

-(NSString *)video_id{
    NSString *video_id = [self.callback_value_dict objectForKey:@"video_id"];
    return video_id;
}

-(NSString *)video_type{
    NSString *video_type = [self.callback_value_dict objectForKey:@"video_type"];
    return video_type;
}
-(NSString *)video_duration{
    NSString *video_duration = [self.callback_value_dict objectForKey:@"video_duration"];
    return video_duration;
}
-(NSString *)video_index{
    NSString *video_index = [self.callback_value_dict objectForKey:@"video_index"];
    return video_index;
}
-(NSString *)video_index_name{
    NSString *video_index_name = [self.callback_value_dict objectForKey:@"video_index_name"];
    return video_index_name;
}
-(NSString *)video_ui_style{
    NSString *video_ui_style = [self.callback_value_dict objectForKey:@"video_ui_style"];
    return video_ui_style;
}
-(NSString *)played_time{
    NSString *played_time = [self.callback_value_dict objectForKey:@"played_time"];
    return played_time;
}

-(NSDictionary *)callback_value_dict{
    if (_callback_value_dict == nil) {
        if (self.callback_value) {
            NSData *jsonData = [self.callback_value dataUsingEncoding:NSUTF8StringEncoding];
            _callback_value_dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];
        }
    }
    return _callback_value_dict;
}

-(void)setCallback_value:(NSString *)callback_value{
    _callback_value = callback_value;
    if (_callback_value_dict && _callback_value) {
        NSData *jsonData = [_callback_value dataUsingEncoding:NSUTF8StringEncoding];
        _callback_value_dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
    }
}

-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
}
@end
