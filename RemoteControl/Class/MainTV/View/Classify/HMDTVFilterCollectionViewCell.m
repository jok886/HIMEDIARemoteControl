//
//  HMDTVFilterCollectionViewCell.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/27.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDTVFilterCollectionViewCell.h"
@interface HMDTVFilterCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *videoIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;

@end
@implementation HMDTVFilterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setupTVFilterCellWithModel:(HMDVideoModel *)videoModel{
    [self.videoIconImageView setImageWithURLStr:videoModel.extra1 placeholderImage:[UIImage imageNamed:@"video_pic_default"]];
    NSString *score = videoModel.rating;
    if (score == nil || [score integerValue] == 0) {
        self.scoreLab.hidden = YES;
    }else{
        self.scoreLab.hidden = NO;
        self.scoreLab.text = score;
    }
    self.videoTitleLab.text = videoModel.title;
    
}
@end
