//
//  HMDSearchTipHeadView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/11.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDSearchTipHeadView.h"

@interface HMDSearchTipHeadView()



@end

@implementation HMDSearchTipHeadView

-(void)awakeFromNib{
    [super awakeFromNib];

}


- (IBAction)clearBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTipHeadView:clickBtnClick:)]) {
        [self.delegate searchTipHeadView:self clickBtnClick:sender];
    }
}

-(void)setSearchTipStyle:(HMDSearchTipHeadStyle)searchTipStyle{
    _searchTipStyle = searchTipStyle;
    switch (searchTipStyle) {
        case HMDSearchTipRecord:
        {
            self.headTitleLab.text = @"搜索记录";
            self.clearBtn.hidden = NO;
        }
            break;
        case HMDSearchTipHot:
        {
            self.headTitleLab.text = @"热门搜索";
            self.clearBtn.hidden = YES;
        }
            break;
        default:
            break;
    }
}

@end
