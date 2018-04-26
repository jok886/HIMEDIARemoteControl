//
//  HMDVideoDetailViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/26.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDVideoDetailViewController.h"
#import "HMDVideoDataDao.h"
#import "HMDEpisodeCollectionViewCell.h"
@interface HMDVideoDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) HMDVideoDataDao *videoDao;
@property (weak, nonatomic) IBOutlet UICollectionView *episodeCollectionView;

@end

@implementation HMDVideoDetailViewController
static NSString * const reuseIdentifier = @"HMDEpisodeCollectionViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.episodeCollectionView.delegate = self;
    self.episodeCollectionView.dataSource = self;
    [self.episodeCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HMDEpisodeCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HMDEpisodeCollectionViewCell *videoShowCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    videoShowCell.backgroundColor = HMDRandomColor;
    return videoShowCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}


#pragma mark - 点击

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 懒加载
-(HMDVideoDataDao *)videoDao{
    if (_videoDao == nil) {
        _videoDao = [[HMDVideoDataDao alloc] init];
    }
    return _videoDao;
}
@end

