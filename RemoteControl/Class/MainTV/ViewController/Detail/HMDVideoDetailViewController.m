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
#import "UIImage+Color.h"
@interface HMDVideoDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) HMDVideoDataDao *videoDao;

@property (weak, nonatomic) IBOutlet UIImageView *videoShowImageView;                   //视频图片
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UILabel *videoTitleLab;//标题

@property (weak, nonatomic) IBOutlet UILabel *videoLocationLab;//分类地区
@property (weak, nonatomic) IBOutlet UILabel *videoActorLab;//主演
//5课星
@property (weak, nonatomic) IBOutlet UIImageView *star1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *star2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *star3ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *star4ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *star5ImageView;

@property (weak, nonatomic) IBOutlet UILabel *scoreLab;//分数

@property (weak, nonatomic) IBOutlet UIView *episodeView;//剧集
@property (weak, nonatomic) IBOutlet UICollectionView *episodeCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *summaryTopConstraint;//有剧集的时候是129,没有的时候是14

@property (weak, nonatomic) IBOutlet UITextView *summaryContentTextView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;        //渐变效果

@end

@implementation HMDVideoDetailViewController
static NSString * const reuseIdentifier = @"HMDEpisodeCollectionViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [HMDLinkView sharedInstance].hidden = NO;
//    self.navigationController.navigationBar.translucent = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [HMDLinkView sharedInstance].hidden = YES;
//    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.bottomView];
}
#pragma mark - 初始化
-(void)setupUI{
    //增加渐变层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, HMDScreenW, 25);
    gradientLayer.colors = @[(id)HMDColor(240, 240, 240, 0).CGColor,(id)HMDColor(240, 240, 240, 1).CGColor];  // 设置渐变颜色
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    [self.bottomView.layer addSublayer:gradientLayer];
    
    [self reSetupNavBarWithWhiteItem];
    [self setupEpisode];
    [self setupNavigation];
    [self setupVideoDetail];
}

-(void)setupEpisode{
    if (1) {
        self.episodeView.hidden = YES;
        self.summaryTopConstraint.constant = 14;
    }else{
        self.episodeCollectionView.delegate = self;
        self.episodeCollectionView.dataSource = self;
        [self.episodeCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HMDEpisodeCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];

    }
}

-(void)setupNavigation{
    [self.navigationController.navigationBar
     setBackgroundImage:[UIImage imageFromContextWithColor:[UIColor colorWithRed:38/255.0 green:137/255.0 blue:247/255.0 alpha:0]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar
     setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
}

-(void)setupVideoDetail{
//    self.videoShowImageView;
    self.videoTitleLab.text = self.videoModel.title;
    self.videoActorLab.text = self.videoModel.t_actor;
    NSString *country = self.videoModel.country;
    NSString *year = self.videoModel.t_year;
    NSString *genre = self.videoModel.genre;
    NSString *locationText;
    locationText = [self appendingString:country targetString:locationText];
    locationText = [self appendingString:year targetString:locationText];
    locationText = [self appendingString:genre targetString:locationText];
    self.videoLocationLab.text = locationText;
    self.summaryContentTextView.text = self.videoModel.t_plot;
    
    CGFloat rating = [self.videoModel.rating floatValue];
    self.scoreLab.text = self.videoModel.rating;
    [self setupSroceView:rating];
}

-(void)setupSroceView:(CGFloat)sroce{
    if (sroce<=0) {
        self.scoreLab.hidden = YES;
        self.star1ImageView.hidden = YES;
        self.star2ImageView.hidden = YES;
        self.star3ImageView.hidden = YES;
        self.star4ImageView.hidden = YES;
        self.star5ImageView.hidden = YES;
    }else{
        NSArray *starImageVArray = @[self.star1ImageView,self.star2ImageView,self.star3ImageView,self.star4ImageView,self.star5ImageView];
        for (int i = 0; i < starImageVArray.count; i++) {
            UIImageView *starImageView = starImageVArray[i];
            NSInteger tag = starImageView.tag-100;
            CGFloat sroce_D = sroce - 2*tag;
            if (sroce_D >=0) {
                [starImageView setImage:[UIImage imageNamed:@"star_full"]];
            }else if (sroce_D >-2){
                [starImageView setImage:[UIImage imageNamed:@"star_half"]];
            }else{
                break;
            }
        }
    }
}

-(NSString *)appendingString:(NSString *)string targetString:(NSString *)targetString{
    NSString *resultString;
    if (targetString.length>=1) {
        resultString = targetString;
        if (string.length>=1) {
            resultString = [resultString stringByAppendingString:@"·"];
            resultString = [resultString stringByAppendingString:string];
        }
    }else{
        if (string.length>=1) {
            resultString = string;
        }
    }
    return resultString;
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

#pragma mark - 懒加载
-(HMDVideoDataDao *)videoDao{
    if (_videoDao == nil) {
        _videoDao = [[HMDVideoDataDao alloc] init];
    }
    return _videoDao;
}
@end

