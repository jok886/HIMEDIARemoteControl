//
//  HMDAllVideoViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/26.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDAllVideoViewController.h"
#import "HMDVideoDataDao.h"
#import "HMDTVClassifyCollectionView.h"
#import "HMDTVFilterCollectionView.h"

@interface HMDAllVideoViewController ()
@property (nonatomic,strong) HMDVideoDataDao *videoDao;
@property (weak, nonatomic) IBOutlet UIButton *showTimeBtn;                                         //上映时间
@property (weak, nonatomic) IBOutlet UIButton *graphemeBtn;                                         //字母排序
@property (weak, nonatomic) IBOutlet UIButton *doubanBtn;                                           //豆瓣评分
@property (weak, nonatomic) IBOutlet UIButton *allTypeClassifyBtn;                                  //所有分类
@property (weak, nonatomic) IBOutlet HMDTVClassifyCollectionView *typeCollectionView;               //分类

@property (weak, nonatomic) IBOutlet UIButton *allLocationClassifyBtn;                              //所有地区
@property (weak, nonatomic) IBOutlet HMDTVClassifyCollectionView *locationCollectionView;           //地区

@property (weak, nonatomic) IBOutlet UIButton *allYearClassifyBtn;                                  //所有年份
@property (weak, nonatomic) IBOutlet HMDTVClassifyCollectionView *yearCollectionView;               //年份
@property (weak, nonatomic) IBOutlet HMDTVFilterCollectionView *showCollectionView;                 //筛选结果


@end

@implementation HMDAllVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupFirstNavBar];
    [self getPosterCategory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化


-(void)getPosterCategory{
    HMDWeakSelf(self)
    [self.videoDao getPosterCategoryFinishBlock:^(BOOL success, NSDictionary *classifyDict) {
        if (success) {
            NSArray *typeArray = [classifyDict objectForKey:@"type"];
            weakSelf.typeCollectionView.classifyArray = [NSArray arrayWithArray:typeArray];
            [weakSelf.typeCollectionView reloadData];
            
            NSArray *locationArray = [classifyDict objectForKey:@"location"];
            weakSelf.locationCollectionView.classifyArray = [NSArray arrayWithArray:locationArray];
            [weakSelf.locationCollectionView reloadData];
            
            NSArray *yearArray = [classifyDict objectForKey:@"year"];
            weakSelf.yearCollectionView.classifyArray = [NSArray arrayWithArray:yearArray];
            [weakSelf.yearCollectionView reloadData];
            
        }
    }];
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
