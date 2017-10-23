//
//  ZBTaskUnderReviewController.swift
//  task
//
//  Created by 柏超曾 on 2017/9/27.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit

class ZBTaskUnderReviewController: UIViewController {
    
    
    @IBOutlet weak var backBtn: UIButton!
    
    var taskid :String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        if  taskid != nil{
            
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)  //会有黑线
            
            navigationController?.navigationBar.shadowImage = UIImage()
        }
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        
      
        navigationController?.popToRootViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: self, userInfo:nil)
        

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
        navigationItem.title = "任务进行中";

        backBtn.layer.cornerRadius = kScornerRadius
        backBtn.layer.masksToBounds = true
        
    }
}
