//
//  HMDDeviceLinkDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDDeviceLinkDao.h"
#import "GCDAsyncSocket.h"
#import "HMDDeviceModel.h"

@interface HMDDeviceLinkDao()<GCDAsyncSocketDelegate>

@property (nonatomic,strong) GCDAsyncSocket *linkSocket;

@end
@implementation HMDDeviceLinkDao

-(void)connectWithDeviceIP:(NSString *)deviceIP onPort:(NSInteger)port{

    NSError * error = nil;
    if (self.linkSocket == nil) {
        self.linkSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];

    }
    NSError *connectError = nil;
    [self.linkSocket connectToHost:deviceIP onPort:port viaInterface:nil withTimeout:-1 error:&connectError];
    NSLog(@"connectError:%@",connectError);
}


#pragma mark - GCDAsyncSocketDelegate
//- (nullable dispatch_queue_t)newSocketQueueForConnectionFromAddress:(NSData *)address onSocket:(GCDAsyncSocket *)sock{
//
//}
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToUrl:(NSURL *)url{
    
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
}
- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
}
- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    
}
//- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
//                 elapsed:(NSTimeInterval)elapsed
//               bytesDone:(NSUInteger)length{
//    
//}
//- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
//                 elapsed:(NSTimeInterval)elapsed
//               bytesDone:(NSUInteger)length{
//    
//}
- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock{
    
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err{
    
}
- (void)socketDidSecure:(GCDAsyncSocket *)sock{
    
}
- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust
completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler{
    
}
@end
