//
//  HMDPhotoBrowseViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/6/1.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDPhotoBrowseViewController.h"
#import "HMDPhotoBrowserCollectionViewCell.h"
@interface HMDPhotoBrowseViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *photoBrowseCollectionView;

@end

@implementation HMDPhotoBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.photoBrowseCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HMDPhotoBrowserCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:self.photoBrowseCollectionView.restorationIdentifier];
    self.photoBrowseCollectionView.maximumZoomScale = 3.0;
    self.photoBrowseCollectionView.minimumZoomScale = 0.5;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    HMDPhotoBrowserCollectionViewCell *cell = (HMDPhotoBrowserCollectionViewCell *)[self.photoBrowseCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cell.photoImageView;
}

#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(HMDScreenW , CGRectGetHeight(self.photoBrowseCollectionView.bounds));
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HMDPhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.photoBrowseCollectionView.restorationIdentifier forIndexPath:indexPath];
    NSString *filePath = self.photoArray[indexPath.row];
    cell.photoImageView.image = [UIImage imageWithContentsOfFile:filePath];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

//    [collectionView setContentOffset:CGPointMake(collectionView.contentOffset.x+50, 0) animated:YES];
}
#pragma mark - 懒加载
- (NSArray *)photoArray{
    if (_photoArray == nil) {
        _photoArray = [NSArray array];
    }
    return _photoArray;
}
@end
