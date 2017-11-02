//
//  ZBDrawController.swift
//  task
//
//  Created by 柏超曾 on 2017/11/2.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit


class ZBDrawController: UIViewController {
    
    
    @IBOutlet weak var backBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfig()
       
        
    }
    
    @IBAction func back(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setupConfig() {
        
        
        backBtn.layer.masksToBounds = true
        backBtn.layer.cornerRadius =  kScornerRadius

        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ] //UIFont(name: "Heiti SC", size: 24.0)!
        navigationItem.title = "提现";
        
    }
}
