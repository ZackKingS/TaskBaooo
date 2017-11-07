//
//  ZBReadytToDrawController.swift
//  task
//
//  Created by 柏超曾 on 2017/11/2.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import SVProgressHUD
import SwiftyJSON

class ZBReadytToDrawController: UIViewController ,UITextFieldDelegate{


    
    var card :String?
    
    var name :String?
    
    
    @IBOutlet weak var balanceT: UILabel!
    
    @IBOutlet weak var bankNumL: UILabel!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var amountT: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfig()
        
        
        let bank_card  = User.GetUser().bank_card as! NSString
     
        
        
        
        if UserDefaults.standard.bool(forKey: SETBANK) {
            
            
            let str =  UserDefaults.standard.object(forKey: "USER_BANK_CARD") as! String
            
            bankNumL.text = addSpace(num:str ) as? String
            
            nameL.text =  UserDefaults.standard.object(forKey: "USER_BANK_NAME") as! String
        }else{
            
            if bank_card.length > 3 {
                
                bankNumL.text =    addSpace(num: User.GetUser().bank_card) as? String
                
                nameL.text = User.GetUser().card_name
            }else{
                
                
                bankNumL.text = card
                nameL.text = name
            }
        }
        
        
 
       let  balance =   UserDefaults.standard.object(forKey: "USER_BALANCE")
        
        balanceT.text = " ¥ \(balance!)"
        
       
        
        

        
    }
    
    
    
    func addSpace(num:String?)->NSString?{
        
        
        var str = num! as NSString
        
        str = str.getNewBankNumWitOldBankNum(str as String! )! as NSString
        
        return str
        
    }
    
    
    
    func checkbalance(){
        

        
        let str = SecureTool.finalStr(short_url: "profile", full_url: API_GETPROFILE_URL)
        
        NetworkTool.getTaskList(url: str, completionHandler: { (json) in
            
            print(json)
            
            if json["message"].stringValue != "success"{
                
                return
            }
            
            let dataArr  = json["data"].dictionaryValue
            
            if  dataArr["account"] == nil    ||  dataArr["finished"] == nil  {
                return
                
            }
            
          
            
            
        })
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        amountT.resignFirstResponder()
    }
    
    
    
    
    
    @IBAction func next(_ sender: Any) {
        
        
//        if  Int(amountT.text!)!  < 100 {
//
//            self.showHint(hint: "提现金额请高于100元")
//            return
//        }
//
//        let  balance =   UserDefaults.standard.object(forKey: "USER_BALANCE")
//
//
//        if  Int(amountT.text!)!  >  Int(balance) {
//
//            self.showHint(hint: "提现金额请高于100元")
//            return
//        }
        

        
        let para = ["id":User.GetUser().id,
                    "card":User.GetUser().bank_card,
                    "name": User.GetUser().card_name,
                    "money":amountT.text
            ] as [String : AnyObject]
        
        let str = SecureTool.finalStr(short_url: "encashment", full_url: API_ENCASHMENT_URL)
        SVProgressHUD.show()
        
        NetworkTool.postMesa(url: str, parameters: para) { (value) in
            SVProgressHUD.dismiss()
            let json = JSON(value ?? "123")
            if  json["message"].stringValue == "success" {
                    let result =  ZBDrawController()
                result.money =   Int(self.amountT.text!)
                result.is_success =  -1
                    self.navigationController?.pushViewController(result, animated: true)
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
        navigationItem.title = "提现";
        
    }
    
}
