//
//  SecureTool.swift
//  task
//
//  Created by 柏超曾 on 2017/10/11.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import AdSupport

class SecureTool: NSObject {
    
   class func  reTimestamp() -> String{
        
        let nowDate = NSDate(timeIntervalSinceNow: 0)
        // 时间戳的值
        let t:CLong  = CLong(nowDate.timeIntervalSince1970)
        
        let x : Int = Int(t)
        let xNSNumber = x as NSNumber
        let timestamp : String = xNSNumber.stringValue
        
        return timestamp
    }
    
    
    class  func reKey(url :String) -> String{
        
        var  strr = reTimestamp() as NSString
        strr =  strr.substring(from: strr.length - 5) as NSString
        var adId = ASIdentifierManager.shared().advertisingIdentifier.uuidString as NSString
        adId =  adId.substring(from: adId.length - 5)  as NSString
//        let key =    ((adId as String) + (strr as String) + ("/v1/user/income".MD5 )).MD5
         let key =    ((adId as String) + (strr as String) + (url.MD5 )).MD5
        
        return key!
        
    }
    
}
