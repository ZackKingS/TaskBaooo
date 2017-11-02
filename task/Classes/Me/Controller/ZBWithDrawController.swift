//
//  ZBWithDrawController.swift
//  task
//
//  Created by 柏超曾 on 2017/11/2.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit


class ZBWithDrawController: UIViewController ,UITextFieldDelegate{
    
    
    
    @IBOutlet weak var cardT: UITextField!
    
    
    @IBOutlet weak var nameT: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        cardT.resignFirstResponder()
        nameT.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfig()
        
     
        
    }
    
    
    @IBAction func next(_ sender: Any) {
        
        if (cardT.text?.characters.count)! < 5 {
            self.showHint(hint: "请输入银行卡")
            return
        }
        
        if (nameT.text?.characters.count)! < 2 {
            self.showHint(hint: "请输入收款人")
            return
        }
        
       
        
       let draw =  ZBReadytToDrawController()
        draw.card = cardT.text
        draw.name = nameT.text
        navigationController?.pushViewController(draw, animated: true)
    }
    
    
    
    func setupConfig() {
    
    
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius =  kScornerRadius
        
    navigationController?.navigationBar.titleTextAttributes = [
    NSForegroundColorAttributeName: UIColor.white,
    NSFontAttributeName: UIFont.systemFont(ofSize: 18)
    ] //UIFont(name: "Heiti SC", size: 24.0)!
    navigationItem.title = "绑定银行卡";
        
    }
    
}
