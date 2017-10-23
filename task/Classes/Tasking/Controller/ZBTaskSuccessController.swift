//
//  ZBTaskSuccessController.swift
//  task
//
//  Created by 柏超曾 on 2017/9/27.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit
class ZBTaskSuccessController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var priceL: UILabel!
    
    var price : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfig()
        priceL.text = "¥\(price!)"
        
    }
    
    
    func setConfig(){
        
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ] 
        navigationItem.title = "任务完成";
        backBtn.layer.cornerRadius = kScornerRadius
        backBtn.layer.masksToBounds = true
        
    }
    
    
    @IBAction func back(_ sender: Any) {
    
        navigationController?.popViewController(animated: true)
    }
    
}
