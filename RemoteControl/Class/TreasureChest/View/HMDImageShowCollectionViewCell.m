//
//  HMDImageShowCollectionViewCell.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/24.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDImageShowCollectionViewCell.h"

@implementation HMDImageShowCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCellState:(HMDImageShowCollectionViewCellState)cellState{
    switch (cellState) {
        case HMDImageShowCollectionViewCellNormalState:
            self.cellStateImageView.hidden = YES;
            break;
        case HMDImageShowCollectionViewCellSelectState:
            self.cellStateImageView.hidden = NO;
            self.cellStateImageView.image = [UIImage imageNamed:@"select_on"];
            break;
        case HMDImageShowCollectionViewCellUnselectState:
            self.cellStateImageView.hidden = NO;
            self.cellStateImageView.image = [UIImage imageNamed:@"select_off"];
            break;
        default:
            break;
    }
    _cellState = cellState;
}
@end
