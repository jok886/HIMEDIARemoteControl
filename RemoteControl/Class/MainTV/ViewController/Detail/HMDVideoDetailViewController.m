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
#import "UIImageView+HMDDLANLoadImage.h"

#import "HMDTVRemoteViewController.h"
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet UITextView *summaryContentTextView;
//@property (weak, nonatomic) IBOutlet UIView *bottomView;        //渐变效果
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIView *videoCoverView;
@property (weak, nonatomic) IBOutlet UIView *buttomView;

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
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!self.netPoster) {
        [HMDLinkView sharedInstance].hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    [self.view bringSubviewToFront:self.bottomView];
}
#pragma mark - 初始化
-(void)setupUI{
    //增加渐变层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, HMDScreenW, HMDScreenW*235/365.0);
    gradientLayer.colors = @[(id)HMDColor(0, 0, 0, 0.6).CGColor,(id)HMDColor(0, 0, 0, 0).CGColor];  // 设置渐变颜色
    gradientLayer.locations = @[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0.5, 0.0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    [self.videoCoverView.layer addSublayer:gradientLayer];
    
    //增加渐变层
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.frame = CGRectMake(0, 0, HMDScreenW, 25);
    gradientLayer2.colors = @[(id)HMDColor(240, 240, 240, 0).CGColor,(id)HMDColor(240, 240, 240, 1).CGColor];  // 设置渐变颜色
    gradientLayer2.startPoint = CGPointMake(0.5, 0);
    gradientLayer2.endPoint = CGPointMake(0.5, 1);
    [self.buttomView.layer addSublayer:gradientLayer2];
    
    if (self.pushModel) {
        [self reSetupNavBarWithWhiteItem];
        [self setupNavigation];
        self.backBtn.hidden = YES;
        self.topConstraint.constant = -44;
    }
    self.summaryContentTextView.editable = NO;
    [self setupEpisode];
    [self setupVideoDetail];
}

-(void)setupEpisode{

    self.episodeView.hidden = YES;
    if (self.netPoster) {
        self.summaryTopConstraint.constant = -14;
    }else{
        self.summaryTopConstraint.constant = 14;
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
    if (self.netPoster) {
        [self.videoShowImageView setImageWithURLStr:self.videoModel.img_url placeholderImage:nil];
        self.videoTitleLab.text = self.videoModel.title;
        self.summaryContentTextView.text = self.videoModel.info;
        [self setupSroceView:0];
        self.videoActorLab.hidden = YES;
        self.videoLocationLab.hidden = YES;
    }else{
        NSString *url = [NSString stringWithFormat:HMD_DLAN_VIDEO_GET_POSTERIMAGE,HMDCURLINKDEVICEIP];
        NSString *imageName = self.videoModel.fanartPicString.length>=1?self.videoModel.fanartPicString:self.videoModel.posterPicString;
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:imageName,@"posterPicString", nil];
        [self.videoShowImageView setDLANImageWithMethod:@"POST" URLStr:url parameters:parameters placeholderImage:nil];
        self.videoTitleLab.text = self.videoModel.name;
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
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HMDEpisodeCollectionViewCell *videoShowCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    return videoShowCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}


#pragma mark - 点击

- (IBAction)playCurVideo:(id)sender {
    //判断当前是否链接
    if ([HMDLinkView sharedInstance].linkViewState == HMDLinkViewStateLinked) {
        HMDWeakSelf(self)
        if (self.netPoster) {
            [self.videoDao PostPlayNetPosterOrder:self.videoModel finishBlock:^(BOOL success) {
                if (success) {
                    HMDTVRemoteViewController *remoteViewController = [[HMDTVRemoteViewController alloc] init];
                    remoteViewController.pushVC = YES;
                    [weakSelf.navigationController pushViewController:remoteViewController animated:YES];
                }
            }];
        }else{
            [self.videoDao PostPlayDLanPosterOrder:self.videoModel finishBlock:^(BOOL success) {
                if (success) {
                    HMDTVRemoteViewController *remoteViewController = [[HMDTVRemoteViewController alloc] init];
                    remoteViewController.pushVC = YES;
                    [weakSelf.navigationController pushViewController:remoteViewController animated:YES];
                }
            }];
        }
    }else{
        [HMDProgressHub showMessage:@"请先链接设备" hideAfter:2.0];
    }


}
- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.netPoster) {
            [HMDLinkView sharedInstance].hidden = NO;
        }else{
            [HMDLinkView sharedInstance].hidden = YES;
        }
        
    }];
}


#pragma mark - 懒加载
-(HMDVideoDataDao *)videoDao{
    if (_videoDao == nil) {
        _videoDao = [[HMDVideoDataDao alloc] init];
    }
    return _videoDao;
}
@end

