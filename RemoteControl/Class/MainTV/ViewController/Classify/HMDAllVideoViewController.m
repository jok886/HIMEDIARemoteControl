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
#import "HMDMainLoadingView.h"

#import <MJRefresh/MJRefresh.h>
typedef enum : NSInteger
{
    HMDClassifyCategoryType = 4,
    HMDClassifyLocationType = 5,
    HMDClassifyYearType = 6,
    HMDClassifyVideoTypeType = 7,
}HMDClassifyType;

@interface HMDAllVideoViewController ()
@property (nonatomic,strong) HMDVideoDataDao *videoDao;
@property (weak, nonatomic) IBOutlet UIButton *showTimeBtn;                                         //上映时间
@property (weak, nonatomic) IBOutlet UIButton *graphemeBtn;                                         //字母排序
@property (weak, nonatomic) IBOutlet UIButton *doubanBtn;                                           //豆瓣评分
@property (weak, nonatomic) UIButton *curSortBtn;                                                   //当前排序的按钮
@property (weak, nonatomic) IBOutlet UIButton *allCategoryClassifyBtn;                              //所有分类
@property (weak, nonatomic) IBOutlet HMDTVClassifyCollectionView *categoryCollectionView;           //分类

@property (weak, nonatomic) IBOutlet UIButton *allLocationClassifyBtn;                              //所有地区
@property (weak, nonatomic) IBOutlet HMDTVClassifyCollectionView *locationCollectionView;           //地区

@property (weak, nonatomic) IBOutlet UIButton *allYearClassifyBtn;                                  //所有年份
@property (weak, nonatomic) IBOutlet HMDTVClassifyCollectionView *yearCollectionView;               //年份
@property (weak, nonatomic) IBOutlet HMDTVFilterCollectionView *showCollectionView;                 //筛选结果

@property (nonatomic,strong) NSMutableDictionary *filterDict;                                       //筛选的字典
@property (weak, nonatomic) IBOutlet UIView *nullPageView;                                          //空页面
@property (weak, nonatomic) IBOutlet HMDMainLoadingView *loadingView;

@property (nonatomic,assign) NSInteger curPage;                                                     //当前页码
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nullPageTopConstraint;


@end

@implementation HMDAllVideoViewController
static NSString * const kOrder = @"order";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBaseValue];
    [self setupFirstNavBar];
    [self getPosterCategory];
    [self getVideoList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [HMDLinkView sharedInstance].hidden = NO;
}
#pragma mark - 初始化

-(void)setupBaseValue{
    self.title = @"本地影片";
    self.curSortBtn = self.showTimeBtn;
    [self.filterDict setObject:@"t_year" forKey:kOrder];
    [self.filterDict setObject:@"DESC" forKey:@"mode"];
    self.curPage = 0;

    HMDWeakSelf(self)

    self.showCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf addMoreVideoList];
    }];

}
#pragma mark - 网络
//获取分类列表
-(void)getPosterCategory{
    HMDWeakSelf(self)
    [self.videoDao getPosterCategoryFinishBlock:^(BOOL success, NSDictionary *classifyDict) {
        if (success) {
            weakSelf.nullPageTopConstraint.priority = 900;
            NSArray *typeArray = [classifyDict objectForKey:@"type"];
            weakSelf.categoryCollectionView.classifyArray = [NSArray arrayWithArray:typeArray];
            weakSelf.categoryCollectionView.selectClassifyBlock = ^(NSString *classifyName, BOOL videoType) {
                if (videoType) {
                    [weakSelf reloadVideoDateWithClassify:classifyName type:HMDClassifyCategoryType];
                }else{
                    [weakSelf reloadVideoDateWithClassify:classifyName type:HMDClassifyCategoryType];
                }
                
            };
            [weakSelf.categoryCollectionView reloadData];
            
            NSArray *locationArray = [classifyDict objectForKey:@"location"];
            weakSelf.locationCollectionView.classifyArray = [NSArray arrayWithArray:locationArray];
            weakSelf.locationCollectionView.selectClassifyBlock = ^(NSString *classifyName, BOOL videoType) {
                [weakSelf reloadVideoDateWithClassify:classifyName type:HMDClassifyLocationType];
            };
            [weakSelf.locationCollectionView reloadData];
            
            NSArray *yearArray = [classifyDict objectForKey:@"year"];
            weakSelf.yearCollectionView.classifyArray = [NSArray arrayWithArray:yearArray];
            weakSelf.yearCollectionView.selectClassifyBlock = ^(NSString *classifyName, BOOL videoType) {
                [weakSelf reloadVideoDateWithClassify:classifyName type:HMDClassifyYearType];
            };
            [weakSelf.yearCollectionView reloadData];
        }
    }];
}
//获取视频列表
-(void)getVideoList{
    //数据刷新页面
    [self.showCollectionView.mj_footer resetNoMoreData];
    [self.loadingView startLoading];
    HMDWeakSelf(self)
    [self.filterDict setObject:[NSString stringWithFormat:@"%ld",(long)self.curPage] forKey:@"page"];
    [self.videoDao getPostListWithParameters:self.filterDict finishBlock:^(BOOL success, NSArray *posterList) {
        [weakSelf.loadingView endLoading];
        if (success) {
            if (posterList.count>=1) {
                weakSelf.nullPageView.hidden = YES;
                weakSelf.showCollectionView.videoModelArray = [NSMutableArray arrayWithArray:posterList];
                [weakSelf.showCollectionView reloadData];
                [weakSelf.showCollectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
            }else{
                weakSelf.nullPageView.hidden = NO;
            }
        }else{
            if (weakSelf.showCollectionView.videoModelArray.count == 0) {
                weakSelf.nullPageView.hidden = NO;
            }else{
                [HMDProgressHub showMessage:@"网络异常,加载失败" hideAfter:2.0];
            }
            
        }
    }];
}

//获取视频列表
-(void)addMoreVideoList{
    self.curPage++;
    HMDWeakSelf(self)
    [self.filterDict setObject:[NSString stringWithFormat:@"%ld",(long)self.curPage] forKey:@"page"];
    [self.videoDao getPostListWithParameters:self.filterDict finishBlock:^(BOOL success, NSArray *posterList) {

        if (success) {
            if (posterList.count>=1) {
                [weakSelf.showCollectionView.mj_footer endRefreshing];
                weakSelf.nullPageView.hidden = YES;
                [weakSelf.showCollectionView.videoModelArray addObjectsFromArray:posterList];
                [weakSelf.showCollectionView reloadData];
            }else{
                [weakSelf.showCollectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [weakSelf.showCollectionView.mj_footer endRefreshing];
            [HMDProgressHub showMessage:@"加载更多数据失败,请稍后再试" hideAfter:1.5];
        }
    }];
}
#pragma mark - 点击
//更新筛选词汇
-(void)reloadVideoDateWithClassify:(NSString *)classify type:(HMDClassifyType)type{
    NSString *key = [self getFilterKeyWithTag:type+100];
    BOOL selected = NO;
    if (classify == nil) {
        //类型包含videtype和Genre要一起清除
        if ([key isEqualToString:@"genre"]|| [key isEqualToString:@"videoType"]) {
            if ([[self.filterDict allKeys]containsObject:@"genre"]){
                [self.filterDict removeObjectForKey:@"genre"];
            }
            if ([[self.filterDict allKeys]containsObject:@"videoType"]){
                [self.filterDict removeObjectForKey:@"videoType"];
            }
        }else if ([[self.filterDict allKeys]containsObject:key]) {
            
            [self.filterDict removeObjectForKey:key];
        }
        selected = YES;
    }else{
        [self.filterDict setObject:classify forKey:key];
    }
    
    switch (type) {
        case HMDClassifyCategoryType:
            self.allCategoryClassifyBtn.selected = selected;
            break;
        case HMDClassifyLocationType:
            self.allLocationClassifyBtn.selected = selected;
            break;
        case HMDClassifyYearType:
            self.allYearClassifyBtn.selected = selected;
            break;
        default:
            break;
    }
    self.curPage = 0;
    [self getVideoList];
}

//全选
- (IBAction)selectAllClassify:(UIButton *)sender {
    sender.selected = YES;
    NSString *key = [self getFilterKeyWithTag:sender.tag];
    if ([[self.filterDict allKeys]containsObject:key]) {
        [self.filterDict removeObjectForKey:key];
    }
    switch (sender.tag) {
        case 104:
        {
            self.categoryCollectionView.curIndexPath = nil;
            [self.categoryCollectionView reloadData];
        }
            break;
        case 105:
        {
            self.locationCollectionView.curIndexPath = nil;
            [self.locationCollectionView reloadData];
        }
            break;
        case 106:
        {
            self.yearCollectionView.curIndexPath = nil;
            [self.yearCollectionView reloadData];
        }
            break;
        default:
            break;
    }
    self.curPage = 0;
    [self getVideoList];
}

//排序类型
- (IBAction)changeSortType:(UIButton *)sender {
    if (sender == self.curSortBtn) {
        return;
    }else{
        self.curPage = 0;
        self.curSortBtn.selected = NO;
        sender.selected = YES;
        self.curSortBtn = sender;
        switch (sender.tag) {
            case 101:
                [self.filterDict setObject:@"t_year" forKey:kOrder];
                [self.filterDict setObject:@"DESC" forKey:@"mode"];
                break;
            case 102:
                [self.filterDict setObject:@"s_name,title" forKey:kOrder];
                [self.filterDict setObject:@"ASC" forKey:@"mode"];
                break;
            case 103:
                [self.filterDict setObject:@"rating" forKey:kOrder];
                [self.filterDict setObject:@"DESC" forKey:@"mode"];
                break;
            default:
                break;
        }
    }

    [self getVideoList];
}
//重新加载分类
- (IBAction)reloadClassify:(id)sender {
    [self getPosterCategory];
    [self getVideoList];
}

#pragma mark - 其他
//获得key
-(NSString *)getFilterKeyWithTag:(NSInteger)tag{
    NSString *key = @"order";
    switch (tag) {
        case 104:
            key = @"genre";
            break;
        case 105:
            key = @"country";
            break;
        case 106:
            key = @"t_year";
            break;
        case 107:
            key = @"videoType";
            break;
        default:
            break;
    }
    return key;
}

#pragma mark - 懒加载
-(HMDVideoDataDao *)videoDao{
    if (_videoDao == nil) {
        _videoDao = [[HMDVideoDataDao alloc] init];
    }
    return _videoDao;
}

-(NSMutableDictionary *)filterDict{
    if (_filterDict == nil) {
        _filterDict = [NSMutableDictionary dictionary];
    }
    return _filterDict;
}
@end
