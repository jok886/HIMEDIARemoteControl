//
//  HMDScrollTitleViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/2.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDScrollTitleViewController.h"
#import "HMDTitleBaseLine.h"

@interface HMDScrollTitleViewController ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *titleScrollView;               //标题背景
@property (nonatomic,weak) HMDTitleBaseLine *bottomLine;                //标题下划线
@property (nonatomic,assign) BOOL isInitial;                            //是否初始化
@property (nonatomic,strong) NSMutableArray *titleBtnArray;             //按钮合集
@property (nonatomic,strong) UIButton *curSelectBtn;                    //当前选中的按钮
@end

@implementation HMDScrollTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConst];
    [self setupUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.frame = self.viewFrame;
    if (_isInitial == NO) {
        [self setupAllTitleButton];
        _isInitial = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -初始化
//基本参数
-(void)setupConst{
    if (self.btnH == 0 && self.btnW == 0) {
        self.autoLayoutBtn = YES;
    }
    if (self.selectColor == nil) {
        self.selectColor = HMDColorFromValue(0xFFA500);
    }
    self.view.frame = self.viewFrame;
}
//基本UI
-(void)setupUI{
    if (self.titleArray.count>0) {
        if (self.titleScrollView == nil) {
            UIScrollView *titleScrollView = [[UIScrollView alloc] init];
            titleScrollView.frame = self.view.bounds;
            [self.view addSubview:titleScrollView];
            self.titleScrollView = titleScrollView;
            self.titleScrollView.showsHorizontalScrollIndicator = NO;
            self.titleScrollView.bounces = NO;
        }
    }
}
//按键
-(void)setupAllTitleButton{
    //如果之前初始化过一次,需要清空
    if (self.isInitial) {
        for (UIView *subView in self.view.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                [subView removeFromSuperview];
            }
        }
    }
    //初始化按键
    
    NSInteger count = self.titleArray.count;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    //基本的尺寸
    CGFloat btnW = self.btnW;
    CGFloat btnH = self.btnH;
    if (self.autoLayoutBtn) {
        btnW = 100;
        btnH = self.view.bounds.size.height;
    }
        
    for (int i = 0; i < count; i++) {
        // 创建按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        NSString *title = self.titleArray[i];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleScrollView addSubview:btn];
        if (self.autoLayoutBtn) {
//            CGRect frame = btn.frame;
            [btn sizeToFit];
            CGRect newFrame = btn.frame;
            CGFloat newBtnW = newFrame.size.width + 15;
            btn.frame = CGRectMake(btnX, btnY, newBtnW, btnH);
            btnX += newBtnW;
        }else{
            btnX = i * btnW;
        }
        if (i == 0) {
            [self titleClick:btn];
        }
        
        [self.titleBtnArray addObject:btn];
        
    }
    //下划线
    CGFloat y = CGRectGetHeight(self.view.frame);
    HMDTitleBaseLine *bottomLine = [[HMDTitleBaseLine alloc]initWithFrame:CGRectMake(0, y-1, 100, 1)];
    [self.titleScrollView addSubview:bottomLine];
    self.bottomLine = bottomLine;
    //当总宽度小于一个视图宽度的时候平铺布局
    CGFloat viewW = CGRectGetWidth(self.view.frame);
    if (btnX <viewW) {
        [self resetBtnFrame];
    }
    // 设置titleScrollView滚动范围

    self.titleScrollView.contentSize = CGSizeMake(btnX, 0);
    // 清空水平指示条
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
}

-(void)resetBtnFrame{
    CGFloat viewW = CGRectGetWidth(self.view.frame);
    CGFloat btnW = (CGFloat)(viewW/self.titleBtnArray.count);
    CGFloat x = 0;
    CGFloat btnH = 0;
    for (int i = 0; i <self.titleBtnArray.count; i++) {
        UIButton *btn = self.titleBtnArray[i];
        if (i == 0) {
            btnH = CGRectGetHeight(btn.frame);
        }
        btn.frame = CGRectMake(x, 0, btnW, btnH);
        x += btnW;
    }
    //下划线
    if (self.curSelectBtn) {
        CGRect lineFrame = self.bottomLine.frame;
        lineFrame.size.width = CGRectGetWidth(self.curSelectBtn.frame)-20;
        lineFrame.origin.x = CGRectGetMinX(self.curSelectBtn.frame)+10;
        self.bottomLine.frame = lineFrame;
    }

}
#pragma mark -点击事件
-(void)titleClick:(UIButton *)sender{

    // 选中按钮
    [self selectButton:sender];
    
    NSInteger index = sender.tag;
    
    // 执行对于代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidSelectItemAtIndex:)]) {
        [self.delegate scrollViewDidSelectItemAtIndex:index];
    }
    
}

-(void)selectButton:(UIButton *)sender{
    // 恢复上一个按钮选中标题
    if (_curSelectBtn) {
        [_curSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _curSelectBtn.transform = CGAffineTransformIdentity;
        
    }
    [sender setTitleColor:self.selectColor forState:UIControlStateNormal];
    // 标题居中显示:本质就是设置偏移量
    CGFloat viewW = CGRectGetWidth(self.view.frame);
    CGFloat offsetX = sender.center.x - viewW * 0.5;
    // 处理最大偏移量
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - viewW;
    if (maxOffsetX > 0) {
        if (offsetX <= 0) {
            offsetX = 0;
        }
        
        if (offsetX > maxOffsetX && maxOffsetX >0) {
            offsetX = maxOffsetX;
        }
        [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }

    
    // 标题缩放 -> 如何让标题缩放 改形变
//    sender.transform = CGAffineTransformMakeScale(1.3, 1.3);
    
    self.curSelectBtn = sender;
    //下划线
    CGRect lineFrame = self.bottomLine.frame;
    lineFrame.size.width = CGRectGetWidth(sender.frame)-20;
    lineFrame.origin.x = CGRectGetMinX(sender.frame)+10;
    self.bottomLine.frame = lineFrame;
    
}
#pragma mark -API
//初始化界面
-(void)setupUIWithTitleArray:(NSArray *)titleArray{
    self.titleArray = [NSMutableArray arrayWithArray:titleArray];
    [self setupUI];
    [self setupAllTitleButton];
}
-(void)btnClickAtIndex:(NSInteger)index{
    if (index < self.titleBtnArray.count) {
        UIButton *btn = self.titleBtnArray[index];
        [self selectButton:btn];
    }
}
#pragma mark -懒加载
-(NSMutableArray *)titleBtnArray{
    if (_titleBtnArray == nil) {
        _titleBtnArray = [NSMutableArray array];
    }
    return _titleBtnArray;
}
@end
