//
//  HMDSearchHistoryCollectionViewCell.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/17.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDSearchHistoryCollectionViewCell.h"
@interface HMDSearchHistoryCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *historyLab;

@end
@implementation HMDSearchHistoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setHistoryText:(NSString *)historyString keyWord:(NSString *)keyWord{

    NSMutableAttributedString *showText = [[NSMutableAttributedString alloc] initWithString:historyString];
    NSRange keyWordRange= [historyString rangeOfString:keyWord];
    [showText addAttribute:NSForegroundColorAttributeName value:HMDMAIN_COLOR range:keyWordRange];

    self.historyLab.attributedText = showText;
}
@end
