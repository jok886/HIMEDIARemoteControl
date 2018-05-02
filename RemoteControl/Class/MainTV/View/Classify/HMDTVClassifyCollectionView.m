//
//  HMDTVClassifyCollectionView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/27.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDTVClassifyCollectionView.h"
#import "HMDTVClassifyCollectionViewCell.h"
#import "HMDWaterflowLayout.h"
#import "NSString+HMDExtend.h"
#import "HMDTVClassifyModel.h"
@interface HMDTVClassifyCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource,HMDWaterflowLayoutDelegate>

@end
@implementation HMDTVClassifyCollectionView

-(void)awakeFromNib{
    [super awakeFromNib];
    HMDWaterflowLayout *flowLayout = [[HMDWaterflowLayout alloc]init];
    flowLayout.flowLayoutStyle = HMDHorizontalWaterFlow;
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.delegate = self;
    self.collectionViewLayout = flowLayout;
    self.dataSource = self;
    self.delegate = self;
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([HMDTVClassifyCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:self.restorationIdentifier];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.classifyArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HMDTVClassifyCollectionViewCell *videoShowCell = [collectionView dequeueReusableCellWithReuseIdentifier:self.restorationIdentifier forIndexPath:indexPath];
    HMDTVClassifyModel *classifyModel = self.classifyArray[indexPath.row];
    [videoShowCell setupCellWithName:classifyModel.title selected:YES];
    videoShowCell.backgroundColor = HMDRandomColor;
    return videoShowCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - HMDWaterflowLayoutDelegate

/** 水平瀑布流 item等高不等宽 */
-(CGFloat)waterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout widthForItemAtIndexPath:(NSIndexPath *)indexPath itemHeight:(CGFloat)itemHeight{

    HMDTVClassifyModel *classifyModel = self.classifyArray[indexPath.row];
    NSString *title = classifyModel.title;
    CGFloat width = [title calculateRowWidthWithHight:40 fontSize:17]+20;
    
    return width;
    
}

/** itemSize */
-(CGSize)waterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(30, 40);
}
-(CGFloat)rowCountInWaterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout{
    return 1;
}
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
@end