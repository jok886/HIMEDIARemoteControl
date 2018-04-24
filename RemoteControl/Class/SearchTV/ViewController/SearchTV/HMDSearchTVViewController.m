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


@interface HMDSearchTVViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *showView;              //搜索/提示的展示位

@property (nonatomic,weak) HMDSearchHeadView *searchHeadView;               //搜索界面
@property (nonatomic,weak) HMDSearchTVResultCollectionView *searchTVResultCollectionView;               //搜索结果展示
@property (nonatomic,weak) HMDSearchTVTipsCollectionView *searchTVTipsCollectionView;                   //搜索提示
@end

@implementation HMDSearchTVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupUI];
    [self getSearchTip];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark -初始化
-(void)setupUI{
    [self setupSearchTVTipsCollectionView];
}
//搜索提示
-(void)setupSearchTVTipsCollectionView{

    HMDSearchTVTipsCollectionView *searchTVTipsCollectionView = [HMDSearchTVTipsCollectionView searchTVTipsCollectionViewWithFrame:CGRectMake(0, 0, HMDScreenW-20, HMDScreenH-HMDSTATUSBARMAXY-LINKVIEHIGHT-44)];
    [self.showView addSubview:searchTVTipsCollectionView];
}



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
-(void)getSearchTip{
    
}

#pragma mark - UITextFieldDelegate

#pragma mark - 点击
-(void)backAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelAction:(UIButton *)sender{
    
}
@end
