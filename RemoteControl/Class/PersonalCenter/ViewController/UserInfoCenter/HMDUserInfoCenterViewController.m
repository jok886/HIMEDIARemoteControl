//
//  HMDUserInfoCenterViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/18.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDUserInfoCenterViewController.h"
#import "HMDUserInfoTableViewCell.h"
#import "AppDelegate.h"
#import "HMDMainLoadingView.h"
#import "HMDUserModel.h"
#import <WXApi.h>
#import "HMDUpUserInfoDao.h"
#import "HMDImageCropperViewController.h"
#import "HMDResetNickNameViewController.h"
#import "HMDRecoveredPWDViewController.h"
#import "AppDelegate.h"
@interface HMDUserInfoCenterViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
HMDImageCropperDelegate,
HMDResetNickNameDelegate>
@property (strong, nonatomic) HMDUserModel *userModel;
@property (nonatomic,strong) UIImagePickerController *imagePickerController;                    //相册
@property (weak, nonatomic) IBOutlet HMDMainLoadingView *loadingView;
@property (nonatomic,strong) HMDUpUserInfoDao *userInfoDao;
@property (weak, nonatomic) IBOutlet UITableView *userInfoTableView;

@end

@implementation HMDUserInfoCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化
-(void)setupUI{
    [self setupFirstNavBar];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.userModel = myDelegate.userModel;
}
#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMDUserInfoTableViewCell *cell = [HMDUserInfoTableViewCell hmd_viewFromXib];
    switch (indexPath.row) {
        case 0:
            [cell setCellWithTitle:@"头像" subTitle:nil imageurl:self.userModel.headimgurl];
            break;
        case 1:
            [cell setCellWithTitle:@"昵称" subTitle:self.userModel.nickname imageurl:nil];
            break;
        case 2:
            [cell setCellWithTitle:@"修改密码" subTitle:nil imageurl:nil];
            break;
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self resetHeadImageView];
            break;
        case 1:
            [self resetNickName];
            break;
        case 2:
            [self resetPWD];
            break;
        default:
            break;
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    CGFloat width = (HMDScreenW -100);
    CGFloat y = (HMDScreenH - width)*0.5;
    HMDImageCropperViewController *imgEditorVC = [[HMDImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(50, y, width, width) limitScaleRatio:3.0];
    imgEditorVC.delegate = self;
    [self.imagePickerController dismissViewControllerAnimated:NO completion:^{
        
    }];

    [self presentViewController:imgEditorVC animated:YES completion:^{
        
    }];
}

#pragma mark - HMDImageCropperDelegate
- (void)imageCropper:(HMDImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
//    self.portraitImageView.image = editedImage;
    NSData *data = UIImageJPEGRepresentation(editedImage,1);
    NSLog(@"data.length*___%ld",data.length);
    if (data.length>1024 * 50) {
        CGFloat scale = 1024 *50/(CGFloat)data.length;
        data = UIImageJPEGRepresentation(editedImage,scale);
        NSLog(@"scale____%f",scale);
    }
    NSLog(@"data.length___%ld",data.length);
    HMDWeakSelf(self)
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        [weakSelf startUploadAvatar:data];
    }];

}

- (void)imageCropperDidCancel:(HMDImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - HMDResetNickNameDelegate
-(void)resetNickNameViewController:(HMDResetNickNameViewController *)resetNickNameViewController resetNickName:(NSString *)nickName{
    self.userModel.nickname = nickName;
    [self.userInfoTableView reloadData];
}
#pragma mark - 点击
//重设头像
-(void)resetHeadImageView{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"更换头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * actionPhotograph = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction * actionAlbum = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertC addAction:actionPhotograph];
    [alertC addAction:actionAlbum];
    [alertC addAction:actionCancel];
    [self presentViewController:alertC animated:YES completion:nil];
}

//重设昵称
-(void)resetNickName{
        HMDResetNickNameViewController *resetNickNameVC = [[UIStoryboard storyboardWithName:@"HMDUserInfoCenterViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HMDResetNickNameViewController"];
//    resetNickNameVC.delegate = self;
        [self.navigationController pushViewController:resetNickNameVC animated:YES];
}

//重设密码
-(void)resetPWD{
    HMDRecoveredPWDViewController *recoveredPWDVC = [[HMDRecoveredPWDViewController alloc] init];
    recoveredPWDVC.resetPWD = YES;
    [self.navigationController pushViewController:recoveredPWDVC animated:YES];
    
}

//退出登录
- (IBAction)signoutBtnClick:(UIButton *)sender {

        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"确认退出当前登录?" message:@"退出后部分功能受限制" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction * actionClear = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:HMDSignout object:nil];
            [self dismissAction:nil];
        }];
        [alertC addAction:actionCancel];
        [alertC addAction:actionClear];
        [self presentViewController:alertC animated:YES completion:nil];

    
}
#pragma mark - 其他
-(void)dismissAction:(UIButton *)sender{
    [super dismissAction:sender];
    [HMDLinkView sharedInstance].hidden = NO;
}
//上传头像
-(void)startUploadAvatar:(NSData *)imageData{
    [self.loadingView startLoading];
    HMDWeakSelf(self)
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:HMDLoginPhoneNum];
    [self.userInfoDao uploadAvatarWithPhone:phoneNum imageData:imageData finishBlock:^(BOOL success, NSString *imageURL) {
        [weakSelf.loadingView endLoading];
        if (success) {
            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            HMDUserModel *userModel = myDelegate.userModel;
            userModel.headimgurl = imageURL;
            weakSelf.userModel.headimgurl = imageURL;
            [weakSelf.userInfoTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:HMDLogin object:userModel];
            [HMDProgressHub showMessage:@"修改成功" hideAfter:2.0];
        }else{
            [HMDProgressHub showMessage:@"网络异常,稍后再试" hideAfter:2.0];
        }
    }];
}
#pragma mark - 懒加载
-(UIImagePickerController *)imagePickerController{
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _imagePickerController.allowsEditing = NO;
    }
    return _imagePickerController;
}

-(HMDUpUserInfoDao *)userInfoDao{
    if (_userInfoDao == nil) {
        _userInfoDao = [[HMDUpUserInfoDao alloc] init];
    }
    return _userInfoDao;
}
@end
