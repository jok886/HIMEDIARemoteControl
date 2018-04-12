//
//  HMDSearchTipHeadView.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/11.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMDSearchTipHeadView;
typedef enum {
    HMDSearchTipRecord = 0, //搜索记录
    HMDSearchTipHot = 1,    //热门
} HMDSearchTipHeadStyle; //样式

@protocol HMDSearchTipHeadViewDelegate <NSObject>
@optional
-(void)searchTipHeadView:(HMDSearchTipHeadView *)searchTipHeadView clickBtnClick:(UIButton *)btn;
@end
@interface HMDSearchTipHeadView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *headTitleLab; //标题
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;    //删除

@property (nonatomic, assign) HMDSearchTipHeadStyle searchTipStyle;
/** 代理 */
@property (nonatomic, weak) id<HMDSearchTipHeadViewDelegate> delegate;

@end
