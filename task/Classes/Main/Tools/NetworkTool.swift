//
//  NetworkTool.swift
//  TodayNews-Swift
//
//  Created by 杨蒙 on 17/2/16.
//  Copyright © 2017年 杨蒙. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

protocol NetworkToolProtocol {

}

class NetworkTool: NetworkToolProtocol {
    
    //test
    class func postMesa(  url:String,   parameters : [String : AnyObject], completionHandler:@escaping (_ json: Any?)->()) {
        
        print(parameters)
        
        Alamofire.request( url,method : .post, parameters :parameters ).responseJSON { (response) in
            
            print(response)
            
            
            //判断是否成功
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {


                completionHandler(value)
            }
        }
    }
    
    
    
    //get
    class func getMesa(  url:String, completionHandler:@escaping (_ value: Any?)->()) {
        
       
        
        Alamofire.request(url, parameters: nil ).responseJSON { (response) in
            //判断是否成功
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                
                print(value)
                
                let json = JSON(value)
                

                 completionHandler(json)

                
               
            }
        }
    }
    
    
    
    //getTaskList
    class func getTaskList(  url:String, completionHandler:@escaping (_ value: JSON)->()) {
        
        
        
        Alamofire.request(url, parameters: nil ).responseJSON { (response) in
            //判断是否成功
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                
                let json = JSON(value)
        
                completionHandler(json)
            }
        }
    }
    
    
    
    //上传图片
    class func uploadImage(  url:String,   image : UIImage, completionHandler:@escaping (_ json: Any?)->()) {
        
        
        let imageData = UIImagePNGRepresentation(image)!
        
        Alamofire.upload(imageData, to: API_UPLOADIMAGE_URL).responseJSON { response in
            debugPrint(response)
        }
        

    }
    
    
    

    
    class  func  errorMessage(error :String){
        
        
        let login = UserDefaults.standard.object(forKey: ZBLOGIN_KEY)! as! Bool
        let infoDictionary = Bundle.main.infoDictionary
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        var parameters = [String:String]()
        if     login  { //已经登录
            parameters = ["platform":"2", //    平台 1:android 2:ios
                "userid":User.GetUser().id!,
                "version_number":currentAppVersion,
                "description":error,
                "network_type":"1"
            ]
        }else{                //未登录
            parameters = ["platform":"2", //    平台 1:android 2:ios
                
                "version_number":currentAppVersion,
                "description":error,
                "network_type":"1"
            ]
        }
        
        Alamofire.request( API_ERROR_MESSAGE_URL ,method : .post, parameters :parameters ).responseJSON { (response) in
            //判断是否成功
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                print(json)
                if json["message"].stringValue  == "success"{
                    
                    print("ok")
                }
                
            }
        }
        
    }
 
    
   
}
