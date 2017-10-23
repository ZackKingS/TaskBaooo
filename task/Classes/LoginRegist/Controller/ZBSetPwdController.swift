//
//  ZBSetPwdController.swift
//  task
//
//  Created by 柏超曾 on 2017/9/26.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import SVProgressHUD
class ZBSetPwdController: UIViewController ,UITextFieldDelegate  {
    
     var typecase : Int = 0

    
    
    var phone: String?
    var sms: String?
    var nickName: String?
    
    @IBOutlet weak var pwd_f: UITextField!
    
    @IBOutlet weak var pwd_s: UITextField!
    
    @IBOutlet weak var commitBtn: UIButton!
    
    
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
      var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfig()
        
        pwd_s.delegate = self
        pwd_f.delegate = self
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pwd_s.resignFirstResponder()
        pwd_f.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if count != 1 { return }
        
        if isIPhone6 {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomCons.constant = self.bottomCons.constant + 200
            })
            
            
            
           
        }else if isIPhone6P{
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomCons.constant = self.bottomCons.constant + 150
            })
            
        }
        
        
        
        count = count + 1
    }
    
    @IBAction func commit(_ sender: Any) {
        
        
        let str1 = pwd_s.text as! String
        let str2 = pwd_f.text as! String
        if    !(str1 == str2 ) {
//            SVProgressHUD.showError(withStatus: "两次输入密码不同")
            
            self.showHint(hint: "两次输入密码不同")
            
//            SVProgressHUD.dismiss(withDelay: TimeInterval.init(1))
            return
        }
        
        
        
        switch typecase {
        case 1: 
            print("reg")  //注册
            
            
            //方法：(phone后5.md5 + pwd.md5 )md5
            var  phone_last5 =  phone! as NSString
            phone_last5 =  phone_last5.substring(from: phone_last5.length - 5) as NSString
            var final_pwd = (phone_last5 as String).MD5 + (pwd_s.text?.MD5)!
            final_pwd = final_pwd.MD5
            
            
            
              SVProgressHUD.show()
            let para =  ["tel":phone!,"verifycode":sms! ,"nickname" : nickName!,"password":final_pwd]  as [String : AnyObject]
          
            NetworkTool.postMesa(url: API_REGISTE_URL, parameters: para) { (value) in
              
                let json = JSON(value ?? "123")
                let dataDict   = json["data"].dictionaryValue
                
                
                
                let user : User = User.init(dict: (dataDict as [String : JSON] ))
                print(user.tel!)
                
                
                let data = NSKeyedArchiver.archivedData(withRootObject: user) as NSData
                UserDefaults.standard.set(data, forKey: "user")

                
                UserDefaults.standard.set(true, forKey: ZBLOGIN_KEY)
                
                
                SVProgressHUD.dismiss()
                self.navigationController?.popToRootViewController(animated: true)

                
                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "autoLogin"), object: self, userInfo: nil)
                
            }
            
          
          
            
        case 2:
            print("forgetpwd")
            
            
            if sms!.characters.count < 4{
                
                self.showHint(hint: "请输入验证码")
                return
            }
            
            
            if (pwd_s!.text?.characters.count)! < 6{
                
                self.showHint(hint: "密码不能少于6位哦")
                return
            }
            
            
            if (pwd_s!.text?.characters.count)! > 16{
                
                self.showHint(hint: "密码不能多于16位哦")
                return
            }
            
            
            //方法：(phone后5.md5 + pwd.md5 )md5
            var  phone_last5 =  phone! as NSString
            phone_last5 =  phone_last5.substring(from: phone_last5.length - 5) as NSString
            var final_pwd = (phone_last5 as String).MD5 + (pwd_s.text?.MD5)!
            final_pwd = final_pwd.MD5
            
            SVProgressHUD.show()
            let para =  ["tel":phone!,"verifycode":sms! ,"password":final_pwd]  as [String : AnyObject]
            
            print(para)
            
            NetworkTool.postMesa(url: API_GETPWDBACK_URL, parameters: para) { (value) in
                
            
                 SVProgressHUD.dismiss()
                let json = JSON(value ?? "123")
                
                let message = json["errorno"].stringValue
                
                if message == "20052"{
            
                    self.showHint(hint:  json["message"].stringValue)
                    
                    return
                }
                
                
                
                let dataDict   = json["data"].dictionaryValue
                let user : User = User.init(dict: (dataDict as [String : JSON] ))
                let data = NSKeyedArchiver.archivedData(withRootObject: user) as NSData
                UserDefaults.standard.set(data, forKey: USER)
                UserDefaults.standard.set(true, forKey: ZBLOGIN_KEY)

               self.navigationController?.pushViewController(ZBGetPwdBackedController(), animated: true)
                
            }
            
            
       
        default:
            print("xxx")
        }
        
        
     
        
    }
    func setConfig(){
        
        commitBtn.layer.cornerRadius = kLcornerRadius
        commitBtn.layer.masksToBounds = true
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ] //UIFont(name: "Heiti SC", size: 24.0)!
        navigationItem.title = "设置密码";
    }
}
