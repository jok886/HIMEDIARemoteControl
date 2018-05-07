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
                          @"search",@"icon",
                          nil];
    NSDictionary *dict_2 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"投射照片",@"name",
                            @"search",@"icon",
                            nil];
    NSDictionary *dict_3 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"清理大师",@"name",
                            @"search",@"icon",
                            nil];
    NSDictionary *dict_4 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"投播视频",@"name",
                            @"search",@"icon",
                            nil];
    NSDictionary *dict_5 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"抄送文件",@"name",
                            @"search",@"icon",
                            nil];
    NSDictionary *dict_6 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"投放音乐",@"name",
                            @"search",@"icon",
                            nil];
    self.itemsArray = [NSArray arrayWithObjects:dict_1,dict_2,dict_3,dict_4,dict_5,dict_6, nil];
}
-(void)setupUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(80, 100);
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 30;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    UICollectionView *treasureChestCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    
    [treasureChestCollectionView registerNib:[UINib nibWithNibName:@"HMDTreasureChestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    treasureChestCollectionView.allowsMultipleSelection = NO;
    treasureChestCollectionView.dataSource = self;
    treasureChestCollectionView.delegate = self;
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
    cell.backgroundColor = HMDRandomColor;
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
//            [self projectivePhoto];
            break;
        case 5:
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
        NSURL *filePathURL = [info objectForKey:@"UIImagePickerControllerMediaURL"];
        NSString *fileName = [[filePathURL.absoluteString componentsSeparatedByString:@"/"] lastObject];
        
        PHAsset *asset = [info objectForKey:@"UIImagePickerControllerPHAsset"];
        NSArray * assetResources = [PHAssetResource assetResourcesForAsset:asset];
        PHAssetResource * resource;
        
        for (PHAssetResource * assetRes in assetResources) {
            
            if (assetRes.type == PHAssetResourceTypeVideo) {
                resource = assetRes;
            }
        }
        NSString *filePath = [HMDDLANNetTool saveFileForName:fileName saveType:HMDDLANNetFileVideoType];
        NSString *url = [HMDDLANNetTool getHttpWebURLWithFileName:fileName fileType:HMDDLANNetFileVideoType];
        //视频播放
            [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource toFile:[NSURL fileURLWithPath:filePath] options:nil completionHandler:^(NSError * _Nullable error) {
                if (error == nil) {
                    [[[HMDDHRCenter sharedInstance] DMRControl] renderSetAVTransportWithURI:url metaData:nil];
                    [[[HMDDHRCenter sharedInstance] DMRControl] renderPlay];
                }
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

    [[NSNotificationCenter defaultCenter] postNotificationName:HMDLinkViewWillShow object:nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [[NSNotificationCenter defaultCenter] postNotificationName:HMDLinkViewWillShow object:nil];
//    [HMDLinkView sharedInstance].hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 功能
//截屏
-(void)getCapture{
    [self.appListDao getCaptureFinishBlock:^(BOOL success, NSData *imageData) {
        if (success) {
            UIImage *image = [UIImage imageWithData:imageData];
            UIImageView *showImageView = [[UIImageView alloc] initWithImage:image];
            showImageView.layer.anchorPoint = CGPointMake(0.1, 0.9);
            showImageView.contentMode = UIViewContentModeScaleAspectFit;
            showImageView.frame = CGRectMake(0, 0, HMDScreenW, HMDScreenH);
            [[UIApplication sharedApplication].keyWindow addSubview:showImageView];
            [UIView animateWithDuration:1.5 animations:^{
                CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.4, 0.4);
                showImageView.transform = scaleTransform;
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [showImageView removeFromSuperview];
                });
                
            }];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }

    }];
}
//投射照片
-(void)projectivePhoto{
    //隐藏底部链接状态
//    [HMDLinkView sharedInstance].hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:HMDLinkViewWillHide object:nil];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:
                                             (NSString *)kUTTypeImage,
                                             (NSString *)kUTTypeJPEG,
                                             (NSString *)kUTTypeJPEG2000,
                                             (NSString *)kUTTypeTIFF,
                                             (NSString *)kUTTypePICT,
                                             (NSString *)kUTTypeICO,
                                             (NSString *)kUTTypePNG,
                                             (NSString *)kUTTypeQuickTimeImage,
                                             (NSString *)kUTTypeAppleICNS,
                                             (NSString *)kUTTypeBMP,
                                             nil];
    [[self.view getCurActiveViewController] presentViewController:self.imagePickerController animated:YES completion:nil];
}
//清理大师
-(void)clearMaster{
    [self.appListDao openDLanAppWithPackage:@"com.hitv.process" FinishBlock:^(BOOL success) {
        if (success) {
            
        }
    }];
}

//投视频
-(void)projectiveVideo{

    //隐藏底部链接状态
    [[NSNotificationCenter defaultCenter] postNotificationName:HMDLinkViewWillHide object:nil];
//[HMDLinkView sharedInstance].hidden = YES;
        self.imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:
                                                 (NSString *)kUTTypeAudiovisualContent,
                                                 (NSString *)kUTTypeMovie,
                                                 (NSString *)kUTTypeVideo,
                                                 (NSString *)kUTTypeAudio,
                                                 (NSString *)kUTTypeQuickTimeMovie,
                                                 (NSString *)kUTTypeMPEG,
                                                 (NSString *)kUTTypeMPEG4,
                                                 (NSString *)kUTTypeMP3,
                                                 (NSString *)kUTTypeMPEG4Audio,
                                                 (NSString *)kUTTypeAppleProtectedMPEG4Audio,
                                                 nil];
    [[self.view getCurActiveViewController] presentViewController:self.imagePickerController animated:YES completion:nil];
//    [HMDTreasureChestDao startPlayVideoToTVWithURL:@"http://bla.gtimg.com/qqlive/201609/BRDD_20160920182023501.mp4"];
}

#pragma mark - 懒加载
-(UIImagePickerController *)imagePickerController{
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
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
