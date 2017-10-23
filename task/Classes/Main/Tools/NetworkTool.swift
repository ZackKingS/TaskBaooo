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
    /// -------------------------- 首 页 home -------------------------
    /// 获取首页顶部标题内容
    static func loadHomeTitlesData(fromViewController: String, completionHandler:@escaping (_ topTitles: [TopicTitle], _ homeTopicVCs: [TopicViewController])->())
   
}

class NetworkTool: NetworkToolProtocol {
    
    //test
    class func postMesa(  url:String,   parameters : [String : AnyObject], completionHandler:@escaping (_ json: Any?)->()) {
        
        print(parameters)
        
        Alamofire.request( url,method : .post, parameters :parameters ).responseJSON { (response) in
            //判断是否成功
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
//                let json = JSON(value)

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
                
                let str = json["message"].stringValue
                
                if str ==  "success"{
                    
                    print(json)
                    completionHandler(json)
                  }else{
                    SVProgressHUD.showError(withStatus: json["message"].stringValue)
                }
                
               
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
    
    
    
   
    


    /// -------------------------- 首 页 home -------------------------
    // MARK: - 获取首页顶部标题内容
    /// 获取首页顶部标题内容
    class func loadHomeTitlesData(fromViewController: String, completionHandler:@escaping (_ topTitles: [TopicTitle], _ homeTopicVCs: [TopicViewController])->()) {
        
        
        
        
        
        
        
        
        
        let url = BASE_URL + "article/category/get_subscribed/v1/?"
        let params = ["device_id": device_id,
                      "aid": 13,
                      "iid": IID] as [String : AnyObject]


        Alamofire.request(url, parameters: params).responseJSON { (response) in


            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                let dataDict = json["data"].dictionary
                if let data = dataDict!["data"]!.arrayObject {
                    var titles = [TopicTitle]()
                    var homeTopicVCs = [TopicViewController]()
                    // 添加推荐标题
                    let recommendDict = ["category": "", "name": "推荐"]
                    let recommend = TopicTitle(dict: recommendDict as [String : AnyObject])
                    titles.append(recommend)
//                    // 添加控制器
                    let firstVC = TopicViewController()
                    firstVC.topicTitle = recommend
                    homeTopicVCs.append(firstVC)
                    for dict in data {
                        let topicTitle = TopicTitle(dict: dict as! [String: AnyObject])
                        titles.append(topicTitle)
                        let homeTopicVC = TopicViewController()
                        homeTopicVC.topicTitle = topicTitle
                        homeTopicVCs.append(homeTopicVC)
                    }
                    completionHandler(titles, homeTopicVCs)
                }
            }
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
