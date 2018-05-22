//
//  HMDUserInfoTableViewCell.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/18.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDUserInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
-(void)setCellWithTitle:(NSString *)title subTitle:(NSString *)subTitle imageurl:(NSString *)imageurl;
@end
