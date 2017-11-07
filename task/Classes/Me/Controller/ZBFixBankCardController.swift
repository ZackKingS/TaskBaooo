//
//  ZBFixBankCardController.swift
//  task
//
//  Created by 柏超曾 on 2017/11/7.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SVProgressHUD
class ZBFixBankCardController: UIViewController {
    
    @IBOutlet weak var card: UITextField!
    @IBOutlet weak var nameL: UITextField!
    @IBOutlet weak var fixBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            setupConfig()
            
        }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameL.resignFirstResponder()
        card.resignFirstResponder()
    }
    
    
    @IBAction func fix(_ sender: Any) {
        
        
        if (card.text?.characters.count)! > 19   {
            self.showHint(hint: "请输入正确的银行卡号")
            return
        }
        
        if (card.text?.characters.count)! < 16   {
            self.showHint(hint: "请输入正确的银行卡号")
            return
        }
        
        if (card.text?.characters.count)! < 2 {
            self.showHint(hint: "请输入收款人")
            return
        }
        
        
        let para = ["id":User.GetUser().id,
                    "card":card.text,
                    "name": nameL.text
            
            
            ] as [String : AnyObject]
        
        
        let str = SecureTool.finalStr(short_url: "setbank", full_url: API_SETBANCK_URL)
        
        SVProgressHUD.show()
        
        
        print(str)
          print(para)
        NetworkTool.postMesa(url: str, parameters: para) { (value) in
            
            
            SVProgressHUD.dismiss()
            
            let json = JSON(value ?? "123")
            
            print(json)
            
            let message = json.dictionaryValue["message"]?.stringValue
            
            if message == "success" {
                
                UserDefaults.standard.set(true, forKey: SETBANK)
                
               self.navigationController?.popViewController(animated: true)
                
            }else{
                
                self.showHint(hint: message!)
            }
            
            
            
        }
        
    }
    
    
    
    func  setupConfig() {
    
    fixBtn.layer.masksToBounds = true
    fixBtn.layer.cornerRadius =  kScornerRadius
    
    card.layer.borderColor = UIColor.lightGray.cgColor;
        card.layer.borderWidth = 1.0
    nameL.layer.borderColor = UIColor.lightGray.cgColor;
        nameL.layer.borderWidth = 1.0
        
    navigationController?.navigationBar.titleTextAttributes = [
    NSForegroundColorAttributeName: UIColor.white,
    NSFontAttributeName: UIFont.systemFont(ofSize: 18)
    ] 
    navigationItem.title = "修改绑定银行卡";
        
    }
}
