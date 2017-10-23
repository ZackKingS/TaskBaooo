//
//  QQDrawerViewController.swift
//  QQDRAWER_SWIFT
//
//  Created by zzy on 2016/10/30.
//  Copyright © 2016年 BlackSky. All rights reserved.
//

import UIKit
import AdSupport
import SwiftyJSON
class QQDRrawerViewController: UIViewController {

    //  创建单例
    static let sharedDrawerViewController = QQDRrawerViewController()
    
    var leftViewController: ZBLeftViewController?

    var mainViewController: ZBNavVC?
 
    var maxWidth: CGFloat?
    
    var switchViewController: UIViewController?
    
    var coverButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCoverButton()
        
        view.backgroundColor = UIColor.white;
        
        self.leftViewController?.view.transform = CGAffineTransform.init(translationX: -maxWidth!, y: 0)
        
        for childViewController in (mainViewController?.childViewControllers)! {
            addScreenEdgePanGestureRecognizer(view: childViewController.view)
        }
    }
    
    /// 创建遮罩按钮
    func setCoverButton() {
        
        guard self.coverButton != nil else {
            //  创建遮罩按钮
            let coverButton = UIButton.init()
            
            coverButton.setBackgroundImage(UIImage.init(named: "bg"), for: .normal)
            
            coverButton.alpha = 0.4
            self.coverButton = coverButton
            coverButton.frame = CGRect.init(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            coverButton.addTarget(self, action: (#selector(QQDRrawerViewController.closeDrawer)), for: .touchUpInside)
            addPanGestureRecognizer(view: coverButton)
            return
        }
    }
 

    class func drawerWithViewController(_leftViewcontroller : ZBLeftViewController,_mainViewController : ZBNavVC, DrawerMaxWithd: CGFloat) -> QQDRrawerViewController{
        let drawerViewController = QQDRrawerViewController.sharedDrawerViewController
        
        drawerViewController.leftViewController = _leftViewcontroller
        drawerViewController.mainViewController = _mainViewController
        drawerViewController.maxWidth = DrawerMaxWithd
        
        drawerViewController.view.addSubview(_leftViewcontroller.view)
        drawerViewController.addChildViewController(_leftViewcontroller)
        
        drawerViewController.view.addSubview(_mainViewController.view)
        drawerViewController .addChildViewController(_mainViewController)
        
        return drawerViewController
    }
    
    /// 添加边缘手势
    ///
    /// - parameter view: 添加边缘手势的view
    func addScreenEdgePanGestureRecognizer(view: UIView) {
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: (#selector(QQDRrawerViewController.screenEdgePanGestureRecognizer(pan:))))
        pan.edges = UIRectEdge.left
        view.addGestureRecognizer(pan)
    }
    
    /// 边缘手势的回调
    ///
    /// - parameter pan: 边缘手势
    func screenEdgePanGestureRecognizer(pan: UIScreenEdgePanGestureRecognizer) {
        
        let offsetX = pan.translation(in: pan.view).x
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: { 
            if pan.state == UIGestureRecognizerState.changed && offsetX < self.maxWidth! {
                self.mainViewController?.view.transform = CGAffineTransform.init(translationX: offsetX, y: 0)
                self.leftViewController?.view.transform = CGAffineTransform.init(translationX: -self.maxWidth! + offsetX, y: 0)
            }else if pan.state == .cancelled || pan.state == .ended || pan.state == .failed {
                if offsetX > UIScreen.main.bounds.width * 0.5 {
                    self.openDrawer(openDrawerWithDuration: (self.maxWidth! - offsetX)/self.maxWidth! * 0.2)
                }else {
                    self.closeDrawer(closeDrawerWithDuration: offsetX / self.maxWidth! * 0.2)
                }
            }
        });
        
    }
    
    /// 打开抽屉
    func openDrawer(openDrawerWithDuration: CGFloat) {
        
        
        
        
        let login = UserDefaults.standard.object(forKey: ZBLOGIN_KEY)! as! Bool
        
        
        
        if     login  { //已经登录
            let url = "/v1/user/profile"
            let key = SecureTool.reKey(url: url)
            let timestamp :String = SecureTool.reTimestamp()
            let uuid = ASIdentifierManager.shared().advertisingIdentifier.uuidString as NSString
            let    str = "\(API_GETPROFILE_URL)?id=\(User.GetUser().id!)&key=\(key)&t=\(timestamp)&imei=\((uuid as String))"
            NetworkTool.getTaskList(url: str, completionHandler: { (json) in
                
                print(json)
                
                if json["message"].stringValue != "success"{
                    
                    return
                }
                
                 let dataArr  = json["data"].dictionaryValue
                
                if  dataArr["account"] == nil    ||  dataArr["finished"] == nil  {
                    return
                    
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotProfile"), object: self, userInfo: ["key": dataArr])
                
                
            })
        }else{                //未登录
           let    dataArr  = ["account":"0.0","finished":"0"]
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotProfile"), object: self, userInfo: ["key": dataArr])
        }
        
        
        UIView.animate(withDuration: TimeInterval(openDrawerWithDuration), delay: 0, options: .curveLinear, animations: {
            self.mainViewController?.view.transform = CGAffineTransform.init(translationX: self.maxWidth!, y: 0)
            self.leftViewController?.view.transform = CGAffineTransform.identity
            }) { (Bool) in
                
                self.setCoverButton()  /// 遮罩
                
                self.mainViewController?.view.addSubview(self.coverButton!)
        };
    }
    
    /// 关闭抽屉
    func closeDrawer(closeDrawerWithDuration: CGFloat) {
        UIView.animate(withDuration: TimeInterval(closeDrawerWithDuration), delay: 0, options: .curveLinear, animations: {
            self.leftViewController?.view.transform = CGAffineTransform.init(translationX: -self.maxWidth!, y: 0)
            self.mainViewController?.view.transform = CGAffineTransform.identity
        }) { (Bool) in
            self.coverButton?.removeFromSuperview()
            self.coverButton = nil
        };
    }
    
 
    
    /// 给遮罩按钮添加拖拽手势
    ///
    /// - parameter view: 遮罩按钮

    func addPanGestureRecognizer(view: UIView) {
        let pan = UIPanGestureRecognizer.init(target: self.mainViewController, action: (#selector(ZBNavVC.panGestureRecognizer(pan:))))
        view.addGestureRecognizer(pan)
    }
    
    
    /// 拖动手势处理
    func panGestureRecognizer(pan: UIPanGestureRecognizer) {
        let offsetX = pan.translation(in: pan.view).x
        
        if pan.state == .cancelled || pan.state == .failed || pan.state == .ended {
            
            if offsetX < 0 , UIScreen.main.bounds.width - self.maxWidth! + abs(offsetX) > UIScreen.main.bounds.width * 0.5{
                closeDrawer(closeDrawerWithDuration: (self.maxWidth! + offsetX) / self.maxWidth! * 0.2)
            }else{
                openDrawer(openDrawerWithDuration:abs(offsetX) / self.maxWidth! * 0.2)
            }
            
        }else if pan.state == .changed{
            if offsetX < 0 , offsetX > -self.maxWidth! {
                mainViewController?.view.transform = CGAffineTransform.init(translationX: self.maxWidth! + offsetX, y: 0)
                leftViewController?.view.transform = CGAffineTransform.init(translationX: offsetX, y: 0)
            }
        }
        
    }
    
    /// 选择左侧菜单进行跳转
    ///
    /// - parameter viewController: 跳转目标控制器
    func switchViewController(viewController: UIViewController) {
        addChildViewController(viewController)
        switchViewController = viewController
        viewController.view.transform = CGAffineTransform.init(translationX: UIScreen.main.bounds.width, y: 0)
        view.addSubview(viewController.view)
        
        UIView.animate(withDuration: 0.2) { 
            viewController.view.transform = CGAffineTransform.identity
        };
        
    }
    
    /// 返回到左侧控制器
    func switchBackMainViewController() {
        
        UIView.animate(withDuration: 0.2, animations: { 
            self.switchViewController?.view.transform = CGAffineTransform.init(translationX: UIScreen.main.bounds.width, y: 0)
            }) { (Bool) in
                self.switchViewController?.removeFromParentViewController()
                self.switchViewController?.view.removeFromSuperview()
        }
   }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
 

}
