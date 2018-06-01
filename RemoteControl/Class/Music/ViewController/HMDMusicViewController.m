//
//  HMDMusicViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/22.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDMusicViewController.h"
#import "HMDMainLoadingView.h"
#import "HMDMusicListDao.h"
#import "HMDMusicListTableViewCell.h"
@interface HMDMusicViewController ()<UITableViewDelegate,UITableViewDataSource>
//@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITableView *musicListTableView;
@property (weak, nonatomic) IBOutlet UIView *nullPageView;
@property (weak, nonatomic) IBOutlet HMDMainLoadingView *loadingView;
@property (nonatomic,strong) NSMutableArray *musicListArray;
@property (nonatomic,strong) HMDMusicListDao *musicListDao;
@end

@implementation HMDMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    if ([HMDLinkView sharedInstance].linkViewState == HMDLinkViewStateLinked) {
        
        [self getMusicList];
    }else{
        self.nullPageView.hidden = NO;
        [HMDProgressHub showMessage:@"请链接设备" hideAfter:2.0];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化
-(void)setupUI{
    [self.musicListTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HMDMusicListTableViewCell class]) bundle:nil] forCellReuseIdentifier:self.musicListTableView.restorationIdentifier];
}

-(void)getMusicList{
    [self.loadingView startLoading];
    HMDWeakSelf(self)
    [self.musicListDao getAllMusicListFinishBlock:^(BOOL success, NSArray *musicArray) {
        [weakSelf.loadingView endLoading];
        if (musicArray.count>0) {
            weakSelf.musicListTableView.hidden = NO;
            weakSelf.musicListArray = [NSMutableArray arrayWithArray:musicArray];
            [weakSelf.musicListTableView reloadData];
        }else{
            weakSelf.nullPageView.hidden = NO;
        }
    }];
}
#pragma mark - 点击
//重新加载
- (IBAction)reloadMusicListBtnClick:(id)sender {
    if ([HMDLinkView sharedInstance].linkViewState == HMDLinkViewStateLinked) {
        self.nullPageView.hidden = YES;
        [self getMusicList];
    }else{
        [HMDProgressHub showMessage:@"请链接设备" hideAfter:2.0];
    }

}



#pragma mark - UITableViewDelegate,UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musicListArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMDMusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.musicListTableView.restorationIdentifier forIndexPath:indexPath];
    NSString *filePath = self.musicListArray[indexPath.row];
    [cell setupCellWithMusicName:filePath serialNumber:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *filePath = self.musicListArray[indexPath.row];
    [self.musicListDao playMusicWithFilePath:filePath finishBlock:^(BOOL success) {
        
    }];
}

#pragma mark - 懒加载
-(HMDMusicListDao *)musicListDao{
    if (_musicListDao == nil) {
        _musicListDao = [[HMDMusicListDao alloc] init];
    }
    return _musicListDao;
}

-(NSMutableArray *)musicListArray{
    if (_musicListArray == nil) {
        _musicListArray = [NSMutableArray array];
    }
    return _musicListArray;
}
@end
