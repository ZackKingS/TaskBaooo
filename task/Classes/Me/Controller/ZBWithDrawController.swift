//
//  ZBWithDrawController.swift
//  task
//
//  Created by 柏超曾 on 2017/11/2.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SVProgressHUD

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
        
        if (cardT.text?.characters.count)! > 19   {
            self.showHint(hint: "请输入正确的银行卡号")
            return
        }
        
        if (cardT.text?.characters.count)! < 16   {
            self.showHint(hint: "请输入正确的银行卡号")
            return
        }
        
        if (nameT.text?.characters.count)! < 2 {
            self.showHint(hint: "请输入收款人")
            return
        }
        
        
        UserDefaults.standard.set(cardT.text, forKey: "USER_BANK_CARD")
          UserDefaults.standard.set(nameT.text, forKey: "USER_BANK_NAME")

        let para = ["id":User.GetUser().id,
                    "card":cardT.text,
                    "name": nameT.text
            
            
            ] as [String : AnyObject]
        
        
        let str = SecureTool.finalStr(short_url: "setbank", full_url: API_SETBANCK_URL)
        
        SVProgressHUD.show()
        
        NetworkTool.postMesa(url: str, parameters: para) { (value) in
            
            
            SVProgressHUD.dismiss()
            
            let json = JSON(value ?? "123")
            
            let message = json.dictionaryValue["message"]?.stringValue
            
            if message == "success" {
                
                 UserDefaults.standard.set(true, forKey: SETBANK)
                
                let draw =  ZBReadytToDrawController()
                draw.card = self.cardT.text
                draw.name = self.nameT.text
                self.navigationController?.pushViewController(draw, animated: true)
                
            }else{
                
                self.showHint(hint: message!)
            }
            
            
           
        }
        
     
     
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
