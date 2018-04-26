//
//  HMDAllVideoViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/26.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDAllVideoViewController.h"
#import "HMDVideoDataDao.h"
@interface HMDAllVideoViewController ()
@property (nonatomic,strong) HMDVideoDataDao *videoDao;
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
    [self.videoDao getPosterCategoryFinishBlock:^(BOOL success, NSArray *modelArray) {
        
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
