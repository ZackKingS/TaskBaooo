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
    
    @IBOutlet weak var statusInfoL: UILabel!
    
    @IBOutlet weak var moneyInfoL: UILabel!
    
    @IBOutlet weak var moneyCountL: UILabel!
    
    @IBOutlet weak var detailL: UILabel!
    
    
    var  money : Int?
    var status : Int?
    var remarks : String?
    var is_success : Int?  //1：失败 2：成功
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfig()
       
    
        if is_success != nil {
            
            switch is_success! { // 1：失败 2：成功
            case -1 :  //请等待
                moneyCountL.text = "\(money!) 元"
                
            case 1 :  //1：失败
                print( "默认 case")
                
                statusInfoL.text = "您发起的提现失败"
                moneyInfoL.text = "原因:\(remarks!)"
                moneyCountL.text = "详情请联系客服"
                detailL.text = "电话: 0591-87822159"
                
            case 2  :  //2：成功
                moneyCountL.text = "\(money!) 元"
                statusInfoL.text = "您已经成功提现"
                detailL.isHidden = true
                
            default :
                print( "默认 case")
            }
            
        }
        
      
     
        
        
        
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
