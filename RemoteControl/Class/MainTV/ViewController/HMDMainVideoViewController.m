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

#import "HMDPlayHistoryViewController.h"
#import "HMDAllVideoViewController.h"
#import "HMDNavigationController.h"
#import "HMDVideoDetailViewController.h"

@interface HMDMainVideoViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic,weak) UICollectionView *videoShowCollectionView;           //主界面
@property (nonatomic,strong) NSMutableArray *videoDataArray;                    //视频数据
@property (nonatomic) CGRect videoShowCollectionViewFrame;                      //主界面frame
@property (nonatomic,strong) HMDVideoDataDao *videoDataDao;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

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
    videoShowCollectionView.backgroundColor = [UIColor clearColor];
    videoShowCollectionView.delegate = self;
    videoShowCollectionView.dataSource = self;
    self.videoShowCollectionView = videoShowCollectionView;
    [self.view addSubview:videoShowCollectionView];
}

-(void)getRecommendVideoData{
    HMDWeakSelf(self)
    [self.videoDataDao getRecommendVideoDataFinish:^(BOOL success, NSArray *modelArray) {
        if (success && modelArray.count > 0) {
            HMDVideoModel *VideoModel = [weakSelf.videoDataArray firstObject];
            [weakSelf setMainImageViewImageWithVideoModel:VideoModel];
            weakSelf.videoDataArray = [NSMutableArray arrayWithArray:modelArray];
            [weakSelf.videoShowCollectionView reloadData];
        }

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
    //进入详情页
    [self.videoDataDao PostPlayNetPosterOrder:videoModel finishBlock:nil];
//    HMDVideoDetailViewController *detailVC = [[HMDVideoDetailViewController alloc] init];
//    detailVC.videoModel = videoModel;
//    [self.view.getCurActiveViewController presentViewController:detailVC animated:YES completion:nil];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    CGFloat offsetX = self.videoShowCollectionView.contentOffset.x;
    NSInteger index = offsetX/(HMDScreenW-80);
    if (index >0 &&index<self.videoDataArray.count) {
        HMDVideoModel *VideoModel = self.videoDataArray[index];
        [self setMainImageViewImageWithVideoModel:VideoModel];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = self.videoShowCollectionView.contentOffset.x;
    NSInteger index = offsetX/(HMDScreenW-80);
    NSLog(@"index:%ld  offset:%f",(long)index,offsetX);
    if (index >=0 &&index<self.videoDataArray.count) {
        HMDVideoModel *VideoModel = self.videoDataArray[index];
        [self setMainImageViewImageWithVideoModel:VideoModel];
    }

    
}

#pragma mark - 其他
-(void)setMainImageViewImageWithVideoModel:(HMDVideoModel *)VideoModel{
    [self.mainImageView setImageWithURLStr:VideoModel.img_url_vertical placeholderImage:nil];
}
#pragma mark - 点击
//播放历史
- (IBAction)historyBtnClick:(id)sender {
    HMDPlayHistoryViewController *playHistoryVC = [[HMDPlayHistoryViewController alloc] init];
    HMDNavigationController *nav = [[HMDNavigationController alloc] initWithRootViewController:playHistoryVC];
    [self.view.getCurActiveViewController presentViewController:nav animated:YES completion:nil];
}
//分类
- (IBAction)classificationBtnClick:(id)sender {
    HMDAllVideoViewController *allVideoVC = [[HMDAllVideoViewController alloc] init];
    HMDNavigationController *nav = [[HMDNavigationController alloc] initWithRootViewController:allVideoVC];
    [self.view.getCurActiveViewController presentViewController:nav animated:YES completion:nil];
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
