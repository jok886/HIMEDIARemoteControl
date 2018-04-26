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
#import "NSString+HMDExtend.h"
@interface HMDSearchTVTipsCollectionView()
<UICollectionViewDelegate,
UICollectionViewDataSource,
HMDWaterflowLayoutDelegate,
HMDSearchTipCollectionViewCellDelegate>

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
    switch (self.searchTVTipsType) {
        case HMDSearchTVHotTipsType:
        {
             return self.hotArray.count;
        }
        break;
        case HMDSearchTVRecordTipsType:
        {
            return self.recordArray.count;
        }
        break;
        case HMDSearchTVRecommendTipsType:
        {
            return self.recommendArray.count;
        }
        break;
        case HMDSearchTVRecordAndHotTipsType:
        {
            if (section==0) {
                return self.recordArray.count;
            }else{
                return self.hotArray.count;
            }
        }
        break;
        default:
        return 0;
        break;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    switch (self.searchTVTipsType) {
        case HMDSearchTVHotTipsType:
        case HMDSearchTVRecordTipsType:
        case HMDSearchTVRecommendTipsType:
        return 1;
        break;
        default:
        return 2;
        break;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HMDSearchTipCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCell forIndexPath:indexPath];
    NSString *tip;
    BOOL needCenter = YES;
    BOOL deleteBtn = NO;
    switch (self.searchTVTipsType) {
        case HMDSearchTVHotTipsType:
        tip = self.hotArray[indexPath.row];
        break;
        case HMDSearchTVRecordTipsType:
        tip = self.recordArray[indexPath.row];
        break;
        case HMDSearchTVRecordAndHotTipsType:
        {
            if (indexPath.section == 0){
                tip = self.recordArray[indexPath.row];
            }else{
                tip = self.hotArray[indexPath.row];
            }
        }
        break;
        case HMDSearchTVRecommendTipsType:
        {
            needCenter = NO;
            deleteBtn = YES;
            tip = self.recommendArray[indexPath.row];
        }
        break;
        default:
        break;
    }
    cell.delegate = self;
    [cell setupCellWithTipSting:tip needCenter:needCenter deleteBtn:deleteBtn];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

        NSString *tip;
        switch (self.searchTVTipsType) {
            case HMDSearchTVHotTipsType:
            tip = self.hotArray[indexPath.row];
            break;
            case HMDSearchTVRecordTipsType:
            tip = self.recordArray[indexPath.row];
            break;
            case HMDSearchTVRecordAndHotTipsType:
            {
                if (indexPath.section == 0){
                    tip = self.recordArray[indexPath.row];
                }else{
                    tip = self.hotArray[indexPath.row];
                }
            }
            break;
            case HMDSearchTVRecommendTipsType:
            {
                tip = self.recommendArray[indexPath.row];
            }
            break;
            default:
            break;
        }
        if (self.searchTVTipBlock) {
            self.searchTVTipBlock(tip);
        }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
    HMDSearchTipHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHead forIndexPath:indexPath];
            headerView.hidden = NO;
            switch (self.searchTVTipsType) {
                case HMDSearchTVHotTipsType:
                headerView.searchTipStyle = HMDSearchTipHot;
                break;
                case HMDSearchTVRecordTipsType:
                headerView.searchTipStyle = HMDSearchTipRecord;
                break;
                case HMDSearchTVRecordAndHotTipsType:
                {
                    if (indexPath.section == 0){
                        headerView.searchTipStyle = HMDSearchTipRecord;
                    }else{
                       headerView.searchTipStyle = HMDSearchTipHot;
                    }
                }
                break;
                default:
                {
                    headerView.hidden = YES;
                    return headerView;
                }

                break;
            }
            return headerView;
    
        }else{
            return  nil;
        }
}
#pragma mark - HMDWaterflowLayoutDelegate

/** 水平瀑布流 item等高不等宽 */
-(CGFloat)waterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout widthForItemAtIndexPath:(NSIndexPath *)indexPath itemHeight:(CGFloat)itemHeight{
    if (self.searchTVTipsType == HMDSearchTVRecommendTipsType){
        return self.frame.size.width -20;
    }else{
        NSString *tip;
        switch (self.searchTVTipsType) {
            case HMDSearchTVHotTipsType:
            tip = self.hotArray[indexPath.row];
            break;
            case HMDSearchTVRecordTipsType:
            tip = self.recordArray[indexPath.row];
            break;
            case HMDSearchTVRecordAndHotTipsType:
            {
                if (indexPath.section == 0){
                    tip = self.recordArray[indexPath.row];
                }else{
                    tip = self.hotArray[indexPath.row];
                }
            }
            break;
            
            default:
            break;
        }
        CGFloat width = [tip calculateRowWidthWithHight:40 fontSize:15]+20;

        return width;
    }
}
/** itemSize */
-(CGSize)waterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(30, 40);
}
/** 头视图Size */
-(CGSize )waterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    CGFloat height = 40;
    if (self.searchTVTipsType == HMDSearchTVRecommendTipsType) {
        height = 0.1;
    }
    return CGSizeMake(HMDScreenW-20, height);
}
/** 脚视图Size */
//-(CGSize )waterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section{
//    return CGSizeMake(0, 0);
//}
#pragma mark - HMDSearchTipCollectionViewCellDelegate
-(void)searchTipCollectionViewCellDeleteAtIndexPath:(NSIndexPath *)indexPath{
//    [self.recordArray removeObjectAtIndex:indexPath.row];
//    [[NSUserDefaults standardUserDefaults] setObject:self.recordArray forKey:HMDSearchWordHistory];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
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
