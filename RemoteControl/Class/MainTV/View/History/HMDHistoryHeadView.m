//
//  HMDHistoryHeadView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/25.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDHistoryHeadView.h"

@interface HMDHistoryHeadView()
@property (weak, nonatomic) IBOutlet UIImageView *timeIcon;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation HMDHistoryHeadView

-(void)setheadWithToday:(BOOL)today{
    if (today) {
        [self.timeIcon setImage:[UIImage imageNamed:@"history_today"]];
        self.timeLab.text = @"今天";
        [self.timeLab setTextColor:HMDMAIN_COLOR];
    }
}

@end
