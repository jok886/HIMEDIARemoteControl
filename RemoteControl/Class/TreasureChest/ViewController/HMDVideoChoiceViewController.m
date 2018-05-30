//
//  HMDVideoChoiceViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/29.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDVideoChoiceViewController.h"
#import "HMDLocationVideoCollectionViewCell.h"
#import "HMDLocationVideoModel.h"
#import <Photos/Photos.h>
@interface HMDVideoChoiceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *videoShowCollectionView;
@property (weak, nonatomic) IBOutlet HMDMainLoadingView *loadingView;
@property (nonatomic,strong) NSMutableArray *videoArray;
@end

@implementation HMDVideoChoiceViewController
- (IBAction)ac1:(id)sender {
    [[[HMDDHRCenter sharedInstance] DMRControl] renderPrevious];
}
- (IBAction)ac2:(id)sender {
    [[[HMDDHRCenter sharedInstance] DMRControl] renderNext];
}
- (IBAction)ac3:(id)sender {
    [[[HMDDHRCenter sharedInstance] DMRControl] getTransportInfo];
}
- (IBAction)ac4:(id)sender {
    [[[HMDDHRCenter sharedInstance] DMRControl] getCurrentTransportAction];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupFirstNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化
-(void)setupUI{
    [self.loadingView startLoading];
    [self.videoShowCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HMDLocationVideoCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:self.videoShowCollectionView.restorationIdentifier];
    self.title = @"视频";
    
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.videoArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (HMDScreenW -20 - 10)/2.0;
    return CGSizeMake(width, width/100.0*62);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5, 10, 10, 10);
    return edgeInsets;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HMDLocationVideoCollectionViewCell *showCell = [collectionView dequeueReusableCellWithReuseIdentifier:self.videoShowCollectionView.restorationIdentifier forIndexPath:indexPath];
    HMDLocationVideoModel *videoModel = self.videoArray[indexPath.row];
    [showCell setupCellWithLocationVideoModel:videoModel];
    return showCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HMDWeakSelf(self)
    HMDLocationVideoModel *videoModel = self.videoArray[indexPath.row];
    NSString *fileName = videoModel.assetTitle;
    while ([fileName containsString:@" "]) {
        fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    PHAsset *phAsset = videoModel.asset;
//    [[[HMDDHRCenter sharedInstance] DMRControl] renderStop];
    //将非MP4格式转成MP4格式
    if (![fileName containsString:@".mp4"]) {

        fileName = [[[fileName componentsSeparatedByString:@"."] firstObject] stringByAppendingString:@".mp4"];
        NSString *filePath = [HMDDLANNetTool saveFileForName:fileName saveType:HMDDLANNetFileVideoType];
        NSString *url = [HMDDLANNetTool getHttpWebURLWithFileName:fileName fileType:HMDDLANNetFileVideoType];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {

            [[[HMDDHRCenter sharedInstance] DMRControl] renderSetAVTransportWithURI:url metaData:nil];
            [[[HMDDHRCenter sharedInstance] DMRControl] renderPlay];
        }else{
            NSLog(@"开始压缩");
            [HMDProgressHub showAnimationWithMessage:@"视频压缩中" inView:self.view];
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            
            options.version = PHImageRequestOptionsVersionCurrent;
            
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            
            PHImageManager *manager = [PHImageManager defaultManager];
            
            [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                //转码配置
                AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:urlAsset presetName:AVAssetExportPresetMediumQuality];
                exportSession.shouldOptimizeForNetworkUse = YES;
                exportSession.outputURL = [NSURL fileURLWithPath:filePath];
                exportSession.outputFileType = AVFileTypeQuickTimeMovie;
                [exportSession exportAsynchronouslyWithCompletionHandler:^{
                    int exportStatus = exportSession.status;
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [HMDProgressHub hidHubFremView:weakSelf.view];
                    });
                    NSLog(@"压缩结束%@",url);
                    switch (exportStatus)
                    {
                        case AVAssetExportSessionStatusFailed:
                        {
                            // log error to text view
                            NSError *exportError = exportSession.error;
                            NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                            break;
                        }
                        case AVAssetExportSessionStatusCompleted:
                        {
                            NSLog (@"AVAssetExportSessionStatusCompleted");
                            [[[HMDDHRCenter sharedInstance] DMRControl] renderSetAVTransportWithURI:url metaData:nil];
                            [[[HMDDHRCenter sharedInstance] DMRControl] renderPlay];
                        }
                    }
                }];
                
            }];
        }
        
    }else{
        NSArray * assetResources = [PHAssetResource assetResourcesForAsset:phAsset];
        PHAssetResource * resource;
        
        for (PHAssetResource * assetRes in assetResources) {
            
            if (assetRes.type == PHAssetResourceTypeVideo) {
                resource = assetRes;
            }
        }
        NSString *filePath = [HMDDLANNetTool saveFileForName:fileName saveType:HMDDLANNetFileVideoType];
        NSString *url = [HMDDLANNetTool getHttpWebURLWithFileName:fileName fileType:HMDDLANNetFileVideoType];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            //文件已存在,直接投影
            [[[HMDDHRCenter sharedInstance] DMRControl] renderSetAVTransportWithURI:url metaData:nil];
            [[[HMDDHRCenter sharedInstance] DMRControl] renderPlay];
        }else{
            //视频播放
            [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource toFile:[NSURL fileURLWithPath:filePath] options:nil completionHandler:^(NSError * _Nullable error) {
                if (error == nil) {
                    [[[HMDDHRCenter sharedInstance] DMRControl] renderSetAVTransportWithURI:url metaData:nil];
                    [[[HMDDHRCenter sharedInstance] DMRControl] renderPlay];
                }
            }];
        }
    }
}
#pragma mark - 点击
-(void)dismissAction:(UIButton *)sender{
    [super dismissAction:sender];
    [[HMDDLANNetTool sharedInstance] stopWebServer];
    [HMDLinkView sharedInstance].hidden = NO;
}

#pragma mark - 懒加载
-(NSMutableArray *)videoArray{
    if (_videoArray == nil) {
        _videoArray = [NSMutableArray array];
        //初始化的时候获取本地所有视频
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
        [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAsset *asset = (PHAsset *)obj;
            HMDLocationVideoModel *videoModel = [[HMDLocationVideoModel alloc] init];
            videoModel.asset = asset;
            NSArray *resources = [PHAssetResource assetResourcesForAsset:asset];
            NSString *orgFilename = ((PHAssetResource*)resources[0]).originalFilename;
            videoModel.assetTitle = orgFilename;
            [_videoArray insertObject:videoModel atIndex:0];
        }];
        [self.loadingView endLoading];
    }
    return _videoArray;
}

@end
