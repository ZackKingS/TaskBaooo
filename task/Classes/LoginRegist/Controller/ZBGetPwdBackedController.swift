//
//  ZBGetPwdBackedController.swift
//  task
//
//  Created by 柏超曾 on 2017/9/27.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation

import UIKit
import SVProgressHUD
class ZBGetPwdBackedController: UIViewController {
    
    
    @IBOutlet weak var btn: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfig()
    }
    
    
    func setConfig(){
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ] //UIFont(name: "Heiti SC", size: 24.0)!
        navigationItem.title = "找回密码";
        
       
        
        btn.layer.cornerRadius = kScornerRadius
        btn.layer.masksToBounds = true
        
    }
    
    @IBAction func fini(_ sender: Any) {
        
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            
            SVProgressHUD.dismiss()
            self.navigationController?.popToRootViewController(animated: true)
            
            
            NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "autoLogin")))
            
        }
        
    }
    
    
    
}
