//
//  HMDMainVideoViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/18.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDMainVideoViewController.h"
#import "HMDLineFlowLayout.h"
#import "HMDVideoShowCollectionViewCell.h"

#import "HMDVideoDataDao.h"
@interface HMDMainVideoViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic,weak) UICollectionView *videoShowCollectionView;           //主界面
@property (nonatomic,strong) NSMutableArray *videoDataArray;                    //视频数据
@property (nonatomic) CGRect videoShowCollectionViewFrame;                      //主界面frame
@property (nonatomic,strong) HMDVideoDataDao *videoDataDao;
@end

@implementation HMDMainVideoViewController
static NSString * const reuseIdentifier = @"HMDVideoShowCollectionViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getRecommendVideoData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.videoShowCollectionView.frame = self.videoShowCollectionViewFrame;
}

#pragma mark - 初始化
-(void)setupUI{
    CGFloat Spacing =40;
    CGFloat width = HMDScreenW- 2*Spacing ;
    HMDLineFlowLayout *layout = [[HMDLineFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(width, width);
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    layout.minimumLineSpacing = 0;
//    layout.minimumInteritemSpacing = 20;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.videoShowCollectionViewFrame = CGRectMake(0, HMDScreenH-(width+HMDSTATUSBARMAXY+65+LINKVIEHIGHT)-10, HMDScreenW, width);
    UICollectionView *videoShowCollectionView = [[UICollectionView alloc]initWithFrame:self.videoShowCollectionViewFrame collectionViewLayout:layout];
    [videoShowCollectionView registerNib:[UINib nibWithNibName:@"HMDVideoShowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    videoShowCollectionView.showsHorizontalScrollIndicator = NO;

    videoShowCollectionView.delegate = self;
    videoShowCollectionView.dataSource = self;
    self.videoShowCollectionView = videoShowCollectionView;
    [self.view addSubview:videoShowCollectionView];
}

-(void)getRecommendVideoData{
    HMDWeakSelf(self)
    [self.videoDataDao getRecommendVideoDataFinish:^(BOOL success, NSArray *modelArray) {
        weakSelf.videoDataArray = [NSMutableArray arrayWithArray:modelArray];
        [weakSelf.videoShowCollectionView reloadData];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.videoDataArray.count == 0) {
        [self getRecommendVideoData];
    }
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.videoDataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        HMDVideoShowCollectionViewCell *videoShowCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    HMDVideoModel *videoModel = self.videoDataArray[indexPath.row];
    
    [videoShowCell setupCellWithVideoModel:videoModel];
    return videoShowCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HMDVideoModel *videoModel = self.videoDataArray[indexPath.row];
    [self.videoDataDao PostPlayNetPosterOrder:videoModel finishBlock:nil];
}
#pragma mark - 懒加载
-(NSMutableArray *)videoDataArray{
    if (_videoDataArray == nil) {
        _videoDataArray = [NSMutableArray array];
        
    }
    return _videoDataArray;
}

-(HMDVideoDataDao *)videoDataDao{
    if (_videoDataDao == nil) {
        _videoDataDao = [[HMDVideoDataDao alloc]init];
    }
    return _videoDataDao;
}
@end
