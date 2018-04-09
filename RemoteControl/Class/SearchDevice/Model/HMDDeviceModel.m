//
//  HMDDeviceModel.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDDeviceModel.h"
@interface HMDDeviceModel()<NSXMLParserDelegate>
@property (nonatomic,strong) NSMutableDictionary *xmlDict;
@property (nonatomic,strong) NSString *curElement;                  //当前的标签
@end
@implementation HMDDeviceModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"uuid":@"UUID",
             @"location":@"LOCATION",
             @"server":@"SERVER",
             @"ip":@"IP",
             };
}

-(void)upInfoWithXMLData:(NSData *)xmlData finishBlock:(HMDDeviceModelParserfinishBlock)finishBlock{
    if (finishBlock) {
        self.finishBlock = finishBlock;
    }
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    xmlParser.delegate = self;
    [xmlParser parse];//开始解析
}


// 文档开始的时候触发
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    // 此方法只在解析开始时触发一次，因此可在这个方法中初始化解析过程中用到的一些成员变量
    //    _notes = [NSMutableArray new];
}

// 文档出错的时候触发
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"%@", parseError);
    if (self.finishBlock) {
        self.finishBlock(NO,self);
    }
}

// 遇到一个开始标签的时候触发
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.curElement = elementName;
}

// 遇到字符串时候触发，该方法是解析元素文本内容主要场所
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    // 剔除回车和空格
    if ([string isEqualToString:@""]||[string isEqualToString:@"\r"]||[string isEqualToString:@"\n"]) {
        return;
    }
    if ([self.curElement isEqualToString:@"friendlyName"]) {
        self.friendlyName = string;
    }
    if ([self.curElement isEqualToString:@"deviceType"]) {
        self.deviceType = string;
//        NSLog(@"deviceType:%@",string);
    }
//    [self.xmlDict setObject:string forKey:self.curElement];
    
    
}

// 遇到结束标签时触发，在该方法中主要是清理刚刚解析完成的元素产生的影响，以便于不影响接下来的解析
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
}

// 遇到文档结束时触发
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (self.finishBlock) {
        self.finishBlock(YES,self);
    }
    
}

-(NSMutableDictionary *)xmlDict{
    if (_xmlDict == nil) {
        _xmlDict = [NSMutableDictionary dictionary];
    }
    return _xmlDict;
}
@end
