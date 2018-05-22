//
//  HMDHotTipCollectionViewCell.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/18.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDHotTipCollectionViewCell.h"
@interface HMDHotTipCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *levelNumLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end
@implementation HMDHotTipCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setHotTipWithName:(NSString *)name level:(NSInteger)level{
    self.levelNumLab.text = [NSString stringWithFormat:@"%ld",(long)level];
    self.nameLab.text = name;
    switch (level) {
        case 1:
        {
            [self.levelNumLab setTextColor:[UIColor whiteColor]];
            self.levelNumLab.backgroundColor = HMDColor(230, 0, 18, 1);
        }
            break;
        case 2:
        {
            [self.levelNumLab setTextColor:[UIColor whiteColor]];
            self.levelNumLab.backgroundColor = HMDColor(235, 97, 0, 1);
        }
            break;
        case 3:
        {
            [self.levelNumLab setTextColor:[UIColor whiteColor]];
            self.levelNumLab.backgroundColor = HMDColor(243, 152, 0, 1);
        }
            break;
            
        default:
        {
            [self.levelNumLab setTextColor:HMDColor(153, 153, 153, 1)];
            self.levelNumLab.backgroundColor = HMDColor(211, 211, 211, 1);
        }
            break;
    }
    
}
@end
