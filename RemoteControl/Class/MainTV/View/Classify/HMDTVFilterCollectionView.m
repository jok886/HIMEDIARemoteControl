//
//  HMDTVFilterCollectionView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/27.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDTVFilterCollectionView.h"
#import "HMDTVFilterCollectionViewCell.h"
@interface HMDTVFilterCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end
@implementation HMDTVFilterCollectionView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.dataSource = self;
    self.delegate = self;
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([HMDTVFilterCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:self.restorationIdentifier];
    
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HMDTVFilterCollectionViewCell *videoShowCell = [collectionView dequeueReusableCellWithReuseIdentifier:self.restorationIdentifier forIndexPath:indexPath];
    videoShowCell.backgroundColor = HMDRandomColor;
    return videoShowCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
