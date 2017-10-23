//
//  TasksViewController.swift
//  go
//
//  Created by 柏超曾 on 2017/9/14.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit
import SwiftTheme
import Alamofire
import AdSupport
import SVProgressHUD

class ZBBanlanceController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var tableView : UITableView?
    fileprivate var array = [TopicTitle]()
    
    fileprivate var dataArray = [Tasks]()
    
    var leftBtn :UIButton?
    
    var taskcountLable :UILabel?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //         设置导航栏颜色
        
       
    }
    
    func checkBalance(){
        
   
       
            let url = "/v1/user/profile"
            let key = SecureTool.reKey(url: url)
            let timestamp :String = SecureTool.reTimestamp()
            let uuid = ASIdentifierManager.shared().advertisingIdentifier.uuidString as NSString
            let    str = "\(API_GETPROFILE_URL)?id=\(User.GetUser().id!)&key=\(key)&t=\(timestamp)&imei=\((uuid as String))"
        
        print(str)
        
            NetworkTool.getTaskList(url: str, completionHandler: { (json) in
                
                let dataArr  = json["data"].dictionaryValue
                print(dataArr["account"] ?? "123")
//                print(dataArr["finished"]!)
                
                if   dataArr["account"] != nil{
                       self.taskcountLable?.text = dataArr["account"]!.stringValue
                }
             
  
            })
      
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupTableVie()
        setRefresh()
        setupNavBar()
        tableView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: kNavBarHeight, right: 0);
        
    }
    
    
    func setRefresh() {
        
        
        let header = RefreshHeder(refreshingBlock: { [weak self] in  //自定义的header
            
            var str = ""
            

            
            let key =  self?.produceKey()
            
            let timestamp :String = (self?.retimestamp())!
            
            let uuid = ASIdentifierManager.shared().advertisingIdentifier.uuidString as NSString
            
            if ZBLOGINED_FLAG    { //已经登录
                str = "\(API_GETIMCOME_URL)?id=\(User.GetUser().id!)&key=\(key!)&t=\(timestamp)&imei=\((uuid as String))"
                
                print(str)
                
            }else{                //未登录
               
                self?.showHint(hint: "请登录")
                return
            }
            
            
            NetworkTool.getTaskList(url: str, completionHandler: { (json) in
                /*
                 money           :    5.00
                 plus_or_minus   :    1
                 description    :    仙人掌开户成功
                 create_time    :    2017-10-09 14:40:11
                 */
                
                let dataArr  = json["data"].arrayValue
                
                var temparr = [Tasks]()
                for dict    in dataArr{
                    print(dict)
                    let task    = Tasks.init(dictt: (dict.dictionaryValue  ))
                    temparr.append(task)
                }
                
                self!.tableView?.mj_header.endRefreshing()
                self!.dataArray = temparr
                self!.tableView?.reloadData()
                
            })
            
        })
        
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView?.mj_header = header
        tableView?.mj_header.beginRefreshing()
        tableView?.mj_header = header
        
        
    }
    
    
    func  retimestamp() -> String{
        
        let nowDate = NSDate(timeIntervalSinceNow: 0)
        // 时间戳的值
        let t:CLong  = CLong(nowDate.timeIntervalSince1970)
        
        let x : Int = Int(t)
        let xNSNumber = x as NSNumber
        let timestamp : String = xNSNumber.stringValue
        
        return timestamp
    }
    
    
    func produceKey() -> String{
        
       var  strr = retimestamp() as NSString
        strr =  strr.substring(from: strr.length - 5) as NSString
        var adId = ASIdentifierManager.shared().advertisingIdentifier.uuidString as NSString
        adId =  adId.substring(from: adId.length - 5)  as NSString
        let key =    ((adId as String) + (strr as String) + ("/v1/user/income".MD5 )).MD5

        return key!
        
    }
    
    
    
    func setupNavBar() {
        
        
        let barColor = UIColor.themeColor()
        navigationController?.navigationBar.barTintColor = barColor;
        
        navigationController?.navigationBar.isTranslucent = false;
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ] //UIFont(name: "Heiti SC", size: 24.0)!
        
        
        navigationItem.title = "账户余额";
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableVie()   {
        tableView = UITableView(frame:  CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height ), style: UITableViewStyle.plain)
        tableView?.dataSource = self
        tableView?.delegate = self
//        tableView?.separatorStyle = .none
        self.view.addSubview(tableView!)
        view.backgroundColor = UIColor.globalBackgroundColor()
      
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //每一块有多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    
    // MARK:======== 头部  ===========
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let inview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 150))
        inview.backgroundColor  = UIColor.white
     
        
        let bordView = UIView()
        inview.addSubview(bordView)
        bordView.snp.makeConstraints { (make) in
            make.top.equalTo(inview).offset(10)
            make.left.equalTo(inview).offset(20)
            make.bottom.equalTo(inview).offset(-5)
            make.right.equalTo(inview).offset(-15)
        }
        
        
        
        let line_v = UIView()
        inview.addSubview(line_v)
        line_v.backgroundColor = UIColor.lightGray
        line_v.snp.makeConstraints { (make) in
            make.height.equalTo(2)
            make.left.equalTo(inview).offset(20)
            make.bottom.equalTo(inview).offset(-5)
            make.right.equalTo(inview).offset(-15)
        }
        
        
   
        
        let finiTasskL = UILabel()
        finiTasskL.text = "账户余额（元）"
        finiTasskL.font = UIFont.systemFont(ofSize: 15)
        inview.addSubview(finiTasskL)
        finiTasskL.snp.makeConstraints { (make) in
            make.top.equalTo(inview).offset(20)
            make.left.equalTo(inview).offset(70)
            make.width.equalTo(200)
            make.height.equalTo(15)
        }
        
        let icon_wallet = UIImageView()
        icon_wallet.image = UIImage.init(named: "wale")
        inview.addSubview(icon_wallet)
        icon_wallet.snp.makeConstraints { (make) in
            make.top.equalTo(inview).offset(20)
            make.left.equalTo(inview).offset(20)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        
        let taskcountL = UILabel()
        taskcountLable = taskcountL
        
        if !UserDefaults.standard.bool(forKey: ZBLOGIN_KEY)   { //已经登录 做任务
               taskcountL.text = "0.00"
        }
        
         checkBalance()
//
//        taskcountL.text = "0.00"
        taskcountL.textAlignment =  .left
        taskcountL.font = UIFont.systemFont(ofSize: 36)
        taskcountL.textColor  =  UIColor.colorWithHexString(Color_Value: "ff821e", alpha: 1)
        inview.addSubview(taskcountL)
        taskcountL.snp.makeConstraints { (make) in
            make.centerY.equalTo(inview.snp.centerY).offset(10)
            make.left.equalTo(inview).offset(70)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        
        
        let button:UIButton = UIButton(type:.custom)
        button.setTitle("立即提现", for:.normal) //普通状态下的文字
        button.backgroundColor = UIColor.colorWithHexString(Color_Value: "e6761c", alpha: 1)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = kScornerRadius
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.white, for: .normal) //普通状态下文字的颜色
        button.addTarget(self, action: #selector(withdrew), for: .touchUpInside)
        inview.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.centerY.equalTo(inview).offset(10)
            make.right.equalTo(inview).offset(-50)
            
        }
        
        
        
        return inview
        
    }
    
    func withdrew(){
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let identifier = "mainCell"
        let cell = BalanceCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: identifier)
     
        cell.viewModel = dataArray[indexPath.row]
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90;
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK:========  点击cell============
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        
        
        
        
    }
}




