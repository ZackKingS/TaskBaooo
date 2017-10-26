//
//  ZBTaskFailController.swift
//  task
//
//  Created by 柏超曾 on 2017/9/27.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit
class ZBTaskFailController: UIViewController {
    
    
    
    var taskid :String?
    
    var taskName :String?
    
    var status :String?
    
    
    @IBOutlet weak var reasonT: UILabel!
    
    
    
    
    @IBOutlet weak var backBtn: UIButton!
    
    
    @IBAction func back(_ sender: Any) {
        
         navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @IBOutlet weak var reload: UIButton!
    
    
    @IBAction func reload(_ sender: Any) {
        
        

        
        let taskDetailController = ViewController()
        taskDetailController.taskid = taskid
        taskDetailController.taskName =  taskName
        taskDetailController.status =  status
        
        self.navigationController?.pushViewController(taskDetailController, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfig()
        
        
        
        getTaskInfo()
        
        
    }
    
    
    func getTaskInfo(){
        
        let str  = API_GETTASKDETAIL_URL +  "?id=\(taskid!)&userid=\(User.GetUser().id!)"
        
        NetworkTool.getTaskList(url: str, completionHandler: { (json) in
            /*
             {
             "errorno" : 0,
             "data" : {
             "status" : -1,
             "id" : 35,
             "price" : "5.00",
             "title" : "仙人掌股票开户",
             "image" : "http:\/\/pic2.ooopic.com\/11\/70\/93\/49bOOOPIC85_1024.jpg",
             "start_time" : "2017-09-29 10:45:14",
             "deadline" : "2017-10-26 10:45:14",
             "description" : "仙人掌股票开户"
             },
             "message" : "success"
             }
             */
            
             print(json)
            
            let dataDict   = json["data"].dictionaryValue
            
            print(dataDict)
            
            print(dataDict["status"]!.stringValue)
            print(dataDict["image"]!.stringValue)
            print(dataDict["reason"]!.stringValue)
            
            self.taskName = dataDict["title"]!.stringValue
            
               self.status = dataDict["status"]!.stringValue
            
            DispatchQueue.main.asyncAfter(deadline: .now() ) {
                
                self.reasonT.text =  dataDict["reason"]!.stringValue
                
            }
            
            
        })
        
    }
    
    
    func setConfig(){

        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ]
        navigationItem.title = "任务失败";
        
        backBtn.layer.cornerRadius = kScornerRadius
        backBtn.layer.masksToBounds = true
        
        reload.layer.cornerRadius = kScornerRadius
        reload.layer.masksToBounds = true
    }
}
