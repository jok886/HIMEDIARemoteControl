//
//  HMDSearchTVResultCollectionView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/11.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDSearchTVResultCollectionView.h"
#import "HMDSearchTVResultCell.h"

@interface HMDSearchTVResultCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
@implementation HMDSearchTVResultCollectionView
static NSString * const reuseIdentifier = @"HMDSearchTVResultCell";
+(instancetype)searchTVResultCollectionViewWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(100, 160);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    HMDSearchTVResultCollectionView *resultCollectionView = [[HMDSearchTVResultCollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
    resultCollectionView.delegate = resultCollectionView;
    resultCollectionView.dataSource = resultCollectionView;

    //注册Item
    [resultCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HMDSearchTVResultCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    return resultCollectionView;
}
-(void)awakeFromNib{
    [super awakeFromNib];

    self.delegate = self;
    self.dataSource = self;
    //注册Item
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([HMDSearchTVResultCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.tvModelArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(100, 160);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HMDSearchTVResultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    HMDVideoModel *tvModel = self.tvModelArray[indexPath.row];
    [cell setupCellWithVideoModel:tvModel];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(searchTVResultCollectionView:didSelectItemWithModel:)]){
        HMDVideoModel *tvModel = self.tvModelArray[indexPath.row];
        [self.searchDelegate searchTVResultCollectionView:self didSelectItemWithModel:tvModel];
    }
}

#pragma mark - 懒加载
-(NSMutableArray *)tvModelArray{
    if (_tvModelArray == nil) {
        _tvModelArray = [NSMutableArray array];
    }
    return _tvModelArray;
}
@end
