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
#import "NSString+HMDExtend.h"
#import "HMDMainLoadingView.h"

#import "HMDTVRemoteViewController.h"
typedef enum : NSInteger{
    HMDHistoryListOnlyTodayType = (1<<0),
    HMDHistoryListOnlyBeforeType = (1<<1),
    HMDHistoryListDoubleType = ((1<<1)|(1<<0)),
}HMDHistoryListType;

@interface HMDPlayHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *historyTableView;
@property (nonatomic,strong) NSMutableArray *historyListArray;                  //所有的历史数据
@property (nonatomic,strong) NSMutableArray *historyListTodayArray;             //今日的历史数据
@property (nonatomic,strong) NSMutableArray *historyListBeforeArray;               //更早的历史数据
@property (nonatomic,strong) HMDVideoDataDao *videoDataDao;
@property (nonatomic,assign) HMDHistoryListType historyListType;
@property (nonatomic,strong) HMDMainLoadingView *loadingView;
@end

@implementation HMDPlayHistoryViewController
static NSString * const reuseIdentifier = @"HMDVideoHistoryTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HMDColorFromValue(0xF0F0F0);
    self.title = @"历史";
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 0, 1, HMDScreenH)];
    view.backgroundColor = HMDColorFromValue(0xCCCCCC);
    self.loadingView = [[HMDMainLoadingView alloc] initWithFrame:self.view.bounds];
    self.loadingView.backgroundColor = HMDColorFromValue(0xF0F0F0);
    [self.view addSubview:self.loadingView];
    [self.view addSubview:view];
    [self setupFirstNavBar];
    [self getHistoryData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [HMDLinkView sharedInstance].hidden = NO;
}
#pragma mark - 初始化

-(void)getHistoryData{
    [self.loadingView startLoading];
    HMDWeakSelf(self)
    [self.videoDataDao getPlayHistoryFinishBlock:^(BOOL success, NSArray *modelArray) {
        [weakSelf.loadingView endLoading];
        if (success) {
            weakSelf.historyListArray = [NSMutableArray arrayWithArray:modelArray];
            [weakSelf historyListDivideIntoGroups];
            [weakSelf.historyTableView reloadData];
        }
        [weakSelf.historyTableView reloadData];
    }];
}
//数据分组
-(void)historyListDivideIntoGroups{

    for (HMDVideoHistoryModel *model in self.historyListArray) {
        if ([model.time isTodayTime]) {
            self.historyListType = self.historyListType|HMDHistoryListOnlyTodayType;
            [self.historyListTodayArray addObject:model];
        }else{
            self.historyListType = self.historyListType|HMDHistoryListOnlyBeforeType;
            [self.historyListBeforeArray addObject:model];
        }
    }

}
#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    switch (self.historyListType) {
//        case HMDHistoryListOnlyTodayType:
//            return self.historyListTodayArray.count;
//            break;
//        case HMDHistoryListOnlyBeforeType:
//            return self.historyListBeforeArray.count;
//            break;
//
//        default:
//            {
                if (section == 0) {
                    return self.historyListTodayArray.count;
                }else{
                    return self.historyListBeforeArray.count;
                }
//            }
//            break;
//    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    switch (self.historyListType) {
//        case HMDHistoryListOnlyTodayType:
//        case HMDHistoryListOnlyBeforeType:
//            return 1;
//            break;
//
//        default:
//            return 2;
//            break;
//    }
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMDVideoHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    HMDVideoHistoryModel *model = self.historyListArray[indexPath.row];
    [cell setupCellWithHistoryModel:model];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HMDHistoryHeadView *headView = [HMDHistoryHeadView hmd_viewFromXib];
    headView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 30);
//    switch (self.historyListType) {
//        case HMDHistoryListOnlyTodayType:
//            [headView setheadWithToday:YES];
//            break;
//        case HMDHistoryListOnlyBeforeType:
//
//            break;
//
//        default:
//        {
//            if (section == 0) {
//                [headView setheadWithToday:YES];
//            }
//        }
//            break;
//    }
    if (section == 0) {
        [headView setheadWithToday:YES];
    }
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HMDVideoHistoryModel *model;
    NSInteger section = indexPath.section;
    if (section == 0) {
        model = self.historyListTodayArray[indexPath.row];
    }else{
        model = self.historyListBeforeArray[indexPath.row];
    }
    
    //判断当前是否链接
    if ([HMDLinkView sharedInstance].linkViewState == HMDLinkViewStateLinked) {
        HMDWeakSelf(self)
        [self.videoDataDao playHistoryWithHistoryModel:model FinishBlock:^(BOOL success) {
            if (success) {
                HMDTVRemoteViewController *remoteViewController = [[HMDTVRemoteViewController alloc] init];
                remoteViewController.pushVC = YES;
                [weakSelf.navigationController pushViewController:remoteViewController animated:YES];
            }
        }];

        
    }else{
        [HMDProgressHub showMessage:@"请先链接设备" hideAfter:2.0];
    }

}

#pragma mark - 点击


#pragma mark - 懒加载
-(NSMutableArray *)historyListArray{
    if (_historyListArray == nil) {
        _historyListArray = [NSMutableArray array];
    }
    return _historyListArray;
}

-(NSMutableArray *)historyListTodayArray{
    if (_historyListTodayArray == nil) {
        _historyListTodayArray = [NSMutableArray array];
    }
    return _historyListTodayArray;
}
-(NSMutableArray *)historyListBeforeArray{
    if (_historyListBeforeArray == nil) {
        _historyListBeforeArray = [NSMutableArray array];
    }
    return _historyListBeforeArray;
}
-(UITableView *)historyTableView{
    if (_historyTableView == nil) {
        _historyTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [_historyTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HMDVideoHistoryTableViewCell class]) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
        _historyTableView.delegate = self;
        _historyTableView.dataSource = self;
        _historyTableView.showsVerticalScrollIndicator = NO;
        _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _historyTableView.backgroundColor = [UIColor clearColor];
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
