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
import SwiftyJSON
import MJRefresh
import StoreKit
import SVProgressHUD
import MBProgressHUD
import UserNotificationsUI


class TasksViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate{

    var tableView : UITableView?
    fileprivate var array = [TopicTitle]()
    var leftBtn :UIButton?
   fileprivate var dataArray = [Tasks]()
  
    var storyBoardBanner: LLCycleScrollView!
    
    
    
    
    
    var appStoreUrl :String?
     var force_update :String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        setRefresh()
        JANALYTICSService.startLogPageView("TasksViewController")


    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        JANALYTICSService.stopLogPageView("TasksViewController")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutDecisionByNetwork()
         setupNavBar()
        addNotifications()
        checkupdate ()
        
 
        cw_registerShowIntractive(withEdgeGesture: false, direction: .left) {
            
            self.tapped(UIButton())
        }
        
        
        
    }
    
    func layoutDecisionByNetwork(){
        
        let reachability = Reachability()  // 准备获取网络连接信息
        if (reachability?.isReachable)! { // 判断网络连接状态

                setupTableVie()
           
             setRefresh()
            
            
        } else {
            //no_network_Page
            let box = UIView()
            box.backgroundColor = UIColor.white
            self.view.addSubview(box)
            box.snp.makeConstraints { (make) -> Void in
                make.edges.equalToSuperview()
                
            }
            
            
            let errorV = UIImageView()
            errorV.image = UIImage.init(named: "net_error")
            box.addSubview(errorV)
            errorV.snp.makeConstraints { (make) -> Void in
                make.centerX.equalTo(box.snp.centerX)
                make.centerY.equalTo(box.snp.centerY).offset(-screenHeight / 7)
                make.width.equalTo(87.5)
                make.height.equalTo(87.5)
            }
            
            
            let errorL = UILabel()
            errorL.text = "您的网络出现了故障，请检查网络哦~"
            errorL.textColor = UIColor.colorWithHexString(Color_Value: "#999999", alpha: 1)
            errorL.font = UIFont.systemFont(ofSize: 17)
            box.addSubview(errorL)
            errorL.snp.makeConstraints { (make) in
           
                make.centerX.equalTo(box.snp.centerX)
                make.centerY.equalTo(box.snp.centerY)
                make.width.equalTo(300)
                make.height.equalTo(30)
            }
            
            let button:UIButton = UIButton(type:.custom)
            button.setTitle("重新加载", for:.normal) //普通状态下的文字
            button.backgroundColor = UIColor.colorWithHexString(Color_Value: "d9d9d9", alpha: 1)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.layer.cornerRadius = kScornerRadius
            button.layer.masksToBounds = true
            button.setTitleColor(UIColor.colorWithHexString(Color_Value: "666666", alpha: 1), for: .normal) //普通状态下文字的颜色
            button.addTarget(self, action: #selector(reConectNetForwork), for: .touchUpInside)
            self.view.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.width.equalTo(100)
                 make.height.equalTo(45)
                make.centerX.equalTo(box.snp.centerX)
                make.centerY.equalTo(box.snp.centerY).offset(screenHeight / 6)

            }
        }
    }
    
    func addNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkDetail(notification:)), name: NSNotification.Name(rawValue: "checkDetail"), object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(closeTheDrawer), name: NSNotification.Name(rawValue: "closeTheDrawer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushfinish), name: NSNotification.Name(rawValue: "pushfinish"), object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(pushfinishhh), name: NSNotification.Name(rawValue: "pushfinishhh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushsetting), name: NSNotification.Name(rawValue: "pushsetting"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "refresh"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(gologin), name: NSNotification.Name(rawValue: "gologin"), object: nil)
        
          NotificationCenter.default.addObserver(self, selector: #selector(forceLogout), name: NSNotification.Name(rawValue: "forceLogout"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(withdraw), name: NSNotification.Name(rawValue: "withdraw"), object: nil)
        
    }
    
    
    @objc  func   withdraw(){
        
//               QQDRrawerViewController.sharedDrawerViewController.closeDrawer(closeDrawerWithDuration: 0.2)
        
        
                self.dismiss(animated: true, completion: nil)
        
        
        if UserDefaults.standard.bool(forKey: ZBLOGIN_KEY){
        
            let bank_card  = User.GetUser().bank_card as! NSString

            if bank_card.length > 3 {

                var str = SecureTool.finalStr(short_url: "encashment", full_url: API_ENCASHMENT_URL)
                SVProgressHUD.show()
                
                str = "\(str)&id=\(User.GetUser().id!)"
                
                Alamofire.request(str, parameters: nil ).responseJSON { (response) in
                    //判断是否成功
                    guard response.result.isSuccess else {
                        return
                    }
                    SVProgressHUD.dismiss()
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                                            /*
                                             {
                                                 data =     {
                                                     id = 3;
                                                     "is_success" = "-1"; 1：失败 2：成功
                                                     money = 2;
                                                     remarks = "";
                                                     status = 0; 状态 0：请等待 1：已受理 2：处理完成 3：可开始新一次提现
                                                     };
                                                 errorno = 0;
                                                 message = success;
                                             }
                                             */
                        print(json)
                        
                        if  json["message"].stringValue == "success" {
                        
                            let data = json["data"].dictionaryValue

                            if data == [:] {
                                let withdraw =  ZBReadytToDrawController()
                                self.navigationController?.pushViewController(withdraw, animated: true)
                                return
                            }
                            
                            let status  :Int = (data["status"]?.intValue)!
                            switch status {
                            case 0 ,1,2 :  //请等待
                                let withdraw =  ZBDrawController()
                                withdraw.status = status
                                withdraw.is_success =  (data["is_success"]?.intValue)!
                                withdraw.money  = (data["money"]?.intValue)!
                                withdraw.remarks  = (data["remarks"]?.stringValue)!
                                self.navigationController?.pushViewController(withdraw, animated: true)
                                
                            
                            case 3  :  //可开始新一次提现
                                let withdraw =  ZBReadytToDrawController()
                                self.navigationController?.pushViewController(withdraw, animated: true)
                                
                                
                            default :
                                print( "默认 case")
                            }
                       }
                    }
                }
            
            }else{

                if UserDefaults.standard.bool(forKey: SETBANK)       {    //绑定了

                    let withdraw =  ZBReadytToDrawController()
                    withdraw.name = UserDefaults.standard.object(forKey: USER_BANK_NAME) as! String
                    withdraw.card = UserDefaults.standard.object(forKey: USER_BANK_CARD) as! String
                    withdraw.bankBranch = UserDefaults.standard.object(forKey: BANK_BRANCH) as! String
                    
                    
                    navigationController?.pushViewController(withdraw, animated: true)

                }else {  //未绑定
                    let withdraw =  ZBWithDrawController()
                    navigationController?.pushViewController(withdraw, animated: true)
                }
            }
            
      
            
        }else{

            
            let nav = ZBNavVC.init(rootViewController: ZBLoginController())
            present(nav, animated: true, completion: nil)
        }
       
    
        
    }
    
    
    @objc  func   forceLogout(){
        
        UserDefaults.standard.set(false, forKey: ZBLOGIN_KEY)
        UserDefaults.standard.synchronize()
        setRefresh()
        
        self.showHint(hint: "您的账号已经在别处登录")
        
        let nav = ZBNavVC.init(rootViewController: ZBLoginController())
        present(nav, animated: true, completion: nil)
        
        
    }
    
    @objc  func   gologin(){
        

        
        self.dismiss(animated: true, completion: nil)
        
                let nav = ZBNavVC.init(rootViewController: ZBLoginController())
                present(nav, animated: true, completion: nil)
    }
    
    
    @objc  func   refresh(){
        
        setRefresh()
        
    }
    
    @objc  func   pushsetting(){
        
        
        //1 close
//        QQDRrawerViewController.sharedDrawerViewController.closeDrawer(closeDrawerWithDuration: 0.2)
        
                self.dismiss(animated: true, completion: nil)
        
        //2.push
        navigationController?.pushViewController(ZBSetingController(), animated: true)
        
    }
    
    
    @objc  func   pushfinish(){
        
                self.dismiss(animated: true, completion: nil)
         //1 close
//        QQDRrawerViewController.sharedDrawerViewController.closeDrawer(closeDrawerWithDuration: 0.2)
        //2.push
        navigationController?.pushViewController(ZBFinishedController(), animated: true)
        
    }
    
    @objc  func   pushfinishhh(){
        
                self.dismiss(animated: true, completion: nil)
        //1 close
//        QQDRrawerViewController.sharedDrawerViewController.closeDrawer(closeDrawerWithDuration: 0.2)
        //2.push
        navigationController?.pushViewController(ZBBanlanceController(), animated: true)
        
    }
    
    @objc  func   closeTheDrawer(){
        //1 close
                self.dismiss(animated: true, completion: nil)
//        QQDRrawerViewController.sharedDrawerViewController.closeDrawer(closeDrawerWithDuration: 0.2)
      let setting =  UIStoryboard.init(name: "ZBSetingController", bundle: nil).instantiateInitialViewController()
        //2.push
        navigationController?.pushViewController(setting!, animated: true)
    }
    
    
    @objc  func   reConectNetForwork(){
        
        
        
        let reachability = Reachability()  // 准备获取网络连接信息
        if (reachability?.isReachable)! { // 判断网络连接状态
         
            setupTableVie()
            setRefresh()
            
        } else {
            

        }
        
       
    }
    
    
    /// 点击了加号按钮
  @objc  func checkDetail(notification: Notification) {
//

    }
    
    
    func setupNavBar() {

        
        tableView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: kNavBarHeight, right: 0);
        
        let barColor = UIColor.themeColor()
        navigationController?.navigationBar.barTintColor = barColor;
        
        navigationController?.navigationBar.isTranslucent = false;
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
            ] //UIFont(name: "Heiti SC", size: 24.0)!
        

        let  m_shareImage = UIImageView.init(frame: CGRect(x:0,y:5,width:24 , height:24))
        m_shareImage.image = UIImage.init(named: "形状-1")
         m_shareImage.contentMode = .scaleAspectFit
        let btShare = UIButton.init(type: .custom)
        btShare.bounds = m_shareImage.bounds
        btShare.addSubview(m_shareImage)
        

      btShare.addTarget(self, action:#selector(tapped(_:)), for:.touchUpInside)
        leftBtn = btShare
        navigationItem.leftBarButtonItem =  UIBarButtonItem.init(customView: btShare)
        navigationItem.title = "i兼职";
        
    }
    func tapped(_ button:UIButton){

//        QQDRrawerViewController.sharedDrawerViewController.openDrawer(openDrawerWithDuration: 0.2)
        
 
        cw_showDrawerViewController(ZBLeftViewController(), animationType: .default, configuration: nil)
        
    }
    /// 打开抽屉效果
    func openDrawer(){
        QQDRrawerViewController.sharedDrawerViewController.openDrawer(openDrawerWithDuration: 0.2)
 
    }

    /// 遮罩按钮手势的回调
    func panGestureRecognizer(pan: UIPanGestureRecognizer) {
        QQDRrawerViewController.sharedDrawerViewController.panGestureRecognizer(pan: pan)
        
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupTableVie()   {
        
        
        
        
        
//        if UserDefaults.standard.bool(forKey: ZBLOGIN_KEY) {
            tableView = UITableView(frame:  CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height ), style: UITableViewStyle.plain)
            tableView?.dataSource = self
            tableView?.delegate = self
            tableView?.separatorStyle = .none
            self.view.addSubview(tableView!)
            view.backgroundColor = UIColor.globalBackgroundColor()
            
            
//        }else {
//
//
//        }
        
        
        
  
        // 网络图，本地图混合
        let imagesURLStrings = [
            "s3.jpg",
            "http://www.g-photography.net/file_picture/3/3587/4.jpg",
            "http://img2.zjolcdn.com/pic/0/13/66/56/13665652_914292.jpg",
            "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",
            "http://img3.redocn.com/tupian/20150806/weimeisheyingtupian_4779232.jpg",
            ];
        
        
        
       let   banner  =  LLCycleScrollView()
         banner.frame = CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.width, height: 190 )
        self.storyBoardBanner = banner
        self.storyBoardBanner.imagePaths = imagesURLStrings
        self.storyBoardBanner.imageViewContentMode = .scaleToFill
        self.storyBoardBanner.pageControlPosition = .center
//        self.view.addSubview( self.storyBoardBanner)
        
        self.tableView?.tableHeaderView = self.storyBoardBanner
        
        
        
       
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "我的圈子 >"
    }
    
   
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //每一块有多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let identifier = "mainCell"
        let cell = TasksCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: identifier)

         cell.type = "1"
        cell.viewModel = dataArray[indexPath.row]
       
        return cell

    }
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160;
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK:========  点击cell============
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
         tableView.deselectRow(at: indexPath, animated: true)
        
        

//        print(UserDefaults.standard.bool(forKey: ZBLOGIN_KEY))
        
//        if UserDefaults.standard.bool(forKey: ZBLOGIN_KEY)   { //已经登录 做任务
        
            if    dataArray[indexPath.row].status == "-1"  {  //任务可开始
               
                
                
             
                    
                    let taskDetailController = ViewController()
                    taskDetailController.taskid =  dataArray[indexPath.row].id
                    taskDetailController.taskName =  dataArray[indexPath.row].title
                    taskDetailController.status =  dataArray[indexPath.row].status
                    self.navigationController?.pushViewController(taskDetailController, animated: true)
               
                
            
            
                
            }else if    dataArray[indexPath.row].status == "0"  { //任务审核中
                 self.navigationController?.pushViewController(ZBTaskUnderReviewController(), animated: true)

     
            }else if    dataArray[indexPath.row].status == "1"  { //任务失败
                
                
                let fail = ZBTaskFailController()
                fail.taskid = dataArray[indexPath.row].id
                self.navigationController?.pushViewController(fail, animated: true)
                
                
                
            }
            

        
    }
    
    
     // MARK:========  版本更新============
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


extension TasksViewController {
    
    
    /// 设置上拉和下拉刷新
    @objc fileprivate func setRefresh() {
      
        
        let header = RefreshHeder(refreshingBlock: { [weak self] in  //自定义的header
       
            var str = ""
            let login = UserDefaults.standard.object(forKey: ZBLOGIN_KEY)! as! Bool
            self?.tableView?.mj_footer.resetNoMoreData()
            if     login  { //已经登录
                  str = "\(API_GETTASKLIST_URL)?userid=\(User.GetUser().id!)"
            }else{                //未登录
               str = API_GETTASKLIST_URL
            }
            
            
            NetworkTool.getTaskList(url: str, completionHandler: { (json) in
                /*
                "status" : -1,
                "id" : 26,
                "title" : "天值基金开户",
                "deadline" : "2017-10-20 10:33:26",
                "price" : "6.00",
                "start_time" : "2017-09-29 10:33:26"
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
        

        
    
        
        tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            var str = ""
            let login = UserDefaults.standard.object(forKey: ZBLOGIN_KEY)! as! Bool
            if     login  { //已经登录
                
                let task    = self?.dataArray.last
                str = "\(API_GETTASKLIST_URL)?userid=\(User.GetUser().id!)&id=\(task?.id ?? "10")"
            }else{                //未登录
                
                let task    = self?.dataArray.last
                str = "\(API_GETTASKLIST_URL)?id=\(task?.id ?? "10")"
            }
            
            
            NetworkTool.getTaskList(url: str, completionHandler: { (json) in
                /*
                 "status" : -1,
                 "id" : 26,
                 "title" : "天值基金开户",
                 "deadline" : "2017-10-20 10:33:26",
                 "price" : "6.00",
                 "start_time" : "2017-09-29 10:33:26"
                 */
                self?.tableView?.mj_footer.endRefreshing()
                let dataArr  = json["data"].arrayValue
                
                
                if dataArr.count < 10 {
                    self?.tableView?.mj_footer.endRefreshingWithNoMoreData()
                }
                
                var temparr = [Tasks]()
                for dict    in dataArr{
                    print(dict)
                    let task    = Tasks.init(dictt: (dict.dictionaryValue  ))
                    temparr.append(task)
                }
                
                self?.tableView?.mj_header.endRefreshing()
                self?.dataArray.append(contentsOf: temparr)
                self?.tableView?.reloadData()
                
            })
        })
    }
    
    
    
    
}



