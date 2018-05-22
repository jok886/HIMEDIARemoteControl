//
//  HMDMusicListTableViewCell.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/22.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDMusicListTableViewCell.h"
@interface HMDMusicListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLab;

@end
@implementation HMDMusicListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithMusicName:(NSString *)name serialNumber:(NSInteger)num{
    self.serialNumberLab.text = [NSString stringWithFormat:@"%ld",(long)num];
    NSString *musicName = [[[[name componentsSeparatedByString:@"/"]lastObject] componentsSeparatedByString:@"."] firstObject];
    self.musicNameLab.text = musicName;
}
@end
