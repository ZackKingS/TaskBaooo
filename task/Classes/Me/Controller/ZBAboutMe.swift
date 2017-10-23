//
//  ZBAboutMe.swift
//  task
//
//  Created by 柏超曾 on 2017/10/20.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation

class ZBAboutMe: UIViewController {
    
    
    @IBOutlet weak var versionT: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfig()
        
        
        let infoDictionary = Bundle.main.infoDictionary
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        versionT.text = "版本号  " + currentAppVersion
        
    }
    
    
    func setConfig(){
        
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ]
        navigationItem.title = "关于我们";
      
        
    }
    
}
