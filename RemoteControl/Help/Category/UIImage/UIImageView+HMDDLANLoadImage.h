//
//  UIImageView+HMDDLANLoadImage.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/18.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HMDDLANLoadImage)

-(void)setImageWithURLStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholderImage;

-(void)setDLANImageWithMethod:(NSString *)method URLStr:(NSString *)urlStr parameters:(NSDictionary *)parameters placeholderImage:(UIImage *)placeholderImage;
@end
