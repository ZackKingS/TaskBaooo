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
    
    
    @IBOutlet weak var backBtn: UIButton!
    
    
    @IBAction func back(_ sender: Any) {
        
         navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @IBOutlet weak var reload: UIButton!
    
    
    @IBAction func reload(_ sender: Any) {
        
        
        let start = ZBStartTaskController()
        start.taskid = taskid
        navigationController?.pushViewController(start, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfig()
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
