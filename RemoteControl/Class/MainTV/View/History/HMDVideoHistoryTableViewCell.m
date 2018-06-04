//
//  HMDVideoHistoryTableViewCell.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/25.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDVideoHistoryTableViewCell.h"

@interface HMDVideoHistoryTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *historyInfoLab;

@end

@implementation HMDVideoHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithHistoryModel:(HMDVideoHistoryModel *)historyModel{
    self.nameLab.text = historyModel.videoName;
    if (historyModel.cmd.lastTime == nil) {
        self.historyInfoLab.text = @"上次播放至:00:00";
    }else{
         self.historyInfoLab.text = [NSString stringWithFormat:@"上次播放至:%@",historyModel.cmd.lastTime];
    }
   
}
@end
