//
//  HMDSearchTVTipsCollectionView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/11.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDSearchTVTipsCollectionView.h"

#import "HMDSearchTipCollectionViewCell.h"
#import "HMDSearchHistoryCollectionViewCell.h"
#import "HMDHotTipCollectionViewCell.h"

#import "HMDSearchTipHeadView.h"
#import "NSString+HMDExtend.h"
@interface HMDSearchTVTipsCollectionView()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
HMDSearchTipCollectionViewCellDelegate,
HMDSearchTipHeadViewDelegate>

@end

@implementation HMDSearchTVTipsCollectionView
static NSString * const reuseIdentifierCell = @"HMDSearchTipCollectionViewCell";
static NSString * const reuseIdentifierCell_History = @"HMDSearchHistoryCollectionViewCell";
static NSString * const reuseIdentifierCell_Hot = @"HMDHotTipCollectionViewCell";
static NSString * const reuseIdentifierHead = @"HMDSearchTipHeadView";

-(void)awakeFromNib{
    [super awakeFromNib];
    self.delegate = self;
    self.dataSource = self;
    
    //注册Item
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([HMDSearchTipCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifierCell];
    //历史记录
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([HMDSearchHistoryCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifierCell_History];
    //热门
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([HMDHotTipCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifierCell_Hot];
    //注册头尾视图
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([HMDSearchTipHeadView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHead];
}
#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (self.searchTVTipsType == HMDSearchTVRecommendTipsType) {
        return self.recommendArray.count;
    }else{
        if (section==0) {
            return self.recordArray.count;
        }else{
            return self.hotArray.count;
        }
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.searchTVTipsType == HMDSearchTVRecommendTipsType) {
        return 1;
    }else{
        return 2;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect bounds = collectionView.bounds;
    if (self.searchTVTipsType == HMDSearchTVRecommendTipsType) {
        return CGSizeMake(CGRectGetWidth(bounds), 44);
    }else{
        return CGSizeMake((CGRectGetWidth(bounds)-10)*0.5, 35);
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGRect bounds = collectionView.bounds;
    if (self.searchTVTipsType == HMDSearchTVRecommendTipsType) {
        return CGSizeZero;
    }else{
        return CGSizeMake(CGRectGetWidth(bounds), 50);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (self.searchTVTipsType == HMDSearchTVRecommendTipsType) {
        return 0;
    }else{
        return 5;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchTVTipsType == HMDSearchTVRecommendTipsType) {
        HMDSearchHistoryCollectionViewCell *historyCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCell_History forIndexPath:indexPath];
        NSString *tip = self.recommendArray[indexPath.row];
        [historyCell setHistoryText:tip keyWord:self.curKeyWord];
        return historyCell;
    }else{

        if (indexPath.section == 0){
            HMDSearchTipCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCell forIndexPath:indexPath];
            NSString *tip = self.recordArray[indexPath.row];
            [cell setupCellWithTipSting:tip needCenter:YES deleteBtn:NO];

            return cell;
        }else{
            HMDHotTipCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCell_Hot forIndexPath:indexPath];
            NSString *tip = self.hotArray[indexPath.row];
            [cell setHotTipWithName:tip level:indexPath.row+1];
            return cell;
        }

        
    }

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSString *tip;
    if (self.searchTVTipsType == HMDSearchTVRecommendTipsType) {
        tip = self.recommendArray[indexPath.row];
    }else{
        if (indexPath.section == 0){
            tip = self.recordArray[indexPath.row];
        }else{
            tip = self.hotArray[indexPath.row];
        }
    }
    
    if (self.searchTVTipBlock) {
        self.searchTVTipBlock(tip);
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HMDSearchTipHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHead forIndexPath:indexPath];
        headerView.delegate = self;
        if (self.searchTVTipsType == HMDSearchTVRecommendTipsType) {
            headerView.hidden = YES;
            return headerView;
        }else{
            headerView.hidden = NO;
            if (indexPath.section == 0){
                headerView.searchTipStyle = HMDSearchTipRecord;
            }else{
                headerView.searchTipStyle = HMDSearchTipHot;
            }
        }
        return headerView;
    }else{
        return  nil;
    }
}

#pragma mark - HMDSearchTipCollectionViewCellDelegate/HMDSearchTipHeadViewDelegate
-(void)searchTipCollectionViewCellDeleteAtIndexPath:(NSIndexPath *)indexPath{
//    [self.recordArray removeObjectAtIndex:indexPath.row];
//    [[NSUserDefaults standardUserDefaults] setObject:self.recordArray forKey:HMDSearchWordHistory];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)searchTipHeadView:(HMDSearchTipHeadView *)searchTipHeadView clickBtnClick:(UIButton *)btn{
    self.recordArray = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:HMDSearchWordHistory];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self reloadData];
}
#pragma mark - 其他
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    if (self.scrollViewWillBeginDraggingBlock) {
//        self.scrollViewWillBeginDraggingBlock();
//    }
//}

#pragma mark - 懒加载
-(NSMutableArray *)recordArray{
    if (_recordArray == nil) {
        _recordArray = [NSMutableArray array];
    }
    return _recordArray;
}

-(NSArray *)hotArray{
    if (_hotArray == nil) {
        _hotArray = [NSArray array];
    }
    return _hotArray;
}

-(NSArray *)recommendArray{
    if (_recommendArray == nil) {
        _recommendArray = [NSArray array];
    }
    return _recommendArray;
}
@end
