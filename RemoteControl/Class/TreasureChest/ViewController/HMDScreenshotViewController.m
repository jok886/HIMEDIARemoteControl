//
//  HMDScreenshotViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/22.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDScreenshotViewController.h"

#import "HMDScreenshotCollectionViewCell.h"
#import "HMDTVBaseFunctionDao.h"
#import "HMDImageShowViewController.h"
#import "HMDSaveTool.h"
@interface HMDScreenshotViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIButton *albumBtn;

@property (weak, nonatomic) IBOutlet UIButton *screenshotBtn;
@property (weak, nonatomic) IBOutlet UILabel *notiLab;
@property (weak, nonatomic) IBOutlet UICollectionView *showImageCollectionView;
@property (nonatomic,strong) NSMutableArray *shotImageArray;
@property (nonatomic,strong) HMDTVBaseFunctionDao *baseFunctionDao;
@end

@implementation HMDScreenshotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getAllCurImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化
-(void)setupUI{
    [self.showImageCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HMDScreenshotCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:self.showImageCollectionView.restorationIdentifier];
    self.title = @"电视截屏";
    [self setupFirstNavBar];
}
-(void)getAllCurImage{
    NSArray *fileArray = [HMDSaveTool getAllImageFile];
    if (fileArray.count > 0) {
        self.albumBtn.hidden = NO;
    }
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shotImageArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return CGSizeMake(HMDScreenW-20, (HMDScreenW-20)/340.0*191.0);
    }else{
        CGFloat width = (HMDScreenW-20 - 10)/3.0;
        return CGSizeMake(width, width/100.0*62);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HMDScreenshotCollectionViewCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:self.showImageCollectionView.restorationIdentifier forIndexPath:indexPath];
    UIImage *image = self.shotImageArray[indexPath.row];
    imageCell.imageView.image = image;
    return imageCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self gotoAlbumBtnClick:nil];
}

#pragma mark - 点击
//点击截屏
- (IBAction)screenshotBtnClick:(id)sender {
    HMDWeakSelf(self)
    [self.baseFunctionDao getCaptureFinishBlock:^(BOOL success, NSData *imageData) {
        if (success) {
            UIImage *image = [UIImage imageWithData:imageData];
            [weakSelf.shotImageArray addObject:image];
            NSString *filePath = [HMDSaveTool getSaveImageFilePathWithImageData:imageData];
            [weakSelf reloadUI];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

            [imageData writeToFile:filePath atomically:YES];

        }
        
    }];
}

//进入沙盒相册
- (IBAction)gotoAlbumBtnClick:(id)sender {
    [HMDLinkView sharedInstance].hidden = YES;
    HMDImageShowViewController *imageShowVC = [[HMDImageShowViewController alloc] init];
    [self.navigationController pushViewController:imageShowVC animated:YES];
}

#pragma mark - 其他
//刷新
-(void)reloadUI{
    if (self.shotImageArray.count>0) {
        self.albumBtn.hidden = YES;
        self.showImageCollectionView.hidden = NO;
        self.notiLab.hidden = YES;
        [self.showImageCollectionView reloadData];
    }else{
        self.albumBtn.hidden = NO;
        self.showImageCollectionView.hidden = YES;
        self.notiLab.hidden = NO;
        [self.showImageCollectionView reloadData];
    }

}
#pragma mark - 懒加载
-(NSMutableArray *)shotImageArray{
    if (_shotImageArray == nil) {
        _shotImageArray = [NSMutableArray array];
    }
    return _shotImageArray;
}

-(HMDTVBaseFunctionDao *)baseFunctionDao{
    if (_baseFunctionDao == nil) {
        _baseFunctionDao = [[HMDTVBaseFunctionDao alloc] init];
    }
    return _baseFunctionDao;
}
@end
