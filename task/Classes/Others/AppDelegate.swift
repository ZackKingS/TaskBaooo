//
//  AppDelegate.swift
//  task
//
//  Created by 柏超曾 on 2017/9/15.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AdSupport
import UserNotificationsUI


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,JPUSHRegisterDelegate{
   

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        networkStatusManage()
       
        window = UIWindow(frame: UIScreen.main.bounds)

     
        let nav  = ZBNavVC.init(rootViewController: TasksViewController())
        self.window?.rootViewController = QQDRrawerViewController.drawerWithViewController(_leftViewcontroller: ZBLeftViewController.init(),_mainViewController: nav,DrawerMaxWithd: kMaxLeftOffset)
        self.window?.makeKeyAndVisible()
        
        // 检测用户是不是第一次启动
        config()
        
        
        //1. 任务详情的url是写死的
        //2. 跳转appstore更新的url是写死的
       //3. 推送
        configPush(launchOptions  :launchOptions)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkDidReceiveMessage(notification:)),  name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
        
        
      
        JPUSHService.registrationIDCompletionHandler({ (resCode, registrationID) in
            
//            print(registrationID)
            UserDefaults.standard.set(registrationID , forKey: JPushID)
            
        })
        
        
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {
                (granted, error) in
                
                if granted {
                    print("User notifications are allowed.")
                } else {
                    print("User notifications are not allowed.")
                }
            })
        } else {
            // Fallback on earlier versions
        }
        
   
        
        return true
    }
    
    
    

    
  
    @objc  func networkDidReceiveMessage(notification: Notification) {
        
        let userInfo  = notification.userInfo! as NSDictionary
        let content  = userInfo.value(forKey: "content") as! String
        
        print(content)
        
        //"{\"status\":2,\"taskid\":2,\"title\":\"时代财经app下载试用任务\",\"price\":\"1.00\"}"

        let jsonData : Data = content.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! NSDictionary
        if dict != nil {
             let type : NSNumber = dict?.value(forKey: "type") as! NSNumber
            if type == 2 {
                
                print("互踢")

                
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forceLogout"), object: self, userInfo: nil)
                
                
            }else if type == 1 {
                
                print("自定义")
            }

//            let data : NSDictionary = dict?.value(forKey: "data") as! NSDictionary
//
//            let title = data.value(forKey: "title")
//
//            print(title!)
        }

    }
    
    func configPush(launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        
        if #available(iOS 8.0, *) {
            let type: UInt = UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: type, categories: nil)
        } else {
            let type: UInt = UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: type, categories: nil)
        }
        // 参数2: 填你创建的应用生成的AppKey
        // 参数3: 可以不填
        // 参数4: 这个值生产环境为YES，开发环境为NO(BOOL值)
        JPUSHService.setup(withOption: launchOptions, appKey: JPushAppKey, channel: nil, apsForProduction: false)
        
        let config =  JANALYTICSLaunchConfig()
        config.appKey = JPushAppKey
        config.channel = nil
        JANALYTICSService.setup(with: config)
        
    }
    
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        print("willPresent")
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        print("didReceive")
    }
    
    
    // 注册成功后会调用AppDelegate的下面方法，得到设备的deviceToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken as Data!)
        print("Notification token: ", deviceToken)
        
 
    }
    
    
    
    // 处理接收推送错误的情况(一般不会…)
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("error: Notification setup failed: ", error)
    }
    
    
    //app必须在前台才能进到这个方法
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        JPUSHService.handleRemoteNotification(userInfo);
        completionHandler(UIBackgroundFetchResult.newData);
        
        print(userInfo)
        
    }
    
    
    
    
    // 接收到推送实现的方法
    func receivePush(_ userInfo : Dictionary<String,Any>) {
        // 角标变0
        UIApplication.shared.applicationIconBadgeNumber = 0;
        // 剩下的根据需要自定义
//        self.tabBarVC?.selectedIndex = 0;
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName_ReceivePush), object: NotificationObject_Sueecess, userInfo: userInfo)
    }


    

    func config(){
        
        let nowDate = NSDate(timeIntervalSinceNow: 0)
        // 时间戳的值
        let timeStamp:CLong  = CLong(nowDate.timeIntervalSince1970)
        print(timeStamp)
        

        print(UserDefaults.standard.bool(forKey: "LGFirstLaunch"))
        if !UserDefaults.standard.bool(forKey: "LGFirstLaunch") {
            UserDefaults.standard.set(false, forKey: ZBLOGIN_KEY)
            UserDefaults.standard.set(true, forKey: "LGFirstLaunch")
            UserDefaults.standard.synchronize()
        }
        
    }

    func networkStatusManage(){
        let manager = NetworkReachabilityManager(host: "https://www.baidu.com")
        
        manager!.listener = { status in
            switch status {
            case .notReachable:
                print("notReachable")
                UserDefaults.standard.set("a_notReachable_network", forKey: "network")
                
            case .unknown:
                print("unknown")
                UserDefaults.standard.set("b_unknown_network", forKey: "network")
            case .reachable(.ethernetOrWiFi):
                print("ethernetOrWiFi")
                UserDefaults.standard.set("c_ethernetOrWiFi_network", forKey: "network")
                
            case .reachable(.wwan):
                print("wwan")
                UserDefaults.standard.set("d_wwan_network", forKey: "network")
                
                
            }
        }
        manager!.startListening()
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
                UIApplication.shared.applicationIconBadgeNumber = 0
        
        JPUSHService.resetBadge()
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func appVersion(){
        
//        NetworkTool.errorMessage(error: "2333333")
        
        
        // 得到当前应用的版本号
        let infoDictionary = Bundle.main.infoDictionary
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        // 取出之前保存的版本号
        let userDefaults = UserDefaults.standard
        let appVersion = userDefaults.string(forKey: "appVersion")
        let  storyboard = UIStoryboard.init(name: "ZBNewFeatureController", bundle: nil)
        
        
        
                if appVersion == nil || appVersion != currentAppVersion {

                    userDefaults.setValue(currentAppVersion, forKey: "appVersion")
                    let guideViewController = storyboard.instantiateInitialViewController()
                    self.window?.rootViewController = guideViewController
                    self.window?.makeKeyAndVisible()

                }else{

                    let nav  = ZBNavVC.init(rootViewController: TasksViewController())
                    self.window?.rootViewController = QQDRrawerViewController.drawerWithViewController(_leftViewcontroller: ZBLeftViewController.init(),_mainViewController: nav,DrawerMaxWithd: kMaxLeftOffset)
                    self.window?.makeKeyAndVisible()
                }
        
    }
    
    
    deinit {
        
            NotificationCenter.default.removeObserver(NSNotification.Name.jpfNetworkDidReceiveMessage)
    }

}

