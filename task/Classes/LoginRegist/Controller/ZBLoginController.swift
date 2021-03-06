//
//  ZBLoginController.swift
//  task
//
//  Created by 柏超曾 on 2017/9/26.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import SVProgressHUD
class ZBLoginController: UIViewController {
    
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var pwdTF: UITextField!
    
    
    @IBOutlet weak var loginBtn: UIButton!
    
    
    @IBOutlet weak var close: UIButton!
    
    
    
    
    @IBAction func off(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    @IBAction func login(_ sender: Any) {
        
        if phoneTF.text!.characters.count < 11  {
            
            self.showHint(hint: "请输入手机号")
            return
        }
        
        if    pwdTF.text!.characters.count < 6 {
            
            self.showHint(hint: "请输入密码")
            return
        }
        
        //方法：(phone后5.md5 + pwd.md5 )md5
        var  phone_last5 =  phoneTF.text! as NSString
        phone_last5 =  phone_last5.substring(from: phone_last5.length - 5) as NSString
        var final_pwd = (phone_last5 as String).MD5 + (pwdTF.text?.MD5)!
        final_pwd = final_pwd.MD5
        
//        let para = ["tel":phoneTF.text!,"password":final_pwd] as [String : AnyObject]

        
        
        let jpush_id = UserDefaults.standard.object(forKey: JPushID)
        
        print(jpush_id!)
         let para = ["tel":phoneTF.text!,
                     "password":final_pwd,
                     "jpush_id": jpush_id!
                     
            
            ] as [String : AnyObject]
        
     
        
        let url = "/v1/user/login"
        let key = SecureTool.reKey(url: url)
        let timestamp :String = SecureTool.reTimestamp()
        let uuid = ASIdentifierManager.shared().advertisingIdentifier.uuidString as NSString
        let    str = "\(API_LOGIN_URL)?&key=\(key)&t=\(timestamp)&imei=\((uuid as String))"
        
        
        NetworkTool.postMesa(url: str, parameters: para) { (value) in
            let json = JSON(value ?? "123")
            
            
            print(json)
            /*
            {
                "errorno" : 0,
                "data" : {
                    "id" : 100088,
                    "usersig" : "",
                    "is_logout" : 0,
                    "card_name" : "看看",
                    "avatar" : "",
                    "alipay" : null,
                    "bank_card" : "55555",
                    "username" : "",
                    "tel" : "18971225181",
                    "jpush_id" : "1114a89792ad4fcb451",
                    "nickname" : "看看",
                    "email" : "",
                    "account" : "2.50",
                    "finished" : 2
                },
                "message" : "success"
            }
 
 */
            let errorStr   = json["errorno"].stringValue
            
            if errorStr ==  "20032"  ||  errorStr ==  "20031" || errorStr ==  "20032" || errorStr ==  "20030" {
                
                
                self.showHint(hint: json["message"].stringValue)
                
//                SVProgressHUD.showError(withStatus: json["message"].stringValue)
//                SVProgressHUD.dismiss(withDelay: TimeInterval.init(1))
                return
            }

            
            let dataDict   = json["data"].dictionaryValue
            let user : User = User.init(dict: (dataDict as [String : JSON] ))
            let data = NSKeyedArchiver.archivedData(withRootObject: user) as NSData
            UserDefaults.standard.set(data, forKey: USER)
        
         
            print(User.GetUser().bank_card)
            
            
            if !UserDefaults.standard.bool(forKey: ZBLOGIN_KEY) {
                UserDefaults.standard.set(true, forKey: ZBLOGIN_KEY)
                UserDefaults.standard.synchronize()
            }
            
            
            //极光注册
            JPUSHService.setAlias(User.GetUser().id, completion: nil, seq: 1)
            
            
            SVProgressHUD.dismiss()
              self.dismiss(animated: true, completion: nil)
        }
 
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        phoneTF.resignFirstResponder()
        pwdTF.resignFirstResponder()
    }
    
    
    
    @IBAction func close(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)  //会有黑线
         navigationController?.navigationBar.shadowImage = UIImage()
      
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        setConfig()

    }
    
    typealias Tomato = (Int, Int) -> Int
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        
    }
    
  
    
    
    @IBOutlet weak var register: UIButton!
    
    
    @IBAction func regist(_ sender: Any) {
        
          navigationController?.pushViewController(ZBRegistViewController(), animated: true)
       

    }
    
    
    @IBOutlet weak var forgetPwd: UIButton!
    
    
    @IBAction func forgetPwd(_ sender: Any) {
        
        navigationController?.pushViewController(ZBForgotPwdController(), animated: true)
        
    }
    
    
    func setConfig(){
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(autoLogin(notification:)), name: NSNotification.Name(rawValue: "autoLogin"), object: nil)
        
        
        loginBtn.layer.cornerRadius = kLcornerRadius
        loginBtn.layer.masksToBounds = true
        phoneTF.attributedPlaceholder = NSAttributedString.init(string:"手机号", attributes: [  NSForegroundColorAttributeName:UIColor.white])
        pwdTF.attributedPlaceholder = NSAttributedString.init(string:"密码", attributes: [  NSForegroundColorAttributeName:UIColor.white])
    }
    
    
    func autoLogin(notification: Notification) {
        
        dismiss(animated: true, completion: nil)
        
        
        
//        SVProgressHUD.show()
//        let para =  ["tel":phone!,"verifycode":sms! ,"nickname" : nickName!,"password":pwd_s.text!]  as [String : AnyObject]
//
//        NetworkTool.postMesa(url: API_REGISTE_URL, parameters: para) { (result) in
//            print(result ?? "213")
//
//            SVProgressHUD.dismiss()
//            self.navigationController?.popToRootViewController(animated: true)
//            NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "autoLogin")))
//
//
//
//
//        }
        
    }
    
    
}
