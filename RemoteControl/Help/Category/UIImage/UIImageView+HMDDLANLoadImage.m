//
//  UIImageView+HMDDLANLoadImage.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/18.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "UIImageView+HMDDLANLoadImage.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation UIImageView (HMDDLANLoadImage)
//-(void)setDLANImageWithURLStr:(NSString *)urlStr parameters:(NSDictionary *)parameters placeholderImage:(UIImage *)placeholderImage{
//
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    session.requestSerializer=[AFJSONRequestSerializer serializer];
//    //超时时间
//    [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    session.requestSerializer.timeoutInterval = 30.f;
//    [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    session.responseSerializer=[AFHTTPResponseSerializer serializer];
//    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"text/xml",nil];
//    NSMutableURLRequest *urlRequest = [session.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:urlStr relativeToURL:session.baseURL] absoluteString] parameters:parameters error:nil];
//    /*如果更新 AFN
//     需要跳两级到AFImageDownloader.h  199行增加
//    self.sessionManager.responseSerializer=[AFHTTPResponseSerializer serializer];
//    self.sessionManager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"text/xml",nil];
//     */
//    HMDWeakSelf(self)
//    [self setImageWithURLRequest:urlRequest placeholderImage:placeholderImage success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
//        //返回的是BASE64加密过的数据,需要处理
//        if ([image isKindOfClass:[NSData class]]) {
//            NSString *encodedImageStr = [[NSString alloc]initWithData:(NSData *)image encoding:NSUTF8StringEncoding];
//            NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
//            weakSelf.image = [UIImage imageWithData:decodedImageData];
//        }else if ([image isKindOfClass:[UIImage class]]){
//            weakSelf.image = image;
//        }
//    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
//        NSLog(@"failure%s",__FUNCTION__);
//    }];
//}

-(void)setImageWithURLStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholderImage{
    [self setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:placeholderImage];
}

-(void)setDLANImageWithMethod:(NSString *)method URLStr:(NSString *)urlStr parameters:(NSDictionary *)parameters placeholderImage:(UIImage *)placeholderImage{
    if (placeholderImage) {
        self.image = placeholderImage;
    }
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.requestSerializer=[AFJSONRequestSerializer serializer];
        //超时时间
        [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        session.requestSerializer.timeoutInterval = 30.f;
        [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        session.responseSerializer=[AFHTTPResponseSerializer serializer];
        session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:
                                                           @"image/gif",
                                                           @"image/x-xbitmap",
                                                           @"image/x-win-bitmap",
                                                           @"image/bmp",
                                                           @"image/tiff",
                                                           @"image/x-icon",
                                                           @"image/jpeg",
                                                           @"image/ico",
                                                           @"image/x-bmp",
                                                           @"image/png",
                                                           @"text/plain",
                                                           nil];
        NSMutableURLRequest *urlRequest = [session.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:urlStr relativeToURL:session.baseURL] absoluteString] parameters:parameters error:nil];
        /*如果更新 AFN
         需要跳两级到AFImageDownloader.h  199行增加
        self.sessionManager.responseSerializer=[AFHTTPResponseSerializer serializer];
        self.sessionManager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"text/xml",nil];
         */
        HMDWeakSelf(self)
        [self setBase64ImageWithURLRequest:urlRequest placeholderImage:placeholderImage success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                weakSelf.image = image;
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"failure%s",__FUNCTION__);
        }];
}
@end

