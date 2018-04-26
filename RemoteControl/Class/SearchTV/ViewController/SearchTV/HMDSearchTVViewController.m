//
//  HMDSearchTVViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/11.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDSearchTVViewController.h"
#import "HMDSearchHeadView.h"

#import "HMDSearchTVResultCollectionView.h"
#import "HMDSearchTVTipsCollectionView.h"

#import "HMDSearchTVDao.h"
#import "HMDVideoDataDao.h"
@interface HMDSearchTVViewController ()<UITextFieldDelegate,HMDSearchTVResultCollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *showView;                                                  //搜索/提示的展示位

@property (nonatomic,weak) HMDSearchHeadView *searchHeadView;                                           //搜索界面
@property (nonatomic,weak) HMDSearchTVResultCollectionView *searchTVResultCollectionView;               //搜索结果展示
@property (nonatomic,weak) HMDSearchTVTipsCollectionView *searchTVTipsCollectionView;                   //搜索提示

@property (nonatomic,strong) HMDSearchTVDao *searchTVDao;
@property (nonatomic,strong) HMDVideoDataDao *videoDataDao;
@end

@implementation HMDSearchTVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self getHotSearchTip];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark -初始化
-(void)setupNavigation{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompact];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"btn_back_wbg"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"btn_back_wbg"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    //搜索框
    HMDSearchHeadView *searchHeadView = [HMDSearchHeadView hmd_viewFromXib];
    searchHeadView.frame = CGRectMake(45, 0, HMDScreenW-100, 44);
    searchHeadView.searchTextField.delegate = self;
    self.searchHeadView = searchHeadView;
    [self.navigationController.navigationBar addSubview:searchHeadView];
    
    //搜索按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setTitle:@"取消" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];

    [searchButton  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchButton sizeToFit];
    // 设置返回按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}

#pragma mark - 网络
//获取搜索提示
-(void)getHotSearchTip{
    NSArray *recordArray = [[NSUserDefaults standardUserDefaults] objectForKey:HMDSearchWordHistory];
    if (recordArray.count>0) {
        self.searchTVTipsCollectionView.recordArray = [NSMutableArray arrayWithArray:recordArray];
        [self reloadSearchTVTipsCollectionViewData];
    }
    HMDWeakSelf(self)
    [self.searchTVDao searchTVHotTipWithFinishBlock:^(BOOL success, NSArray *searchArray) {
        if (success) {
            weakSelf.searchTVTipsCollectionView.hidden = NO;
            weakSelf.searchTVTipsCollectionView.hotArray = [NSArray arrayWithArray:searchArray];
            [weakSelf reloadSearchTVTipsCollectionViewData];
        }
    }];
}
//联动
-(void)getSearchTips:(NSString *)keyWord{

    if (keyWord.length >0) {
        HMDWeakSelf(self)
        NSMutableArray *searchWordHistoryArray = [NSMutableArray array];
        NSArray *recordArray = [[NSUserDefaults standardUserDefaults] objectForKey:HMDSearchWordHistory];
        if (recordArray) {
            [searchWordHistoryArray addObjectsFromArray:recordArray];
        }
        if(![searchWordHistoryArray containsObject:keyWord]){
            [searchWordHistoryArray addObject:keyWord];
            [[NSUserDefaults standardUserDefaults] setObject:searchWordHistoryArray forKey:HMDSearchWordHistory];
        }
        
        [self.searchTVDao searchTVTipWithKeyWord:keyWord FinishBlock:^(BOOL success, NSArray *searchArray) {
            if (success) {
                weakSelf.searchTVTipsCollectionView.hidden = NO;
                weakSelf.searchTVTipsCollectionView.recommendArray = [NSArray arrayWithArray:searchArray];
                [weakSelf reloadSearchTVTipsCollectionViewData];
            }
        }];
    }

}

//获得视频列表
-(void)searchTVWithKeyWord:(NSString *)keyWord{
    self.searchTVResultCollectionView.tvModelArray = nil;
    [self.searchTVResultCollectionView reloadData];
    [self.searchHeadView.searchTextField resignFirstResponder];
    self.searchTVTipsCollectionView.hidden = YES;
    self.searchTVResultCollectionView.hidden = NO;
    HMDWeakSelf(self)
    [self.searchTVDao searchTVWithKeyWord:keyWord page:1 FinishBlock:^(BOOL success, NSArray *searchArray) {
        if (success) {
            weakSelf.searchTVResultCollectionView.tvModelArray = [NSArray arrayWithArray:searchArray];
            [weakSelf.searchTVResultCollectionView reloadData];
        }
    }];
}
#pragma mark - UITextFieldDelegate
//开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.searchTVTipsCollectionView.hidden = NO;
    if (_searchTVResultCollectionView) {
        self.searchTVResultCollectionView.hidden = YES;
    }
}
//结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self searchTVWithKeyWord:textField.text];
}
//清空
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    //展现默认提示
    textField.text = nil;
    [self reloadSearchTVTipsCollectionViewData];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{
    NSInteger curLength = textField.text.length - range.length + string.length;
    if (curLength > 0){
        NSString *newKeyWord = [textField.text stringByReplacingCharactersInRange:range withString:string];
        [self getSearchTips:newKeyWord];
    }
    return YES;
}
//按确认键
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];

    return YES;
}

#pragma mark - HMDSearchTVResultCollectionViewDelegate
-(void)searchTVResultCollectionView:(HMDSearchTVResultCollectionView *)earchTVResultCollectionView didSelectItemWithModel:(HMDVideoModel *)videoModel{
    [self.videoDataDao PostPlayNetPosterOrder:videoModel finishBlock:^(BOOL success) {
        
    }];
}
#pragma mark - 点击
-(void)backAction:(UIButton *)sender{
    if (self.searchTVTipsCollectionView.searchTVTipsType == HMDSearchTVRecommendTipsType){
        self.searchTVTipsCollectionView.recommendArray = nil;
        [self reloadSearchTVTipsCollectionViewData];
        [self.searchHeadView.searchTextField resignFirstResponder];
        self.searchHeadView.searchTextField.text = nil;
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

-(void)cancelAction:(UIButton *)sender{
    if (self.searchTVTipsCollectionView.hidden){
        self.searchTVTipsCollectionView.hidden = NO;
        self.searchTVResultCollectionView.hidden = YES;
    }else{
        if (self.searchTVTipsCollectionView.searchTVTipsType == HMDSearchTVRecommendTipsType){
            self.searchTVTipsCollectionView.recommendArray = nil;
            [self reloadSearchTVTipsCollectionViewData];
            [self.searchHeadView.searchTextField resignFirstResponder];
            self.searchHeadView.searchTextField.text = nil;
        }else{
            [self.searchHeadView.searchTextField resignFirstResponder];
        }
    }


}

#pragma mark - 其他
-(void)reloadSearchTVTipsCollectionViewData{
    if (self.searchTVTipsCollectionView.recommendArray.count >0) {
        self.searchTVTipsCollectionView.searchTVTipsType = HMDSearchTVRecommendTipsType;
    }else{
        if (self.searchTVTipsCollectionView.hotArray.count > 0 && self.searchTVTipsCollectionView.recordArray.count > 0) {
            self.searchTVTipsCollectionView.searchTVTipsType = HMDSearchTVRecordAndHotTipsType;
        }else{
            if (self.searchTVTipsCollectionView.hotArray.count > 0 ) {
                self.searchTVTipsCollectionView.searchTVTipsType = HMDSearchTVHotTipsType;
            }else{
                self.searchTVTipsCollectionView.searchTVTipsType = HMDSearchTVRecordTipsType;
            }
        }
    }
    [self.searchTVTipsCollectionView reloadData];
}
#pragma mark - 懒加载
-(HMDSearchTVTipsCollectionView *)searchTVTipsCollectionView{
    if (_searchTVTipsCollectionView == nil) {
        _searchTVTipsCollectionView = [HMDSearchTVTipsCollectionView searchTVTipsCollectionViewWithFrame:CGRectMake(0, 0, HMDScreenW-20, HMDScreenH-HMDSTATUSBARMAXY-LINKVIEHIGHT-44)];
        HMDWeakSelf(self)
        _searchTVTipsCollectionView.searchTVTipBlock = ^(NSString *keyWord) {
            weakSelf.searchHeadView.searchTextField.text = keyWord;
            [weakSelf searchTVWithKeyWord:keyWord];
        };
        [self.showView addSubview:_searchTVTipsCollectionView];
    }
    return _searchTVTipsCollectionView;
}

-(HMDSearchTVResultCollectionView *)searchTVResultCollectionView{
    if (_searchTVResultCollectionView == nil) {
        _searchTVResultCollectionView = [HMDSearchTVResultCollectionView searchTVResultCollectionViewWithFrame:CGRectMake(0, 0, HMDScreenW-20, HMDScreenH-HMDSTATUSBARMAXY-LINKVIEHIGHT-44)];
        _searchTVResultCollectionView.searchDelegate = self;
        [self.showView addSubview:_searchTVResultCollectionView];
    }
    return _searchTVResultCollectionView;
}
-(HMDSearchTVDao *)searchTVDao{
    if (_searchTVDao == nil){
        _searchTVDao = [[HMDSearchTVDao alloc] init];
    }
    return _searchTVDao;
}

-(HMDVideoDataDao *)videoDataDao{
    if (_videoDataDao == nil){
        _videoDataDao = [[HMDVideoDataDao alloc] init];
    }
    return _videoDataDao;
}
@end
