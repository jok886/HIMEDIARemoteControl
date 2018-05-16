//
//  HMDRemoteSettingViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/10.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDRemoteSettingViewController.h"
#import "AppDelegate.h"
#import <WXApi.h>
@interface HMDRemoteSettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sideKeyControlBtn;
@property (weak, nonatomic) IBOutlet UIButton *shockBtn;
@property (weak, nonatomic) IBOutlet UILabel *memorySizeLab;
@property (weak, nonatomic) IBOutlet UIView *memoryView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation HMDRemoteSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self addNotification];
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
    BOOL openSideKey = [[NSUserDefaults standardUserDefaults] boolForKey:OPENSIDEKEY];
    self.sideKeyControlBtn.selected = openSideKey;
    BOOL openShock = [[NSUserDefaults standardUserDefaults] boolForKey:OPENSHOCK];
    self.shockBtn.selected = openShock;
    self.memorySizeLab.text = [self getMemorySize];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearMemory:)];
    [self.memoryView addGestureRecognizer:tapGesture];

    if ([[NSUserDefaults standardUserDefaults] boolForKey:HMDLoginState]){
        self.loginBtn.selected = YES;
    }else{
        self.loginBtn.selected = NO;
    }

}
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:HMDWechatLogin object:nil];
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
//        //忽略jrdb和Video相关的
//        if ([subpath containsString:@"jrdb"]||[subpath containsString:@"Draft"]||[subpath containsString:@"SpecialEffects"]) {
//
//            continue ;
//        }
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
//            //忽略jrdb和Draft相关的
//            if ([fileName containsString:@"jrdb"]||[fileName containsString:@"Draft"]||[fileName containsString:@"SpecialEffects"]) {
//                continue ;
//            }
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
    sender.selected = !sender.selected;
    [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:OPENSIDEKEY];
}
//震动
- (IBAction)changeShock:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:OPENSHOCK];
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
//退出登录
- (IBAction)signoutBtnClick:(UIButton *)sender {
    if(sender.selected){
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"确认退出当前登录?" message:@"退出后部分功能受限制" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction * actionClear = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:HMDWechatSignout object:nil];
            self.loginBtn.selected = NO;
        }];
        [alertC addAction:actionCancel];
        [alertC addAction:actionClear];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
        SendAuthReq *req = [[SendAuthReq alloc]init];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"wx_oauth2_authorization_state" ;
        [WXApi sendReq:req];
    }

}

#pragma mark - 其他
-(void)loginSuccess:(NSNotification *)info{
     self.loginBtn.selected = YES;
}
@end
