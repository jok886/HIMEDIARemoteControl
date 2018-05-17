//
//  HMDFavoriteVideoTableViewCell.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/17.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDFavoriteVideoTableViewCell.h"
#import "NSString+HMDExtend.h"
@interface HMDFavoriteVideoTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoNameLab;
@property (weak, nonatomic) IBOutlet UILabel *videoTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLab;

@end

@implementation HMDFavoriteVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithModel:(HMDVideoHistoryModel *)videoModel{
    NSString *url = [NSString stringWithFormat:HMD_DLAN_VIDEO_GET_POSTERIMAGE,HMDCURLINKDEVICEIP];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:videoModel.videoImgUrl,@"posterPicString", nil];
    [self.videoImageView setDLANImageWithMethod:@"POST" URLStr:url parameters:parameters placeholderImage:[UIImage imageNamed:@"video_pic_default"]];
    self.videoNameLab.text = videoModel.videoName;
    NSString *time = [videoModel.time timeSince1970_yyyy_MM_dd_hh_mm_ss];
    if (time.length >4) {
        self.videoTimeLab.hidden = NO;
        self.videoTimeLab.text = [NSString stringWithFormat:@"时间：%@",[time substringToIndex:4]];
    }else{
        self.videoTimeLab.hidden = YES;
    }
    
}
@end
