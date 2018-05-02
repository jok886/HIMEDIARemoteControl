//
//  HMDTreasureChestViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/12.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDTreasureChestViewController.h"
#import "HMDTreasureChestCollectionViewCell.h"
#import "HMDTreasureChestDao.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import "UIImageView+HMDDLANLoadImage.h"
#import "HMDDLANNetTool.h"
@interface HMDTreasureChestViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (nonatomic,weak) UICollectionView *treasureChestCollectionView;           //主界面
@property (nonatomic,strong) UIImagePickerController *imagePickerController;          //相册
@property (nonatomic,strong) NSArray *itemsArray;                   //百宝箱固定的组件
@property (nonatomic,strong) HMDTreasureChestDao *treasureChestDao;
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
//            [self projectivePhoto];
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
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
//    NSData *imageData =UIImagePNGRepresentation(image);
//    [HMDTreasureChestDao startPlayToTVWithImageData:imageData];
//    [[NSNotificationCenter defaultCenter] postNotificationName:HMDLinkViewWillShow object:nil];
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType = [info objectForKey:@"UIImagePickerControllerMediaType"];
    if ([mediaType containsString:@"movie"]) {
//        NSURL *url = [info objectForKey:@"UIImagePickerControllerMediaURL"];
//        [HMDTreasureChestDao startPlayVideoToTVWithURL:@"http://bla.gtimg.com/qqlive/201609/BRDD_20160920182023501.mp4"];
        [self.treasureChestDao startPlayMediaWithURL:@"http://bla.gtimg.com/qqlive/201609/BRDD_20160920182023501.mp4"];
    }else if ([mediaType containsString:@"image"]){
        NSURL *filePathURL = [info objectForKey:@"UIImagePickerControllerImageURL"];
        NSString *fileName = [[filePathURL.absoluteString componentsSeparatedByString:@"/"] lastObject];

        PHAsset *asset = [info objectForKey:@"UIImagePickerControllerPHAsset"];

        PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];

        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:phImageRequestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            NSString *filePath = [HMDDLANNetTool saveFileForName:fileName saveType:HMDDLANNetFileImageType];
            [imageData writeToFile:filePath atomically:YES];
            NSString *url = [HMDDLANNetTool getHttpWebURLWithFileName:fileName fileType:HMDDLANNetFileImageType];
            [self.treasureChestDao startPlayMediaWithURL:url];

        }];


    }

    [[NSNotificationCenter defaultCenter] postNotificationName:HMDLinkViewWillShow object:nil];
//    [HMDLinkView sharedInstance].hidden = NO;
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
    [self.treasureChestDao getCaptureFinishBlock:^(BOOL success, NSData *imageData) {
        UIImage *image = [UIImage imageWithData:imageData];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
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
//投视频
-(void)projectiveVideo{
//    const CFStringRef  kUTTypeAudiovisualContent ;抽象的声音视频
//    const CFStringRef  kUTTypeMovie ;抽象的媒体格式（声音和视频）
//    const CFStringRef  kUTTypeVideo ;只有视频没有声音
//    const CFStringRef  kUTTypeAudio ;只有声音没有视频
//    const CFStringRef  kUTTypeQuickTimeMovie ;
//    const CFStringRef  kUTTypeMPEG ;
//    const CFStringRef  kUTTypeMPEG4 ;
//    const CFStringRef  kUTTypeMP3 ;
//    const CFStringRef  kUTTypeMPEG4Audio ;
//    const CFStringRef  kUTTypeAppleProtectedMPEG4Audio;

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
//        _imagePickerController.allowsEditing = YES;
    }
    return _imagePickerController;
}

-(HMDTreasureChestDao *)treasureChestDao{
    if (_treasureChestDao == nil) {
        _treasureChestDao = [[HMDTreasureChestDao alloc]init];
    }
    return _treasureChestDao;
}
@end
