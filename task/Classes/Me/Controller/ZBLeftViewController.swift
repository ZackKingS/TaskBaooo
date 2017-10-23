//
//  ZBLeftViewController.swift
//  QQDRAWER_SWIFT
//
//  Created by zzy on 2016/10/30.
//  Copyright © 2016年 BlackSky. All rights reserved.
//

import UIKit
import SVProgressHUD
import AdSupport
import  SwiftyJSON
class ZBLeftViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    // left header 高度
    let kLeftheaderHeight: CGFloat = 240
    
    // left tableview 高度
    let kLeftTableViewHeight: CGFloat = 62 * 2

    let kUserHeaderHeight : CGFloat = 70
    
    let kwithDrawBtnWidth : CGFloat = 118
    
    
    var userNameL   =  UILabel()
    
    //头部
    var headerView: UIView{
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kLeftheaderHeight))
        view.backgroundColor =  UIColor.themeColor()
        
        
        //头像
        let userHeaderV = UIImageView.init(frame: CGRect.init(x: (kMaxLeftOffset - kUserHeaderHeight) / 2, y: 80 , width: kUserHeaderHeight, height:kUserHeaderHeight))
        userHeaderV.backgroundColor = UIColor.white
        userHeaderV.layer.cornerRadius = userHeaderV.bounds.width / 2
        userHeaderV.layer.masksToBounds  = true
        view.addSubview(userHeaderV)
        userHeaderV.image = UIImage.init(named: "header")
        
        
        
        
       //昵称
        let nickName = UILabel.init(frame: CGRect.init(x: (kMaxLeftOffset - 100) / 2, y: 70 + kUserHeaderHeight  , width: 100, height:70))
        nickName.text = "请登录"
        nickName.textAlignment = .center
        nickName.textColor = UIColor.white
        view.addSubview(nickName)
        
       userNameL = nickName
        
        return view
    }
    
    
    
    
    var footerView: UIView{
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0.4 + kLeftheaderHeight + kLeftTableViewHeight , width: screenWidth, height: screenHeight - kLeftheaderHeight - kLeftTableViewHeight))
        view.backgroundColor =  UIColor.themeColor()
        
        
        //立即提现
        let withDrawBtn:UIButton = UIButton(type:.custom)
        withDrawBtn.setTitle("立即提现", for:.normal) //普通状态下的文字
        withDrawBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        withDrawBtn.setTitleColor(UIColor.white, for: .normal) //普通状态下文字的颜色
        withDrawBtn.addTarget(self, action: #selector(withDraw), for: .touchUpInside)
        withDrawBtn.layer.cornerRadius = kScornerRadius
        withDrawBtn.layer.masksToBounds = true
        withDrawBtn.backgroundColor = UIColor.colorWithHexString(Color_Value: "#e6761c", alpha: 1.0)
        view.addSubview(withDrawBtn)
        withDrawBtn.frame = CGRect.init(x: (kMaxLeftOffset - kwithDrawBtnWidth)/2, y: 40, width: kwithDrawBtnWidth, height: 40)
    
        
        
        
        
        
        //设置iocn
        let settingV = UIImageView.init(frame:  CGRect.init(x: 17, y: screenHeight - kLeftheaderHeight - kLeftTableViewHeight - 50, width: 20, height: 20))
        view.addSubview(settingV)
        settingV.image = UIImage.init(named: "setting")
        settingV.isUserInteractionEnabled = true
        settingV.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(setting)))
        
        
        
        
        //设置
        let settingBtn:UIButton = UIButton(type:.custom)
        settingBtn.setTitle("设置", for:.normal) //普通状态下的文字
        settingBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        settingBtn.setTitleColor(UIColor.white, for: .normal) //普通状态下文字的颜色
        settingBtn.addTarget(self, action: #selector(setting), for: .touchUpInside)
        settingBtn.layer.cornerRadius = kScornerRadius
        settingBtn.layer.masksToBounds = true
        view.addSubview(settingBtn)
        settingBtn.frame = CGRect.init(x: 35, y: screenHeight - kLeftheaderHeight - kLeftTableViewHeight - 60, width: 70, height: 40)
        
        
        return view
    }
    
    
    func setting(){
        
         NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "closeTheDrawer")))
        
    }
    
    
    var dataArray:[String]{
        let array = NSArray.init(objects: "完成任务","用户余额")
        return array as! [String]
    }
    
//    var rightDataArray:[String]{
//        var array = NSArray.init(objects: "0项","0.0元")
//        return array as! [String]
//
////         var array : [String] = [String]()
////        array = [ "0项","0.0元"]
////        return array
//    }
    
    
        
    var rightDataArray : [String] = [String]()
//    rightDataArray = [ "0项","0.0元"]
    
  
    var zbtableView : UITableView?
    
    var leftDataArray:[String]{
        let array = NSArray.init(objects: "mission","wallet")
        return array as! [String]
    }
    
    func withDraw(){
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        print("123")
        if  UserDefaults.standard.bool(forKey: ZBLOGIN_KEY)  {
//            userNameL.text = User.GetUser().nickname
            
            
//            let url = "/v1/user/profile"
//            let key = SecureTool.reKey(url: url)
//            let timestamp :String = SecureTool.reTimestamp()
//            let uuid = ASIdentifierManager.shared().advertisingIdentifier.uuidString as NSString
//            let    str = "\(API_GETPROFILE_URL)?id=\(User.GetUser().id!)&key=\(key)&t=\(timestamp)&imei=\((uuid as String))"
//            NetworkTool.getTaskList(url: str, completionHandler: { (json) in
//                
//                let dataArr  = json["data"].dictionaryValue
//                print(dataArr["account"]!)
//                print(dataArr["finished"]!)
//                
//                let finished = "\(dataArr["finished"]!.stringValue)项"
//                 let account = "\(dataArr["account"]!.stringValue)元"
//
//                self.rightDataArray = [ finished, account]
//                self.zbtableView?.reloadData()
//
//            })
            
            
        }
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: kLeftheaderHeight, width: headerView.bounds.width, height: kLeftTableViewHeight), style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.themeColor()
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
         zbtableView = tableView
        view.addSubview(headerView)
        footerView.backgroundColor = UIColor.red
        view.addSubview(footerView)


        rightDataArray = [ "0项","0.0元"]
  
        NotificationCenter.default.addObserver(self, selector: #selector(gotProfile(notification:)), name: NSNotification.Name(rawValue: "gotProfile"), object: nil)
        
        
    }
    
   
    
    
    /// 点击了加号按钮
    @objc  func gotProfile(notification: Notification) {
        

        
        
        let login = UserDefaults.standard.object(forKey: ZBLOGIN_KEY)! as! Bool
        
        
        
        if     login  { //已经登录
            var dic  = notification.userInfo!["key"]!  as!  [String : JSON]
            let finished = "\(dic["finished"]!.stringValue)项"
            let account = "\(dic["account"]!.stringValue)元"
             self.rightDataArray = [ finished, account]
            
              userNameL.text = User.GetUser().nickname
        }else{
              self.rightDataArray = [ "0项","0.0元"]
             userNameL.text = "请登录"
        }
        

        self.zbtableView?.reloadData()
        
      
    }

    // MARK: - UITableViewDataSource,UITableViewDelegate
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let identifier = "leftCell"
        let cell = ZBLeftCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: identifier)
        
        cell.listName = dataArray[indexPath.row]
        cell.rightListName = rightDataArray[indexPath.row]
         cell.leftListName = leftDataArray[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            //已经完成的任务
           
            
            if UserDefaults.standard.bool(forKey: ZBLOGIN_KEY)  { //已经登录
                  NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "pushfinish")))
            }else{                //未登录
                
                 NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "gologin")))
            }
     
        }else if   indexPath.row == 1{
            
            if UserDefaults.standard.bool(forKey: ZBLOGIN_KEY)   { //已经登录
                NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "pushfinishhh")))
            }else{                //未登录
                
               NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "gologin")))
            }
            
            
        }
    }
    
    
    
  
}
