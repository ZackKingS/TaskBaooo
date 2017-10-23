//
//  ZBTabbarVC.swift
//  go
//
//  Created by 柏超曾 on 2017/9/14.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit
class ZBTabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
            addChildViewControllers()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        if let views = tabBarController?.tabBar.subviews {
            views[views.count - 1].removeFromSuperview()   //去掉TabBar中的横线
            views[0].removeFromSuperview()                 //去掉TabBar中的背景
        }

    }

    private func addChildViewControllers(){
        
        
        addChildViewController(childController: TasksViewController(), title: "adv")
        addChildViewController(childController: MeVC(), title: "me")
        
    }
    
    private func addChildViewController(childController: UIViewController, title: String){
        childController.title = title
        let navC = ZBNavVC(rootViewController: childController)
        navC.navigationItem.title = title
        addChildViewController(navC)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
