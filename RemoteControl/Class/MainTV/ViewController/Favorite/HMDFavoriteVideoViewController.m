//
//  HMDFavoriteVideoViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/17.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDFavoriteVideoViewController.h"
#import "HMDVideoDataDao.h"
#import "HMDFavoriteVideoTableViewCell.h"
@interface HMDFavoriteVideoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *videoTableView;
@property (nonatomic,strong) HMDVideoDataDao *videoDataDao;
@property (weak, nonatomic) IBOutlet HMDMainLoadingView *loadingView;
@property (nonatomic,strong) NSArray *favoriteVideoArray;
@property (weak, nonatomic) IBOutlet UIView *nullFavoriteView;
@end

@implementation HMDFavoriteVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getCollectList];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [HMDLinkView sharedInstance].hidden = YES;
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
    self.title = @"收藏";
    [self setupFirstNavBar];
    self.videoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     [self.videoTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HMDFavoriteVideoTableViewCell class]) bundle:nil] forCellReuseIdentifier:self.videoTableView.restorationIdentifier];
}
-(void)getCollectList{
    [self.loadingView startLoading];
    
    HMDWeakSelf(self)
    [self.videoDataDao getCollectRecordFinishBlock:^(BOOL success, NSArray *favoriteList) {
        [weakSelf.loadingView endLoading];
        if (favoriteList==nil && favoriteList.count == 0) {
            weakSelf.videoTableView.hidden = YES;
            weakSelf.nullFavoriteView.hidden = NO;
        }else{
            weakSelf.favoriteVideoArray = [NSArray arrayWithArray:favoriteList];
            [weakSelf.videoTableView reloadData];
        }
    }];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.favoriteVideoArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMDFavoriteVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableView.restorationIdentifier];
    HMDFavoriteVideoModel *videoModel = self.favoriteVideoArray[indexPath.row];
    [cell setupCellWithModel:videoModel];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HMDFavoriteVideoModel *videoModel = self.favoriteVideoArray[indexPath.row];
    [self.videoDataDao playCollectWithCollectModel:videoModel FinishBlock:^(BOOL success) {
        
    }];
}
#pragma mark - 懒加载
-(NSArray *)favoriteVideoArray{
    if (_favoriteVideoArray == nil) {
        _favoriteVideoArray = [NSArray array];
    }
    return _favoriteVideoArray;
}
-(HMDVideoDataDao *)videoDataDao{
    if (_videoDataDao == nil) {
        _videoDataDao = [[HMDVideoDataDao alloc] init];
    }
    return _videoDataDao;
}
@end
