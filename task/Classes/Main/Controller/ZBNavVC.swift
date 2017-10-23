//
//  ZBNavVC.swift
//  go
//
//  Created by 柏超曾 on 2017/9/14.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit
class ZBNavVC: UINavigationController {

    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = UIColor.themeColor()
        navBar.tintColor =  UIColor.red// UIColor(r: 94, g: 94, b: 94, alpha: 1)
        navBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
        // 创建全局手势
        initGlobalPan()
    
    }
    
   
    
    /// 打开抽屉效果
    func openDrawer(){
        QQDRrawerViewController.sharedDrawerViewController.openDrawer(openDrawerWithDuration: 0.2)
        
        
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "leftClicked")))
        
    }
    
    /// 遮罩按钮手势的回调
    ///
    /// - parameter pan: 手势
    func panGestureRecognizer(pan: UIPanGestureRecognizer) {
        QQDRrawerViewController.sharedDrawerViewController.panGestureRecognizer(pan: pan)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 拦截 push 操作
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(navigationBack))
        }
        super.pushViewController(viewController, animated: true)
    }
    
    @objc private func navigationBack() {
        popViewController(animated: true)
    }
}



// 全局手势返回
extension ZBNavVC:UIGestureRecognizerDelegate {
    /// 全局拖拽手势
    fileprivate func initGlobalPan(){
        // 1.创建Pan手势
        let target = interactivePopGestureRecognizer?.delegate
        let globalPan = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        globalPan.delegate = self
        self.view.addGestureRecognizer(globalPan)
        // 2.禁止系统的手势
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    /// 什么时候支持全屏手势
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.childViewControllers.count != 1
    }
}
