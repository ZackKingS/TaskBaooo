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
class ZBFixBankCardController: UIViewController  ,UITextFieldDelegate {
    
    @IBOutlet weak var card: UITextField!
    @IBOutlet weak var nameL: UITextField!
    @IBOutlet weak var fixBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            setupConfig()
             card.delegate = self
        }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameL.resignFirstResponder()
        card.resignFirstResponder()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == card {

            if string == "" {
                
            }else{
                if  (textField.text?.characters.count)! % 5 == 0 {
                    textField.text = "\(textField.text!) "
                }
            }
        }
        return true
    }
    
    
    @IBAction func fix(_ sender: Any) {
        
        
        if (card.text?.characters.count)! > 19  + 3 {
            self.showHint(hint: "请输入正确的银行卡号")
            return
        }
        
        if (card.text?.characters.count)! < 16 + 3   {
            self.showHint(hint: "请输入正确的银行卡号")
            return
        }
        
        if (card.text?.characters.count)! < 2 {
            self.showHint(hint: "请输入收款人")
            return
        }
        
        
        let para = ["id":User.GetUser().id,
                    "card":card.text?.removeAllSapce,
                    "name": nameL.text
            
            
            ] as [String : AnyObject]
        
        
        UserDefaults.standard.set(card.text?.removeAllSapce, forKey: "USER_BANK_CARD")
        UserDefaults.standard.set(nameL.text, forKey: "USER_BANK_NAME")
        
        
        
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
        

        let bank_card  = User.GetUser().bank_card! as NSString
 
        if UserDefaults.standard.bool(forKey: SETBANK)       {    //绑定了
            
            let str = UserDefaults.standard.object(forKey: "USER_BANK_CARD") as! NSString
            nameL.text = UserDefaults.standard.object(forKey: "USER_BANK_NAME") as? String
            card.text = str.getNewBankNumWitOldBankNum(str as String!)
            
            
        }else{
            
            if bank_card.length > 3 {
                
                let strr =  User.GetUser().bank_card! as NSString
                card.text  = strr.getNewBankNumWitOldBankNum(strr as String!)
                nameL.text  = User.GetUser().card_name
            }
        }
        
       
        
        
        
        
        
        
        
        
    }
}
