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
#import "HMDTVRemoteViewController.h"
#import <MJRefresh/MJRefresh.h>

#import "HMDSearchTVDao.h"
#import "HMDVideoDataDao.h"
@interface HMDSearchTVViewController ()<UITextFieldDelegate,HMDSearchTVResultCollectionViewDelegate>

@property (nonatomic,weak) HMDSearchHeadView *searchHeadView;                                           //搜索界面
@property (nonatomic,weak) IBOutlet HMDSearchTVResultCollectionView *searchTVResultCollectionView;      //搜索结果展示
@property (nonatomic,weak) IBOutlet HMDSearchTVTipsCollectionView *searchTVTipsCollectionView;          //搜索提示

@property (nonatomic,strong) HMDSearchTVDao *searchTVDao;
@property (nonatomic,strong) HMDVideoDataDao *videoDataDao;
@property (nonatomic,assign) NSInteger curPage;                                                         //当前页码
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
    backButton.frame = CGRectMake(0, 0, 60, 40);
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
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
    searchButton.frame = CGRectMake(0, 0, 40, 40);
    searchButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
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
        self.searchTVTipsCollectionView.recordArray = [NSMutableArray arrayWithArray:searchWordHistoryArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.searchTVResultCollectionView.tvModelArray = nil;
        [self.searchTVResultCollectionView reloadData];
        [self.searchHeadView.searchTextField resignFirstResponder];
        self.searchTVTipsCollectionView.hidden = YES;
        self.searchTVResultCollectionView.hidden = NO;
        HMDWeakSelf(self)
        self.curPage = 1;
        [self.searchTVDao searchTVWithKeyWord:keyWord page:self.curPage FinishBlock:^(BOOL success, NSArray *searchArray) {
            if (success) {
                weakSelf.searchTVResultCollectionView.tvModelArray = [NSMutableArray arrayWithArray:searchArray];
                [weakSelf.searchTVResultCollectionView reloadData];
                if (searchArray.count<12) {
                    weakSelf.searchTVResultCollectionView.mj_footer = nil;
                }
            }
        }];
        self.searchTVResultCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakSelf addMoreTVWithKeyWord:keyWord];
        }];
    }
}

-(void)addMoreTVWithKeyWord:(NSString *)keyWord{
    self.curPage++;
    HMDWeakSelf(self)
    [self.searchTVDao searchTVWithKeyWord:keyWord page:self.curPage FinishBlock:^(BOOL success, NSArray *searchArray) {
        [weakSelf.searchTVResultCollectionView.mj_footer endRefreshing];
        if (success) {
            if (searchArray.count == 0) {
                weakSelf.searchTVResultCollectionView.mj_footer= nil;
                [HMDProgressHub showMessage:@"没有更多数据了" hideAfter:2.0];
            }else{
                [weakSelf.searchTVResultCollectionView.tvModelArray addObjectsFromArray:searchArray];
                [weakSelf.searchTVResultCollectionView reloadData];
            }

        }else{
            NSLog(@"");
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
    //判断当前是否链接
    if ([HMDLinkView sharedInstance].linkViewState == HMDLinkViewStateLinked) {
            HMDWeakSelf(self)
            [self.videoDataDao PostPlayNetPosterOrder:videoModel finishBlock:^(BOOL success) {
                if (success) {
                    [HMDLinkView sharedInstance].hidden = YES;
                    HMDTVRemoteViewController *remoteViewController = [[HMDTVRemoteViewController alloc] init];
                    remoteViewController.showLinkViewWhenDismiss = YES;

                    HMDNavigationController *nav = [[HMDNavigationController alloc] initWithRootViewController:remoteViewController];
                    [weakSelf presentViewController:nav animated:YES completion:nil];
                }
            }];

    }else{
        [HMDProgressHub showMessage:@"请先链接设备" hideAfter:2.0];
    }

}
#pragma mark - 点击
-(void)backAction:(UIButton *)sender{

    if (self.searchTVTipsCollectionView.hidden){
        self.searchTVTipsCollectionView.hidden = NO;
        self.searchTVResultCollectionView.hidden = YES;
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
