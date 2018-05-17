//
//  HMDSearchTipCollectionViewCell.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/11.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDSearchTipCollectionViewCell.h"
@interface HMDSearchTipCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *tipLab;

@end
@implementation HMDSearchTipCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setupCellWithTipSting:(NSString *)tip needCenter:(BOOL)needCenter deleteBtn:(BOOL)needDeleteBtn{
    self.tipLab.text = tip;
}

//点击删除按钮
- (IBAction)deleteBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTipCollectionViewCellDeleteAtIndexPath:)]) {
        [self.delegate searchTipCollectionViewCellDeleteAtIndexPath:self.indexPath];
    }
}


@end
