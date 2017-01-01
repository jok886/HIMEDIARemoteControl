//
//  UIView+Additions.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)
//事件响应链 下一个响应者
-(UIViewController *)getCurViewController;
@end
