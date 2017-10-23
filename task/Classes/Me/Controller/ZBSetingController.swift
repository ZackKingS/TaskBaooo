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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfig()
        
   
        
    
        let s = " \(ZBCleanTool.fileSizeOfCache()) M"
        sizeBtn.setTitle(s, for: .normal)
        
    
     
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
            
            return screenHeight - 50 * 2 - 20
        }
        
        return 60
    }
    
    
    @IBAction func logout(_ sender: Any) {
        
        
        UserDefaults.standard.set(false, forKey: ZBLOGIN_KEY)
        UserDefaults.standard.synchronize()
        navigationController?.popViewController(animated: true)
    }
    
    
    func setupConfig(){
        
        
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

            alcer()
            

        }else if indexPath.row == 1{
          
            navigationController?.pushViewController(ZBAboutMe(), animated: true)
            
        }else if indexPath.row == 2{
           checkupdate()
        }
        
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func alcer(){
        
        
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // change the style sheet text color
        alert.view.tintColor = UIColor.black
        
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
                
                
                print(currentAppVersion)
                
                print(version_name)
                
                if currentAppVersion != version_name {
                    
                    print( "去更新")
                    
                    let des = json["data"]["update_state"].stringValue
                    
                    self.compareVersion(currentAppVersion, storeVersion: version_name, note: des)
                    
                }else{
                    
                    self.showHint(hint: "已经是最新版本")
                }
            }
        }
    }
    
    
    fileprivate func compareVersion(_ localVersion: String, storeVersion: String,note:String) {
        let message = "本次更新内容：\n\(note)"
        if localVersion.compare(storeVersion) == ComparisonResult.orderedAscending {
            let alertView = UIAlertView(title: "发现新版本",message: message,delegate: self as? UIAlertViewDelegate,cancelButtonTitle: nil,otherButtonTitles: "马上更新","下次再说")
            alertView.delegate = self
            alertView.tag = 10086
            alertView.show()
        }
    }
    
    func alertView(_ alertView:UIAlertView, clickedButtonAt buttonIndex: Int){
        if(alertView.tag == 10086) {
            if(buttonIndex == 0){
                UIApplication.shared.openURL(URL(string:"https://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8")!)
            }else{
                //下次再说
            }
        }
    }
    
        
        
}
