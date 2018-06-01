//
//  HMDRemoteSettingViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/10.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDRemoteSettingViewController.h"
#import "AppDelegate.h"

@interface HMDRemoteSettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sideKeyControlBtn;
@property (weak, nonatomic) IBOutlet UIButton *shockBtn;
@property (weak, nonatomic) IBOutlet UILabel *memorySizeLab;
@property (weak, nonatomic) IBOutlet UIView *memoryView;


@end

@implementation HMDRemoteSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.needSetNav) {
        [self setupFirstNavBar];
    }
    [self setupUI];
 
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 初始化
-(void)setupUI{
    self.title = @"系统设置";
    BOOL openSideKey = [[NSUserDefaults standardUserDefaults] boolForKey:OPENSIDEKEY];
    self.sideKeyControlBtn.selected = openSideKey;
    BOOL openShock = [[NSUserDefaults standardUserDefaults] boolForKey:OPENSHOCK];
    self.shockBtn.selected = openShock;
    self.memorySizeLab.text = [self getMemorySize];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearMemory:)];
    [self.memoryView addGestureRecognizer:tapGesture];

}

//内存
-(NSString *)getMemorySize{
    long long ttotalSize = 0;
    ttotalSize = [self cacheSizeWithPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]];
    ttotalSize += [self cacheSizeWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    //视频的缓存
    
    ttotalSize = ttotalSize/1024;
    return ttotalSize<1024?[NSString stringWithFormat:@"%lld KB",ttotalSize]:[NSString stringWithFormat:@"%.1f MB",(CGFloat)ttotalSize/1024];
}
//计算内存
-(long long)cacheSizeWithPath:(NSString *)filePath{
    long long ttotalSize = 0;
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSArray *subpaths = [mgr subpathsAtPath:filePath];
    for (NSString *subpath in subpaths) {
        //忽略jrdb和Video相关的
        if ([subpath containsString:@"HMDDocument"]) {

            continue ;
        }
        NSString *fullpath = [filePath stringByAppendingPathComponent:subpath];
        BOOL dir = NO;
        [mgr fileExistsAtPath:fullpath isDirectory:&dir];
        if (dir == NO) {// 文件
            ttotalSize += [[mgr attributesOfItemAtPath:fullpath error:nil][NSFileSize] longLongValue];
        }
    }//  M
    return ttotalSize;
}
//清理缓存
-(void)deleateCache{
    //清除NSCachesDirectory的缓存文件
    [self deleateCacheWithFilePath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]];
    [self deleateCacheWithFilePath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
}
- (void)deleateCacheWithFilePath:(NSString *)filePath{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:filePath];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
//            //忽略HMDDocument相关的
            if ([fileName containsString:@"HMDDocument"]) {
                continue ;
            }
            NSString *absolutePath=[filePath stringByAppendingPathComponent:fileName];
            NSError *error;
            BOOL move = [fileManager removeItemAtPath:absolutePath error:&error];
            NSLog(@"删除%d__%@",move,error);
        }
    }
}

#pragma mark - 按键/点击
//是否打开侧键控制
- (IBAction)switchVolumControl:(UIButton *)sender {
    self.sideKeyControlBtn.selected = !self.sideKeyControlBtn.selected;
    [[NSUserDefaults standardUserDefaults] setBool:self.sideKeyControlBtn.selected forKey:OPENSIDEKEY];
}
//震动
- (IBAction)changeShock:(UIButton *)sender {
    self.shockBtn.selected = !self.shockBtn.selected;
    [[NSUserDefaults standardUserDefaults] setBool:self.shockBtn.selected forKey:OPENSHOCK];
}
//清理缓存
-(void)clearMemory:(UITapGestureRecognizer *)tap{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"是否清理手机缓存" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }];
    UIAlertAction * actionClear = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self deleateCache];
        self.memorySizeLab.text = [self getMemorySize];
    }];
    [alertC addAction:actionCancel];
    [alertC addAction:actionClear];
    [self presentViewController:alertC animated:YES completion:nil];
}


#pragma mark - 其他

@end
