//
//  HMDNullPageView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/15.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDNullPageView.h"
@interface HMDNullPageView()
@property (weak, nonatomic) IBOutlet UIButton *reloadBtn;

@end

@implementation HMDNullPageView

-(void)setNeedReloadBtn:(BOOL)needReloadBtn{
    _needReloadBtn = needReloadBtn;
    self.reloadBtn.hidden = !needReloadBtn;
}
- (IBAction)reloadBtnClick:(id)sender {
    if (self.reloadBtnClickBlock) {
        self.reloadBtnClickBlock();
    }
}
@end
