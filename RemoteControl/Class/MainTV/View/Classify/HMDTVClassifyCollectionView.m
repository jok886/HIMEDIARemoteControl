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
@interface HMDTVClassifyCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
@implementation HMDTVClassifyCollectionView

-(void)awakeFromNib{
    [super awakeFromNib];
//    HMDWaterflowLayout *flowLayout = [[HMDWaterflowLayout alloc]init];
//    flowLayout.flowLayoutStyle = HMDHorizontalWaterFlow;
//    flowLayout.delegate = self;
//    self.collectionViewLayout = flowLayout;
    self.dataSource = self;
    self.delegate = self;
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([HMDTVClassifyCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:self.restorationIdentifier];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.classifyArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
        HMDTVClassifyModel *classifyModel = self.classifyArray[indexPath.row];
        NSString *title = classifyModel.title;
        CGFloat width = [title calculateRowWidthWithHight:34 fontSize:13]+20;
    
        return CGSizeMake(width, 34);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HMDTVClassifyCollectionViewCell *videoShowCell = [collectionView dequeueReusableCellWithReuseIdentifier:self.restorationIdentifier forIndexPath:indexPath];
    HMDTVClassifyModel *classifyModel = self.classifyArray[indexPath.row];
    BOOL select = NO;
    if (self.curIndexPath && self.curIndexPath == indexPath) {
        select = YES;
    }
    [videoShowCell setupCellWithName:classifyModel.title selected:select];
    return videoShowCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *reloadArray = [NSMutableArray array];
    HMDTVClassifyModel *classifyModel = self.classifyArray[indexPath.row];
    NSString *classifyName = classifyModel.flag;
    if (self.curIndexPath) {
        if (self.curIndexPath == indexPath) {
            //同一个取消选中
            self.curIndexPath = nil;
            classifyName = nil;
            [reloadArray addObject:indexPath];
        }else{
            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForItem:self.curIndexPath.item inSection:self.curIndexPath.section];
            self.curIndexPath = indexPath;
            [reloadArray addObject:oldIndexPath];
            [reloadArray addObject:indexPath];
        }
    }else{
        self.curIndexPath = indexPath;
        [reloadArray addObject:indexPath];
    }
    [UIView performWithoutAnimation:^{
        [collectionView reloadItemsAtIndexPaths:reloadArray];
    }];
    if (self.selectClassifyBlock) {
        BOOL videoType = NO;
        if ([classifyModel.type integerValue] == 1) {
            videoType = 1;
        }
        self.selectClassifyBlock(classifyName,videoType);
    }
}

@end
