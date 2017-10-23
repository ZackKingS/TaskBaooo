//
//  MeVC.swift
//  go
//
//  Created by 柏超曾 on 2017/9/14.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit

import SnapKit

class MeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        view.backgroundColor = UIColor.gray
        
        
        let redview : UIView = {
        
            
            let redview = UIView()
            
            redview.backgroundColor = UIColor.red
            view .addSubview(redview)
            
            redview.snp.makeConstraints { (make) in
                make.top.equalTo(view).offset(kNavBarHeight)
                make.right.equalTo(view).offset(-kNavBarHeight)
                make.left.equalTo(view).offset(kNavBarHeight)
                make.bottom.equalTo(view).offset(-kNavBarHeight)
            }
            
            return redview
        }()
        
        
//        redview.backgroundColor  = UIColor.blue
        
        
       
        
    }
    
    
}
