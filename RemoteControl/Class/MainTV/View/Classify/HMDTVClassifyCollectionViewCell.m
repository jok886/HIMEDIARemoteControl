//
//  HMDTVClassifyCollectionViewCell.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/27.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDTVClassifyCollectionViewCell.h"
#import "HMDCoverView.h"
@interface HMDTVClassifyCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet HMDCoverView *coverView;

@end
@implementation HMDTVClassifyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}
-(void)setupCellWithName:(NSString *)name selected:(BOOL)selected{
    self.nameLab.text = name;
    self.coverView.hidden = !selected;
}


@end
