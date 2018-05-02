//
//  HMDDLan.swift
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/28.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

import UIKit
import AEXML
class HMDDLan: NSObject {
    
    @objc public func dLanPlayAction() ->String{
        let command = AEXMLElement(name: "u:Play",attributes: ["xmlns:u" : "urn:schemas-upnp-org:service:AVTransport:1"])
        command.addChild(name: "InstanceID", value: "0")
        command.addChild(name: "Speed", value: "1")
        let xml = self.prepareXMLFileWithCommand(command:command)
        return xml
    }
    
    @objc public func dLanSetAVTransportURI(uri:String) ->String{
        let command = AEXMLElement(name: "u:SetAVTransportURI",attributes: ["xmlns:u" : "urn:schemas-upnp-org:service:AVTransport:1"])
        command.addChild(name: "InstanceID", value: "0")
        command.addChild(name: "CurrentURI", value: uri)
        command.addChild(name: "CurrentURIMetaData")
        let xml = self.prepareXMLFileWithCommand(command:command)
        return xml
    }
    
    private func prepareXMLFileWithCommand(command:AEXMLElement) -> String {
        // 创建 AEXMLDocument 实例
        let soapRequest = AEXMLDocument()
        // 设置XML外层
        let attributes = [
            "xmlns:s" : "http://schemas.xmlsoap.org/soap/envelope/","s:encodingStyle" : "http://schemas.xmlsoap.org/soap/encoding/"]
        let envelope = soapRequest.addChild(name: "s:Envelope", attributes: attributes)
        let body = envelope.addChild(name: "s:Body")
        // 把 command 添加到 XML 中间
        body.addChild(command)
        return soapRequest.xmlCompact
    }
}
