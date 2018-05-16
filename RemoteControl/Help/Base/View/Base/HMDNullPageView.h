//
//  HMDNullPageView.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/15.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDNullPageView : UIView
@property (nonatomic,assign) BOOL needReloadBtn;
@property (nonatomic,copy) void(^reloadBtnClickBlock)(void);
@end
