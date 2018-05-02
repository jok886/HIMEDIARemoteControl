//
//  HMDPlayHistoryViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/24.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDPlayHistoryViewController.h"

#import "HMDVideoHistoryTableViewCell.h"
#import "HMDHistoryHeadView.h"

#import "HMDVideoDataDao.h"

@interface HMDPlayHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *historyTableView;
@property (nonatomic,strong) NSMutableArray *historyListArray;                  //所有的历史数据
@property (nonatomic,strong) NSMutableArray *historyListTodayArray;             //今日的历史数据
@property (nonatomic,strong) NSMutableArray *historyListOldArray;               //更早的历史数据
@property (nonatomic,strong) HMDVideoDataDao *videoDataDao;
@end

@implementation HMDPlayHistoryViewController
static NSString * const reuseIdentifier = @"HMDVideoHistoryTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupFirstNavBar];
    [self getHistoryData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化

-(void)getHistoryData{
    HMDWeakSelf(self)
    [self.videoDataDao getPlayHistoryFinishBlock:^(BOOL success, NSArray *modelArray) {
        if (success) {
            weakSelf.historyListArray = [NSMutableArray arrayWithArray:modelArray];
            [weakSelf.historyTableView reloadData];
        }
        [weakSelf.historyTableView reloadData];
    }];
}
//数据分组
-(void)historyListDivideIntoGroups{
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historyListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMDVideoHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    HMDVideoHistoryModel *model = self.historyListArray[indexPath.row];
    [cell setupCellWithHistoryModel:model];
    cell.backgroundColor = HMDRandomColor;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HMDHistoryHeadView *headView = [HMDHistoryHeadView hmd_viewFromXib];
    headView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    headView.backgroundColor = HMDRandomColor;
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HMDVideoHistoryModel *model = self.historyListArray[indexPath.row];
    [self.videoDataDao playHistoryWithHistoryModel:model FinishBlock:^(BOOL success) {
        
    }];
}

#pragma mark - 点击


#pragma mark - 懒加载
-(NSMutableArray *)historyListArray{
    if (_historyListArray == nil) {
        _historyListArray = [NSMutableArray array];
    }
    return _historyListArray;
}

-(UITableView *)historyTableView{
    if (_historyTableView == nil) {
        _historyTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [_historyTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HMDVideoHistoryTableViewCell class]) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
        _historyTableView.delegate = self;
        _historyTableView.dataSource = self;
        _historyTableView.showsVerticalScrollIndicator = NO;
        _historyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_historyTableView];
    }
    return _historyTableView;
}

-(HMDVideoDataDao *)videoDataDao{
    if (_videoDataDao == nil) {
        _videoDataDao = [[HMDVideoDataDao alloc] init];
    }
    return _videoDataDao;
}
@end
