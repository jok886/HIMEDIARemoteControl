//
//  HMDVideoCollectionFlowLayout.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/26.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDVideoCollectionFlowLayout.h"

@implementation HMDVideoCollectionFlowLayout

-(instancetype)init{
    if (self = [super init]){
        self.itemSize = CGSizeMake(40, 40);
        self.minimumLineSpacing = 10;
        self.minimumInteritemSpacing = 10;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}
@end
