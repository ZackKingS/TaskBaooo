//
//  ZBSetingController.swift
//  task
//
//  Created by 柏超曾 on 2017/9/26.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ZBSetingController: UITableViewController ,UIAlertViewDelegate{
    
    @IBOutlet weak var sizeBtn: UIButton!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    
    @IBOutlet weak var versionNum: UIButton!
    
    
    @IBOutlet weak var isCardBtn: UIButton!
    
    
    
    var appStoreUrl :String?
    var force_update :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfig()
     
    }
    
    
    @IBAction func clear(_ sender: Any) {
        

    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.row == 0 {
            return 50
        }else if indexPath.row == 1{
            return 50
        }else if  indexPath.row == 2{
            return 50
        }else if  indexPath.row == 3{
           return 50
        }else if  indexPath.row == 4{
            return screenHeight - 50 * 4 - 20
        }
        return 60
    }
    
    
    @IBAction func logout(_ sender: Any) {
        alcerrrr()
    }
    
    
    func alcerrrr(){
        
        
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionCancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let actionCamera = UIAlertAction.init(title: "确定", style: .default) { (UIAlertAction) -> Void in
            self.out()
        }
  
        alert.addAction(actionCancel)
        alert.addAction(actionCamera)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func out(){
        
        
        let    parameters = ["id": User.GetUser().id ] as! [String :String]
        
        Alamofire.request( API_LOGOUT_URL,method : .post, parameters :parameters ).responseJSON { (response) in
            //判断是否成功
            guard response.result.isSuccess else {
                return
            }
            
            if let value = response.result.value {
            
                let json = JSON(value)
                let message = json["message"].stringValue
              
                
                print(message)
            }
            
        }
        
        
        
        UserDefaults.standard.set(false, forKey: ZBLOGIN_KEY)
        UserDefaults.standard.synchronize()
        navigationController?.popViewController(animated: true)
        
    }
    
    func setupConfig(){
        
        
        
        let infoDictionary = Bundle.main.infoDictionary
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        versionNum.setTitle("当前版本V\(currentAppVersion)", for: .normal)
        
        if UserDefaults.standard.bool(forKey: ZBLOGIN_KEY) {
            
            logoutBtn.isHidden = false
            let bank_card  = User.GetUser().bank_card as! NSString
            if bank_card.length > 3 {
                isCardBtn.setTitle("已绑定", for: .normal)
                
            }else{
                 isCardBtn.setTitle("未绑定", for: .normal)
            }

        }else{
            
            
            isCardBtn.setTitle("未绑定", for: .normal)
            logoutBtn.isHidden = true
        }
        
        
        
        let s = " \(ZBCleanTool.fileSizeOfCache()) M"
        sizeBtn.setTitle(s, for: .normal)
        
        
        tableView.backgroundColor = UIColor.white
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ] //UIFont(name: "Heiti SC", size: 24.0)!
        navigationItem.title = "设置";
        
        tableView.contentInset = UIEdgeInsets.init(top: -20, left: 0, bottom: 0, right: 0);
        self.tableView.sectionFooterHeight = 0;
        self.tableView.sectionHeaderHeight = screenHeight / 3;
        
        
        logoutBtn.layer.cornerRadius = kScornerRadius
        logoutBtn.layer.masksToBounds = true
        
        
        ZBCleanTool.fileSizeOfCachingg(completionHandler: { (size) in
            
            self.sizeBtn.setTitle((size  ), for: .normal)
        })
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 0 {

           

        }else if indexPath.row == 1{
             alcer()
        }else if indexPath.row == 2{
              checkupdate()
        }else if indexPath.row == 3{
            navigationController?.pushViewController(ZBAboutMe(), animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func alcer(){
        
        
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionCancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let actionCamera = UIAlertAction.init(title: "确定", style: .default) { (UIAlertAction) -> Void in
            self.cleannn()
        }
        
        alert.addAction(actionCancel)
        alert.addAction(actionCamera)
        self.present(alert, animated: true, completion: nil)
    
    }
    
  
    private func cleannn(){
        
        ZBCleanTool.clearCache()
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            SVProgressHUD.showSuccess(withStatus: "")
            SVProgressHUD.setAnimationDuration(1)
            self.sizeBtn.setTitle(" 0 M", for: .normal)
        }
        
    }
    
    
    func checkupdate (){
        
        
        Alamofire.request(API_SOFTWARE_UPDATA_URL+"?platform=2", parameters: nil ).responseJSON { (response) in
            //判断是否成功
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let infoDictionary = Bundle.main.infoDictionary
                let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
                let json = JSON(value)
                
                let version_name = json["data"]["version_name"].stringValue
                self.appStoreUrl = json["data"]["package_url"].stringValue
                self.force_update = json["data"]["force_update"].stringValue
                
                if currentAppVersion != version_name {
                    
                    let des = json["data"]["update_state"].stringValue
                    self.compareVersion(currentAppVersion, storeVersion: version_name, note: des)
                    
                }else{
                    self.showHint(hint: "您已经是最新版本")
                }
            }
        }
    }
    fileprivate func compareVersion(_ localVersion: String, storeVersion: String,note:String) {
        let message = "本次更新内容：\n\(note)"
        
        
        if localVersion.compare(storeVersion) == ComparisonResult.orderedAscending {
            
            if   force_update == "0"   {
                
                let alertView = UIAlertView(title: "发现新版本",message: message,delegate: self as? UIAlertViewDelegate,cancelButtonTitle: nil,otherButtonTitles: "马上更新","下次再说")
                alertView.delegate = self
                alertView.tag = 10086
                alertView.show()
                
            } else  if force_update == "1"{
                let alertView = UIAlertView(title: "发现新版本",message: message,delegate: self as? UIAlertViewDelegate,cancelButtonTitle: nil,otherButtonTitles: "马上更新","立即更新")
                alertView.delegate = self
                alertView.tag = 10086
                alertView.show()
                
            }
            
        }
    }
    
    func alertView(_ alertView:UIAlertView, clickedButtonAt buttonIndex: Int){
        if(alertView.tag == 10086) {
            if(buttonIndex == 0){
                
                if appStoreUrl != nil {
                    UIApplication.shared.openURL(URL(string:appStoreUrl!)!)
                }
                
                
            }else{
                
                if   force_update == "0"   {
                    
                } else  if force_update == "1"{
                    if appStoreUrl != nil {
                        UIApplication.shared.openURL(URL(string:appStoreUrl!)!)
                    }
                    
                }
                
            }
        }
    }
        
        
}
