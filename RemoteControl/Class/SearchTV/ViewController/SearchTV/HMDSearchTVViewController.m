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

@property (nonatomic,weak) HMDSearchHeadView *searchHeadView;                                           //搜索界面
@property (nonatomic,weak) IBOutlet HMDSearchTVResultCollectionView *searchTVResultCollectionView;      //搜索结果展示
@property (nonatomic,weak) IBOutlet HMDSearchTVTipsCollectionView *searchTVTipsCollectionView;          //搜索提示

@property (nonatomic,strong) HMDSearchTVDao *searchTVDao;
@property (nonatomic,strong) HMDVideoDataDao *videoDataDao;
@end

@implementation HMDSearchTVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupCollectionView];
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
    searchHeadView.frame = CGRectMake(45, 3, HMDScreenW-100, 37);
    searchHeadView.searchTextField.delegate = self;
    self.searchHeadView = searchHeadView;
    [self.navigationController.navigationBar addSubview:searchHeadView];
    
    //搜索按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setTitle:@"取消" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchButton sizeToFit];
    // 设置返回按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}

-(void)setupCollectionView{
    HMDWeakSelf(self)
    self.searchTVTipsCollectionView.hidden = YES;
    self.searchTVTipsCollectionView.searchTVTipBlock = ^(NSString *keyWord) {
        weakSelf.searchHeadView.searchTextField.text = keyWord;
        [weakSelf searchTVWithKeyWord:keyWord];
    };
    self.searchTVTipsCollectionView.scrollViewWillBeginDraggingBlock = ^{
        if ([weakSelf.searchHeadView.searchTextField isFirstResponder]) {
            [weakSelf.searchHeadView.searchTextField resignFirstResponder];
        }
        
    };
    
    
    self.searchTVResultCollectionView.hidden = YES;
    self.searchTVResultCollectionView.searchDelegate = self;
}
#pragma mark - 网络
//获取搜索提示
-(void)getHotSearchTip{
    NSArray *recordArray = [[NSUserDefaults standardUserDefaults] objectForKey:HMDSearchWordHistory];
    if (recordArray.count>0) {
        self.searchTVTipsCollectionView.hidden = NO;
        self.searchTVTipsCollectionView.recordArray = [NSMutableArray arrayWithArray:recordArray];
        self.searchTVTipsCollectionView.searchTVTipsType = HMDSearchTVRecordAndHotTipsType;
        [self.searchTVTipsCollectionView reloadData];
    }
    HMDWeakSelf(self)
    [self.searchTVDao searchTVHotTipWithFinishBlock:^(BOOL success, NSArray *searchArray) {
        if (success) {
            weakSelf.searchTVTipsCollectionView.hidden = NO;
            weakSelf.searchTVTipsCollectionView.hotArray = [NSArray arrayWithArray:searchArray];
            weakSelf.searchTVTipsCollectionView.searchTVTipsType = HMDSearchTVRecordAndHotTipsType;
            [weakSelf.searchTVTipsCollectionView reloadData];
        }
    }];
}
//联动
-(void)getSearchTips:(NSString *)keyWord{

    if (keyWord.length >0) {
        HMDWeakSelf(self)
        [self.searchTVDao searchTVTipWithKeyWord:keyWord FinishBlock:^(BOOL success, NSArray *searchArray) {
            if (success) {
                weakSelf.searchTVTipsCollectionView.searchTVTipsType = HMDSearchTVRecommendTipsType;
                weakSelf.searchTVTipsCollectionView.hidden = NO;
                if (searchArray.count>=1) {
                    weakSelf.searchTVTipsCollectionView.curKeyWord = keyWord;
                    weakSelf.searchTVTipsCollectionView.recommendArray = [NSArray arrayWithArray:searchArray];
                    [weakSelf.searchTVTipsCollectionView reloadData];
                }
            }
        }];
    }

}

//获得视频列表
-(void)searchTVWithKeyWord:(NSString *)keyWord{
    if (keyWord.length>=1) {
        NSMutableArray *searchWordHistoryArray = [NSMutableArray array];
        NSArray *recordArray = [[NSUserDefaults standardUserDefaults] objectForKey:HMDSearchWordHistory];
        if (recordArray) {
            [searchWordHistoryArray addObjectsFromArray:recordArray];
        }
        if(![searchWordHistoryArray containsObject:keyWord]){
            [searchWordHistoryArray addObject:keyWord];
            [[NSUserDefaults standardUserDefaults] setObject:searchWordHistoryArray forKey:HMDSearchWordHistory];
        }else{
            [searchWordHistoryArray removeObject:keyWord];
            [searchWordHistoryArray insertObject:keyWord atIndex:0];
            [[NSUserDefaults standardUserDefaults] setObject:searchWordHistoryArray forKey:HMDSearchWordHistory];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
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
//-(void)textFieldDidEndEditing:(UITextField *)textField{
//
//}
//清空
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    //展现默认提示
    textField.text = nil;
    self.searchTVTipsCollectionView.recommendArray = nil;
    self.searchTVTipsCollectionView.searchTVTipsType = HMDSearchTVRecordAndHotTipsType;
    [self.searchTVTipsCollectionView reloadData];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{
    NSInteger curLength = textField.text.length - range.length + string.length;
    if (curLength > 0){
        NSString *newKeyWord = [textField.text stringByReplacingCharactersInRange:range withString:string];
        [self getSearchTips:newKeyWord];
    }else{
        self.searchTVTipsCollectionView.recommendArray = nil;
        self.searchTVTipsCollectionView.searchTVTipsType = HMDSearchTVRecordAndHotTipsType;
        [self.searchTVTipsCollectionView reloadData];
    }
    return YES;
}
//按确认键
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    [self searchTVWithKeyWord:textField.text];
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
        self.searchTVTipsCollectionView.searchTVTipsType = HMDSearchTVRecordAndHotTipsType;
        [self.searchTVTipsCollectionView reloadData];
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
            self.searchTVTipsCollectionView.searchTVTipsType = HMDSearchTVRecordAndHotTipsType;
            [self.searchTVTipsCollectionView reloadData];
            [self.searchHeadView.searchTextField resignFirstResponder];
            self.searchHeadView.searchTextField.text = nil;
        }else{
            [self.searchHeadView.searchTextField resignFirstResponder];
        }
    }


}

#pragma mark - 其他
//-(void)reloadSearchTVTipsCollectionViewData{
//    if (self.searchTVTipsCollectionView.recommendArray.count >0) {
//        self.searchTVTipsCollectionView.searchTVTipsType = HMDSearchTVRecommendTipsType;
//    }else{
//        self.searchTVTipsCollectionView.searchTVTipsType = HMDSearchTVRecordAndHotTipsType;
//
//    }
//    [self.searchTVTipsCollectionView reloadData];
//}
#pragma mark - 懒加载

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
