//
//  HPCastBarrage.h
//  HPCastLink
//
//  Created by 王志军 on 2016/10/31.
//  Copyright © 2016年 王志军. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum { //弹幕类型
    HPBarrageTypeFromRight = 1,     // 从屏幕右边飞出弹幕 默认
    HPBarrageTypeFromLeft = 6,      // 从屏幕左边飞出弹幕
    HPBarrageTypeBottomFixed = 4,   // 屏幕底部固定弹幕 显示时间为4妙
    HPBarrageTypeTopFixed = 5,      // 屏幕顶部固定弹幕 显示时间为4妙
}HPBarrageType;


@interface HPCastBarrage : NSObject

//  弹幕id
@property (nonatomic,assign)NSInteger barrageId;

//  弹幕类型    默认HPBarrageTypeFromRight
@property (nonatomic,assign)HPBarrageType type;

//  弹幕文本
@property (nonatomic,copy)NSString *text;

//  弹幕字体大小  默认20
@property (nonatomic,assign)NSInteger fontSize;

//  文字颜色     默认whiteColor  可设颜色透明度
@property (nonatomic,copy)UIColor *textColor;

//  文字边缘颜色  默认clearColor
@property (nonatomic,copy)UIColor *textEdgeColor;

//  下划线颜色   默认clearColor
@property (nonatomic,copy)UIColor *underlineColor;

//  边框颜色    默认clearColor
@property (nonatomic,copy)UIColor *borderColor;

//  边距(边框与文字距离) 默认值10
@property (nonatomic,assign)NSInteger margin;

//  延迟出现时间（单位为毫米）默认值 0
@property (nonatomic,assign)NSInteger delaytime;

//  用户id
@property (nonatomic,assign)NSInteger userid;

@end
