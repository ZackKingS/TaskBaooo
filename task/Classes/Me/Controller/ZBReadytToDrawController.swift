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
    var bankBranch : String?
    
    @IBOutlet weak var balanceT: UILabel!
    @IBOutlet weak var bankNumL: UILabel!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var amountT: UITextField!
    @IBOutlet weak var bankBranchL: UILabel!
    
  
    @IBOutlet weak var botCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfig()
        
        
        if isIPhone6 {
            botCons.constant = 50
        }else if isIPhone6P {
            
            botCons.constant = 87
        }
        
        
        
        
        
        let bank_card  = User.GetUser().bank_card as! NSString
    
        if UserDefaults.standard.bool(forKey: SETBANK) {
            
            let str =  UserDefaults.standard.object(forKey: USER_BANK_CARD) as! String
            bankNumL.text = addSpace(num:str ) as? String
            nameL.text =  UserDefaults.standard.object(forKey: USER_BANK_NAME) as! String
            bankBranchL.text =  UserDefaults.standard.object(forKey: BANK_BRANCH) as! String
            
        }else{
            if bank_card.length > 3 {
                bankNumL.text =    addSpace(num: User.GetUser().bank_card) as? String
                nameL.text = User.GetUser().card_name
                bankBranchL.text = User.GetUser().open_bank
                
                print( User.GetUser().open_bank)
                
            }else{
                
                bankNumL.text = card
                nameL.text = name
                bankBranchL.text = bankBranch
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
        
        let  balance =   UserDefaults.standard.object(forKey: "USER_BALANCE") as! String
      
        if amountT.text?.count == 0 {
             self.showHint(hint: "请输入金额")
            return
        }
        
        if  Double(amountT.text!)!  >  Double(balance)! {
            self.showHint(hint: "余额不足")
            return
        }
        
//        if  Int(amountT.text!)!  < 100 {
//            self.showHint(hint: "提现金额请高于100元")
//            return
//        }

//        let para = ["id":User.GetUser().id as AnyObject,
//                    "card":User.GetUser().bank_card as AnyObject,
//                    "name": User.GetUser().card_name as AnyObject,
//                    "money":amountT.text as AnyObject,
//                    "open_bank":bankBranchL.text
//            ] as [String : AnyObject]
        
        let   para : [String : AnyObject]?
        
        if UserDefaults.standard.bool(forKey: SETBANK) {
            
      
            
             para = ["id":User.GetUser().id as AnyObject,
                        "card":UserDefaults.standard.object(forKey: USER_BANK_CARD) as! String,
                        "name": UserDefaults.standard.object(forKey: USER_BANK_NAME) as! String,
                        "money":amountT.text as AnyObject,
                        "open_bank":UserDefaults.standard.object(forKey: BANK_BRANCH) as! String
                ] as [String : AnyObject]
            
        }else{
             para = ["id":User.GetUser().id as AnyObject,
                        "card":User.GetUser().bank_card as AnyObject,
                        "name": User.GetUser().card_name as AnyObject,
                        "money":amountT.text as AnyObject,
                        "open_bank":User.GetUser().open_bank
                ] as [String : AnyObject]
        }
        
        
        
        
        print(para!)
        
        let str = SecureTool.finalStr(short_url: "encashment", full_url: API_ENCASHMENT_URL)
        SVProgressHUD.show()
        
        print(str)
        
        NetworkTool.postMesa(url: str, parameters: para!) { (value) in
            SVProgressHUD.dismiss()
            let json = JSON(value ?? "123")
            if  json["message"].stringValue == "success" {
                    let result =  ZBDrawController()
                result.money =   Int(self.amountT.text!)
                result.is_success =  -1
                    self.navigationController?.pushViewController(result, animated: true)
            }else{
                
                self.showHint(hint: json["message"].stringValue)
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
