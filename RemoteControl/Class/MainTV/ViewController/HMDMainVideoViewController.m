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
#import "HMDVideoDetailViewController.h"
#import "HMDFavoriteVideoViewController.h"
#import "HMDTVRemoteViewController.h"
@interface HMDMainVideoViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic,weak) UICollectionView *videoShowCollectionView;           //主界面
@property (nonatomic,strong) NSMutableArray *videoDataArray;                    //视频数据
@property (nonatomic) CGRect videoShowCollectionViewFrame;                      //主界面frame
@property (nonatomic,strong) HMDVideoDataDao *videoDataDao;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;                //主界面图片
@property (nonatomic,strong) HMDVideoModel *curVideoModel;                      //当前的video
@property (weak, nonatomic) IBOutlet HMDMainLoadingView *loadingView;
@property (weak, nonatomic) IBOutlet UIView *imageCoverView;

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
    
    
    //增加渐变层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.imageCoverView.bounds;
    gradientLayer.colors = @[(id)HMDColor(0, 0, 0, 0.5).CGColor,(id)HMDColor(0, 0, 0, 0.8).CGColor];  // 设置渐变颜色
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    [self.imageCoverView.layer addSublayer:gradientLayer];
}

-(void)getRecommendVideoData{
    HMDWeakSelf(self)
                [self.loadingView startLoading];
    [self.videoDataDao getRecommendVideoDataFinish:^(BOOL success, NSArray *modelArray) {
        [weakSelf.loadingView endLoading];
        if (success && modelArray.count > 0) {
            HMDVideoModel *videoModel = [weakSelf.videoDataArray firstObject];
            weakSelf.curVideoModel = videoModel;
            [weakSelf setMainImageViewImageWithVideoModel:videoModel];
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
    HMDVideoDetailViewController *detailVC = [[HMDVideoDetailViewController alloc] init];
    detailVC.videoModel = videoModel;
    detailVC.netPoster = YES;
    [self.view.getCurActiveViewController presentViewController:detailVC animated:YES completion:nil];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    CGFloat offsetX = self.videoShowCollectionView.contentOffset.x;
    [self scrollViewDidEndWithOffset:offsetX];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = self.videoShowCollectionView.contentOffset.x;
    [self scrollViewDidEndWithOffset:offsetX];
}

#pragma mark - 其他
//滚动停止
-(void)scrollViewDidEndWithOffset:(CGFloat)offset{
    NSInteger index = offset/(HMDScreenW-80);
    if (index >=0 &&index<self.videoDataArray.count) {
        HMDVideoModel *videoModel = self.videoDataArray[index];
        [self setMainImageViewImageWithVideoModel:videoModel];
        self.curVideoModel = videoModel;
    }
}
-(void)setMainImageViewImageWithVideoModel:(HMDVideoModel *)VideoModel{
    [self.mainImageView setImageWithURLStr:VideoModel.img_url_vertical placeholderImage:[UIImage imageNamed:@"video_banner_default_l"]];
}
#pragma mark - 点击
//播放历史
- (IBAction)historyBtnClick:(id)sender {
    //判断当前是否链接
    if ([HMDLinkView sharedInstance].linkViewState == HMDLinkViewStateLinked) {
        [HMDLinkView sharedInstance].hidden = YES;
        HMDPlayHistoryViewController *playHistoryVC = [[HMDPlayHistoryViewController alloc] init];
        HMDNavigationController *nav = [[HMDNavigationController alloc] initWithRootViewController:playHistoryVC];
        [self.view.getCurActiveViewController presentViewController:nav animated:YES completion:nil];
    }else{
        [HMDProgressHub showMessage:@"请先链接设备" hideAfter:2.0];
    }

}
//分类
- (IBAction)classificationBtnClick:(id)sender {
    //判断当前是否链接
    if ([HMDLinkView sharedInstance].linkViewState == HMDLinkViewStateLinked) {
        [HMDLinkView sharedInstance].hidden = YES;
        HMDAllVideoViewController *allVideoVC = [[HMDAllVideoViewController alloc] init];
        HMDNavigationController *nav = [[HMDNavigationController alloc] initWithRootViewController:allVideoVC];
        [self.view.getCurActiveViewController presentViewController:nav animated:YES completion:nil];
    }else{
        [HMDProgressHub showMessage:@"请先链接设备" hideAfter:2.0];
    }

}
//收藏
- (IBAction)favoriteBtnClick:(id)sender {
    //判断当前是否链接
    if ([HMDLinkView sharedInstance].linkViewState == HMDLinkViewStateLinked) {
        [HMDLinkView sharedInstance].hidden = YES;
        HMDFavoriteVideoViewController *favoriteVideoViewController = [[HMDFavoriteVideoViewController alloc] init];
        HMDNavigationController *nav = [[HMDNavigationController alloc] initWithRootViewController:favoriteVideoViewController];
        [self.view.getCurActiveViewController presentViewController:nav animated:YES completion:nil];
    }else{
        [HMDProgressHub showMessage:@"请先链接设备" hideAfter:2.0];
    }

}

//播放当前视频
- (IBAction)playCurVideo:(id)sender {
    //判断当前是否链接
    if ([HMDLinkView sharedInstance].linkViewState == HMDLinkViewStateLinked) {
        if (self.curVideoModel) {
            HMDWeakSelf(self)
            [self.videoDataDao PostPlayNetPosterOrder:self.curVideoModel finishBlock:^(BOOL success) {
                if (success) {
                    [HMDLinkView sharedInstance].hidden = YES;
                    HMDTVRemoteViewController *remoteViewController = [[HMDTVRemoteViewController alloc] init];
                    remoteViewController.showLinkViewWhenDismiss = YES;
//                    remoteViewController.powerOffBlock = ^{
//                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
//                    };
                    HMDNavigationController *nav = [[HMDNavigationController alloc] initWithRootViewController:remoteViewController];
                    [weakSelf.view.getCurActiveViewController presentViewController:nav animated:YES completion:nil];
                }

            }];
        }
    }else{
        [HMDProgressHub showMessage:@"请先链接设备" hideAfter:2.0];
    }

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
