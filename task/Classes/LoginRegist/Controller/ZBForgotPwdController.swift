//
//  ZBForgotPwdController.swift
//  task
//
//  Created by 柏超曾 on 2017/9/26.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class ZBForgotPwdController: UIViewController ,UITextFieldDelegate{
    
    
    typealias Tomato = (Int, Int) -> Int

    
    @IBOutlet weak var phoneL: UITextField!
    
    
    @IBOutlet weak var smsL: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
     var count = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        let image = UIImage.init(named: "tintColor")
        
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)  //会有黑线
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfig()
        
        phoneL.delegate = self
        smsL.delegate = self
        smsL.delegate = self
        
        
       
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
    
    
    
    @IBOutlet weak var sentSMS: UIButton!
    
    
    @IBAction func sentSMS(_ sender: CountDownBtn) {
        
         // todo  手机号正则过滤
        if phoneL.text!.characters.count < 10 {
            
            self.showHint(hint: "请输入手机号")
            return
        }
        
        
         sender.startCountDown()
       
        
        let str = API_GETSMS_URL + "?tel=\(phoneL.text!)&action=1"
        NetworkTool.getMesa( url: str  ){ (result) in
            
            SVProgressHUD.showSuccess(withStatus: "")
            SVProgressHUD.dismiss(withDelay: TimeInterval.init(1))
            
            print(result ?? "213")
            
        }

        
    }
    
    
    @IBAction func next(_ sender: Any) {
        
        
        let pwd = ZBSetPwdController()
        pwd.typecase = 2
        pwd.phone = phoneL.text!
        pwd.sms = smsL.text!
        navigationController?.pushViewController(pwd, animated: true)
        
    }
    
    
    
    
    func setConfig(){
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ] //UIFont(name: "Heiti SC", size: 24.0)!
        navigationItem.title = "找回密码";
        
        nextBtn.layer.cornerRadius = kLcornerRadius
        nextBtn.layer.masksToBounds = true
       
    }
}
