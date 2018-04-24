//
//  HMDDeviceModel.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDDeviceModel.h"
#import "GDataXMLNode.h"

@implementation HMDDeviceServiceModel
- (void)setArray:(NSArray *)array{
    for (int m = 0; m < array.count; m++) {
        GDataXMLElement *needEle = [array objectAtIndex:m];
        if ([needEle.name isEqualToString:@"serviceType"]) {
            self.serviceType = [needEle stringValue];
        }
        if ([needEle.name isEqualToString:@"serviceId"]) {
            self.serviceId = [needEle stringValue];
        }
        if ([needEle.name isEqualToString:@"controlURL"]) {
            self.controlURL = [needEle stringValue];
        }
        if ([needEle.name isEqualToString:@"eventSubURL"]) {
            self.eventSubURL = [needEle stringValue];
        }
        if ([needEle.name isEqualToString:@"SCPDURL"]) {
            self.SCPDURL = [needEle stringValue];
        }
    }
}

@end

//@interface HMDDeviceModel()<NSXMLParserDelegate>
//@property (nonatomic,strong) NSMutableDictionary *xmlDict;
//@property (nonatomic,strong) NSString *curElement;                  //当前的标签
//@end
@implementation HMDDeviceModel
static NSString *serviceAVTransport         = @"urn:schemas-upnp-org:service:AVTransport:1";
static NSString *serviceRenderControl       = @"urn:schemas-upnp-org:service:RenderingControl:1";

- (instancetype)init{
    self = [super init];
    if (self) {
        self.AVTransportServiceModel = [[HMDDeviceServiceModel alloc] init];
        self.RenderControlServiceModel = [[HMDDeviceServiceModel alloc] init];
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"uuid":@"UUID",
             @"location":@"LOCATION",
             @"server":@"SERVER",
             @"ip":@"IP",
             };
}

-(void)upInfoWithXMLData:(NSData *)xmlData{

    NSString *dataStr = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:dataStr options:0 error:nil];
    GDataXMLElement *xmlEle = [xmlDoc rootElement];
    NSArray *xmlArray = [xmlEle children];
    
    for (int i = 0; i < [xmlArray count]; i++) {
        GDataXMLElement *element = [xmlArray objectAtIndex:i];
        if ([[element name] isEqualToString:@"device"]) {
            [self updataWithArray:[element children]];
            continue;
        }
    }

}

-(void)updataWithArray:(NSArray *)newDataArray{
    for (int j = 0; j < [newDataArray count]; j++) {
        GDataXMLElement *ele = [newDataArray objectAtIndex:j];
        if ([ele.name isEqualToString:@"friendlyName"]) {
            self.friendlyName = [ele stringValue];
        }
        if ([ele.name isEqualToString:@"modelName"]) {
            self.modelName = [ele stringValue];
        }
        if ([ele.name isEqualToString:@"deviceType"]) {
            self.deviceType = [ele stringValue];
        }

        if ([ele.name isEqualToString:@"serviceList"]) {
            NSArray *serviceListArray = [ele children];
            for (int k = 0; k < [serviceListArray count]; k++) {
                GDataXMLElement *listEle = [serviceListArray objectAtIndex:k];
                if ([listEle.name isEqualToString:@"service"]) {
                    if ([[listEle stringValue] rangeOfString:serviceAVTransport].location != NSNotFound) {
                        [self.AVTransportServiceModel setArray:[listEle children]];
                    }else if ([[listEle stringValue] rangeOfString:serviceRenderControl].location != NSNotFound){
                        [self.RenderControlServiceModel setArray:[listEle children]];
                    }
                }
            }
            continue;
        }
    }
}

@end
