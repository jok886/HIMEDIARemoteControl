//
//  HMDBaseTableView.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/26.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDBaseTableView : UITableView
@property (nonatomic,strong) NSMutableArray *dataArray;


-(instancetype)initTableViewWithCellClass:(NSString *)className frame:(CGRect)frame;
@end
