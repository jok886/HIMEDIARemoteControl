//
//  HMDImageShowViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/23.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDImageShowViewController.h"
#import "HMDImageShowCollectionViewCell.h"
#import "HMDSaveTool.h"
@interface HMDImageShowViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSMutableArray *shotImageArray;
@property (nonatomic,strong) NSMutableArray *choiceImageArray;
@property (weak, nonatomic) IBOutlet UICollectionView *showImageCollectionView;
@property (nonatomic,assign) BOOL choiceState;                  //选择模式
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation HMDImageShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getAllCurImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [HMDLinkView sharedInstance].hidden = NO;
}
#pragma mark - 初始化
-(void)setupUI{
    [self.showImageCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HMDImageShowCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:self.showImageCollectionView.restorationIdentifier];
    self.title = @"截屏图片";
    [self setupNav];

}
-(void)setupNav{
    //返回按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 60, 40);
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitle:@"选择" forState:UIControlStateNormal];
    [rightButton setTitle:@"取消" forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(changeChoiceState:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
}

-(void)getAllCurImage{
    NSArray *fileArray = [HMDSaveTool getAllImageFile];
    self.shotImageArray = [NSMutableArray arrayWithArray:fileArray];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shotImageArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat width = (HMDScreenW -20 - 10)/3.0;
    return CGSizeMake(width, width/100.0*62);

}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5, 10, 10, 10);
    return edgeInsets;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HMDImageShowCollectionViewCell *showCell = [collectionView dequeueReusableCellWithReuseIdentifier:self.showImageCollectionView.restorationIdentifier forIndexPath:indexPath];
    NSString *filePath = self.shotImageArray[indexPath.row];
    showCell.imageView.image = [UIImage imageWithContentsOfFile:filePath];
    if (self.choiceState) {
        NSString *rowStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        if ([self.choiceImageArray containsObject:rowStr]) {
            showCell.cellState = HMDImageShowCollectionViewCellSelectState;
        }else {
            showCell.cellState = HMDImageShowCollectionViewCellUnselectState;
        }

    }else{
        showCell.cellState = HMDImageShowCollectionViewCellNormalState;
    }
    return showCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.choiceState) {
        NSString *rowStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        if ([self.choiceImageArray containsObject:rowStr]) {
           [self.choiceImageArray removeObject:rowStr];
        }else {
           [self.choiceImageArray addObject:rowStr];
        }
        [self.showImageCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        self.title = [NSString stringWithFormat:@"已选择%lu个文件",(unsigned long)self.choiceImageArray.count];
    }else{
        
    }
}
#pragma mark - 点击
//改变状态
-(void)changeChoiceState:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.choiceState = btn.selected;
    if (btn.selected) {
        self.bottomConstraint.constant = 0;
        [self.choiceImageArray removeAllObjects];
    }else{
        self.bottomConstraint.constant = 50;
        self.title = @"截屏图片";
    }
    [self.showImageCollectionView reloadData];
}
//删除相片
- (IBAction)deleteCurImage:(id)sender {
    for (NSString *rowStr in self.choiceImageArray) {
        NSString *filePath = self.shotImageArray[[rowStr integerValue]];
        [self.shotImageArray removeObject:filePath];
        BOOL move = [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        NSLog(@"move___%d",move);
    }
    [self.choiceImageArray removeAllObjects];
    [self.showImageCollectionView reloadData];
}

#pragma mark - 懒加载
-(NSMutableArray *)shotImageArray{
    if (_shotImageArray == nil) {
        _shotImageArray = [NSMutableArray array];
    }
    return _shotImageArray;
}

-(NSMutableArray *)choiceImageArray{
    if (_choiceImageArray == nil) {
        _choiceImageArray = [NSMutableArray array];
    }
    return _choiceImageArray;
}
@end
