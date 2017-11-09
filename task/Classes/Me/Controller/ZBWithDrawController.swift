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
    @IBOutlet weak var bankBranchTF: UITextField!
    
    
    @IBOutlet weak var botCons: NSLayoutConstraint!
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        cardT.resignFirstResponder()
        nameT.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfig()
        
     cardT.delegate = self
        
        if isIPhone6 {
            botCons.constant = 50
        }else if isIPhone6P {
            
            botCons.constant = 87
        }
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == cardT {

            if string == "" {

            }else{
                if  (textField.text?.count)! % 5 == 0 {
                    textField.text = "\(textField.text!) "
                }
            }
        }
        return true
    }
    
    
    
  
    
    
    @IBAction func next(_ sender: Any) {
        
        print(cardT.text?.count)
        
        if (cardT.text?.count)! > 24  {
            self.showHint(hint: "请输入正确的银行卡号")
            return
        }
        
        if (cardT.text?.count)! < 20   {
            self.showHint(hint: "请输入正确的银行卡号")
            return
        }
        
        if (nameT.text?.count)! < 2 {
            self.showHint(hint: "请输入收款人")
            return
        }
        
        
        if (bankBranchTF.text?.count)! < 4 {
            self.showHint(hint: "请输入正确的开户行")
            return
        }

        
        let para = ["id":User.GetUser().id,
                    "card":  cardT.text?.removeAllSapce,
                    "name": nameT.text,
                    "open_bank": bankBranchTF.text,
                    
            ] as [String : AnyObject]
        
        UserDefaults.standard.set(cardT.text?.removeAllSapce, forKey: USER_BANK_CARD)
        UserDefaults.standard.set(nameT.text, forKey: USER_BANK_NAME)
        UserDefaults.standard.set(bankBranchTF.text, forKey: BANK_BRANCH)
        
        
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
