//
//  TaskDetailViewController.swift
//  task
//
//  Created by 柏超曾 on 2017/9/22.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit


class TaskDetailViewController: UIViewController {

    @IBOutlet weak var startBtn: UIButton!
    

    var id :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setConfig()

    
        
        
        let str  = API_GETTASKDETAIL_URL +  "?id=\(id!)&userid=\(User.GetUser().id!)"
        
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
  
            let dataDict   = json["data"].dictionaryValue
            print(dataDict["status"]!.stringValue)
            print(dataDict["image"]!.stringValue)
             print(dataDict["image"]!.stringValue)

            
            
        
        })
    }

  
    
    @IBAction func start(_ sender: Any) {
        
        navigationController?.pushViewController(ZBStartTaskController(), animated: true)
        
        
    }
    

    func setConfig(){
  view.backgroundColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ] //UIFont(name: "Heiti SC", size: 24.0)!
        navigationItem.title = "任务详情";



        startBtn.layer.cornerRadius = kScornerRadius
        startBtn.layer.masksToBounds = true

    }
}

