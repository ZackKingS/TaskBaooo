//
//  ZBRegistViewController.swift
//  task
//
//  Created by 柏超曾 on 2017/9/26.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import SwiftyJSON
class ZBRegistViewController: UIViewController ,UITextFieldDelegate {
    
    
    
    
    @IBOutlet weak var phoneNumL: UITextField!
    
    @IBOutlet weak var smsTF: UITextField!
    
    @IBOutlet weak var nickTF: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    
    @IBOutlet weak var nextBottonCons: NSLayoutConstraint!
    
    var count = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
       let image = UIImage.init(named: "tintColor")
        
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)  //会有黑线
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfig()
        
        phoneNumL.delegate = self
        nickTF.delegate = self
        smsTF.delegate = self
       
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if count != 1 { return }
        
        if isIPhone6 {
             UIView.animate(withDuration: 0.3, animations: {
                 self.nextBottonCons.constant = self.nextBottonCons.constant + 200
             })
        }else if isIPhone6P{
             UIView.animate(withDuration: 0.3, animations: {
                self.nextBottonCons.constant = self.nextBottonCons.constant + 150
           })
        }
        
     
        
        count = count + 1
    }
    
    

    @IBOutlet weak var sentSMS: UIButton!
    
    
    @IBAction func sentSMS(_ sender: CountDownBtn) {
        
        
        if phoneNumL.text!.characters.count < 10{
            

            
            self.showHint(hint: "请输入手机号")
            return
        }
     
     
        
      // todo  手机号正则过滤
        
        let str = API_GETSMS_URL + "?tel=\(phoneNumL.text!)&action=0"
        NetworkTool.getMesa( url: str  ){ (result) in

            SVProgressHUD.showSuccess(withStatus: "")
            SVProgressHUD.dismiss(withDelay: TimeInterval.init(1))
            
            print(result ?? "213")
            
            let json  = result as! JSON
            
            let errorno  = json["data"].stringValue
            
            if errorno != "20013"{ //没有注册的话
                
                   sender.startCountDown()
            }
        }
    }
    
    
    @IBAction func next(_ sender: Any) {
        
        let pwd = ZBSetPwdController()
        pwd.typecase = 1
        pwd.phone =  phoneNumL.text
          pwd.sms =  smsTF.text
          pwd.nickName =  nickTF.text
        
        navigationController?.pushViewController(pwd, animated: true)
        
    }
    
    
    func setConfig(){
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ] //UIFont(name: "Heiti SC", size: 24.0)!
        navigationItem.title = "注册";
        
        nextBtn.layer.cornerRadius = kLcornerRadius
        nextBtn.layer.masksToBounds = true

    }
}
