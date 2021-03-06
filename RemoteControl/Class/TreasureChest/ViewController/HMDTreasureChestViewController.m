//
//  HMDTreasureChestViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/12.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDTreasureChestViewController.h"
#import "HMDTreasureChestCollectionViewCell.h"
#import "HMDAppListDao.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import "UIImageView+HMDDLANLoadImage.h"

#import "UIImage+Extend.h"
#import "HMDDLANNetTool.h"

#import "HMDScreenshotViewController.h"
#import "HMDVideoChoiceViewController.h"
@interface HMDTreasureChestViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (nonatomic,weak) UICollectionView *treasureChestCollectionView;                       //主界面
@property (nonatomic,strong) UIImagePickerController *imagePickerController;                    //相册
@property (nonatomic,strong) NSArray *itemsArray;                                               //百宝箱固定的组件
@property (nonatomic,strong) HMDAppListDao *appListDao;                                         //app应用dao
@end

@implementation HMDTreasureChestViewController
static NSString * const reuseIdentifier = @"HMDTreasureChestCollectionViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupItems];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.treasureChestCollectionView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化
-(void)setupItems{
    NSDictionary *dict_1 = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"电视截屏",@"name",
                          @"tool_screenshot",@"icon",
                          nil];
    NSDictionary *dict_2 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"投射照片",@"name",
                            @"tool_picture",@"icon",
                            nil];
    NSDictionary *dict_3 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"清理大师",@"name",
                            @"tool_clear",@"icon",
                            nil];
    NSDictionary *dict_4 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"投播视频",@"name",
                            @"tool_video",@"icon",
                            nil];
    NSDictionary *dict_5 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"抄送文件",@"name",
                            @"tool_file",@"icon",
                            nil];
    NSDictionary *dict_6 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"投放音乐",@"name",
                            @"tool_music",@"icon",
                            nil];
    self.itemsArray = [NSArray arrayWithObjects:dict_1,dict_2,dict_3,dict_4,dict_5,dict_6, nil];
}
-(void)setupUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(100, 110);
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
    UICollectionView *treasureChestCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    
    [treasureChestCollectionView registerNib:[UINib nibWithNibName:@"HMDTreasureChestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    treasureChestCollectionView.allowsMultipleSelection = NO;
    treasureChestCollectionView.dataSource = self;
    treasureChestCollectionView.delegate = self;
    treasureChestCollectionView.backgroundColor = HMDColorFromValue(0xF0F0F0);
    [self.view addSubview:treasureChestCollectionView];
    self.treasureChestCollectionView = treasureChestCollectionView;
}

#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemsArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HMDTreasureChestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *curDict = self.itemsArray[indexPath.row];
    NSString *icon = [curDict objectForKey:@"icon"];
    NSString *name = [curDict objectForKey:@"name"];
    cell.iconImageView.image = [UIImage imageNamed:icon];
    cell.nameLab.text = name;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self getCapture];
            break;
        case 1:
            [self projectivePhoto];
            break;
        case 2:
            [self clearMaster];
            break;
        case 3:
            [self projectiveVideo];
            break;
        case 4:
            [HMDProgressHub showMessage:@"功能暂未开放" hideAfter:2.0];
//            [self projectivePhoto];
            break;
        case 5:
            [HMDProgressHub showMessage:@"功能暂未开放" hideAfter:2.0];
//            [self projectivePhoto];
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType = [info objectForKey:@"UIImagePickerControllerMediaType"];
    if ([mediaType containsString:@"movie"]) {
//        [[[HMDDHRCenter sharedInstance] DMRControl] renderSetAVTransportWithURI:@"http://bla.gtimg.com/qqlive/201609/BRDD_20160920182023501.mp4" metaData:nil];
//        [[[HMDDHRCenter sharedInstance] DMRControl] renderPlay];
        NSURL *filePathURL = [info objectForKey:@"UIImagePickerControllerMediaURL"];
        NSString *fileName = [[filePathURL.absoluteString componentsSeparatedByString:@"/"] lastObject];

        PHAsset *phAsset = [info objectForKey:@"UIImagePickerControllerPHAsset"];

        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];

        options.version = PHImageRequestOptionsVersionCurrent;

        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;

        PHImageManager *manager = [PHImageManager defaultManager];

        [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {

            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            //转码配置
            NSString *filePath = [HMDDLANNetTool saveFileForName:fileName saveType:HMDDLANNetFileVideoType];
            NSString *url = [HMDDLANNetTool getHttpWebURLWithFileName:fileName fileType:HMDDLANNetFileVideoType];
            filePath = [filePath stringByReplacingOccurrencesOfString:@".MOV" withString:@".mp4"];
            url = [url stringByReplacingOccurrencesOfString:@".MOV" withString:@".mp4"];
            AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:urlAsset presetName:AVAssetExportPresetMediumQuality];
            exportSession.shouldOptimizeForNetworkUse = YES;
            exportSession.outputURL = [NSURL fileURLWithPath:filePath];
            exportSession.outputFileType = AVFileTypeQuickTimeMovie;
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                int exportStatus = exportSession.status;

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

    }else if ([mediaType containsString:@"image"]){
        NSURL *filePathURL = [info objectForKey:@"UIImagePickerControllerImageURL"];
        NSString *fileName = [[filePathURL.absoluteString componentsSeparatedByString:@"/"] lastObject];
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        NSString *filePath = [HMDDLANNetTool saveFileForName:fileName saveType:HMDDLANNetFileImageType];
        NSData *imageData ;
        if ([filePath containsString:@".png"]) {
            imageData = UIImagePNGRepresentation(image);
        }else{
            switch (image.imageOrientation) {
                case UIImageOrientationUp:
                    imageData = UIImageJPEGRepresentation(image, 1.0);
                    break;
                default:
                {
                    //拍摄的图片会旋转,需要矫正
                    UIImage *newImage = [image fixOrientation];
                    imageData = UIImageJPEGRepresentation(newImage, 1.0);
                }
                    break;
            }
        }
        [imageData writeToFile:filePath atomically:YES];
        NSString *url = [HMDDLANNetTool getHttpWebURLWithFileName:fileName fileType:HMDDLANNetFileImageType];
        [[[HMDDHRCenter sharedInstance] DMRControl] renderSetAVTransportWithURI:url metaData:nil];
        [[[HMDDHRCenter sharedInstance] DMRControl] renderPlay];

    }

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [[HMDDLANNetTool sharedInstance] stopWebServer];
    [HMDLinkView sharedInstance].hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 功能
//截屏
-(void)getCapture{
    //判断当前是否链接
    if ([HMDLinkView sharedInstance].linkViewState == HMDLinkViewStateLinked) {
        HMDScreenshotViewController *screenshotVC = [[HMDScreenshotViewController alloc] init];
        HMDNavigationController *nav = [[HMDNavigationController alloc] initWithRootViewController:screenshotVC];
        [self.view.getCurActiveViewController presentViewController:nav animated:YES completion:nil];
    }else{
        [HMDProgressHub showMessage:@"请先链接设备" hideAfter:2.0];
    }

}
//投射照片
-(void)projectivePhoto{
    //判断当前是否链接
    if ([HMDLinkView sharedInstance].linkViewState == HMDLinkViewStateLinked) {
        [[HMDDLANNetTool sharedInstance] startWebServer];
        //隐藏底部链接状态
        [HMDLinkView sharedInstance].hidden = YES;

        [[self.view getCurActiveViewController] presentViewController:self.imagePickerController animated:YES completion:nil];
    }else{
        [HMDProgressHub showMessage:@"请先链接设备" hideAfter:2.0];
    }

}
//清理大师
-(void)clearMaster{

    //判断当前是否链接
    if ([HMDLinkView sharedInstance].linkViewState == HMDLinkViewStateLinked) {
        [self.appListDao openDLanAppWithPackage:@"com.hitv.process" FinishBlock:^(BOOL success) {
            if (success) {
                
            }
        }];
    }else{
        [HMDProgressHub showMessage:@"请先链接设备" hideAfter:2.0];
    }
}

//投视频
-(void)projectiveVideo{
    //判断当前是否链接
    if ([HMDLinkView sharedInstance].linkViewState == HMDLinkViewStateLinked) {
        [HMDLinkView sharedInstance].hidden = YES;
        HMDVideoChoiceViewController *videoListVC = [[HMDVideoChoiceViewController alloc] init];
        HMDNavigationController *nav = [[HMDNavigationController alloc] initWithRootViewController:videoListVC];
        [self.view.getCurActiveViewController presentViewController:nav animated:YES completion:^{
            [[HMDDLANNetTool sharedInstance] startWebServer];
        }];
    }else{
        [HMDProgressHub showMessage:@"请先链接设备" hideAfter:2.0];
    }

}

#pragma mark - 懒加载
-(UIImagePickerController *)imagePickerController{
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _imagePickerController.allowsEditing = NO;
    }
    return _imagePickerController;
}

-(HMDAppListDao *)appListDao{
    if (_appListDao == nil) {
        _appListDao = [[HMDAppListDao alloc] init];
    }
    return _appListDao;
}
@end
