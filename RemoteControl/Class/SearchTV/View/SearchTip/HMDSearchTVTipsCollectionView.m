//
//  HMDSearchTVTipsCollectionView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/11.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDSearchTVTipsCollectionView.h"
#import "HMDWaterflowLayout.h"
#import "HMDSearchTipCollectionViewCell.h"
#import "HMDSearchTipHeadView.h"
@interface HMDSearchTVTipsCollectionView()
<UICollectionViewDelegate,
UICollectionViewDataSource,
HMDWaterflowLayoutDelegate>

@end

@implementation HMDSearchTVTipsCollectionView
static NSString * const reuseIdentifierCell = @"HMDSearchTipCollectionViewCell";
static NSString * const reuseIdentifierHead = @"HMDSearchTipHeadView";
+(instancetype)searchTVTipsCollectionViewWithFrame:(CGRect)frame{
    HMDWaterflowLayout *flowLayout = [[HMDWaterflowLayout alloc]init];
    flowLayout.flowLayoutStyle = HMDVHWaterFlow;
    HMDSearchTVTipsCollectionView *tipCollectionView = [[HMDSearchTVTipsCollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
    tipCollectionView.delegate = tipCollectionView;
    tipCollectionView.dataSource = tipCollectionView;
    flowLayout.delegate = tipCollectionView;
    //注册Item
    [tipCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HMDSearchTipCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifierCell];
    
    //注册头尾视图
    [tipCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HMDSearchTipHeadView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHead];
    
    return tipCollectionView;
}

#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HMDSearchTipCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCell forIndexPath:indexPath];
    cell.backgroundColor = HMDRandomColor;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
    HMDSearchTipHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHead forIndexPath:indexPath];
    if (indexPath.section == 1) {
        headerView.searchTipStyle = HMDSearchTipHot;
    }else{
        headerView.searchTipStyle = HMDSearchTipRecord;
    }
    return headerView;
    
        }else{
            return  nil;
        }
}
#pragma mark - HMDWaterflowLayoutDelegate

/** 水平瀑布流 item等高不等宽 */
-(CGFloat)waterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout widthForItemAtIndexPath:(NSIndexPath *)indexPath itemHeight:(CGFloat)itemHeight{
    
    return arc4random() % 200;
}
/** itemSize */
-(CGSize)waterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(30, 40);
}
/** 头视图Size */
-(CGSize )waterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    return CGSizeMake(HMDScreenW-20, 40);
}
/** 脚视图Size */
//-(CGSize )waterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section{
//    return CGSizeMake(0, 0);
//}
#pragma mark - 懒加载
-(NSMutableArray *)recordArray{
    if (_recordArray) {
        _recordArray = [NSMutableArray array];
    }
    return _recordArray;
}

-(NSMutableArray *)hotArray{
    if (_hotArray) {
        _hotArray = [NSMutableArray array];
    }
    return _hotArray;
}
@end
