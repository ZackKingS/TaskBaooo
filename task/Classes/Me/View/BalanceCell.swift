//
//  TasksCell.swift
//  task
//
//  Created by 柏超曾 on 2017/9/22.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
class BalanceCell: UITableViewCell {
    
  
    
    var task_NameL :UILabel?
    
    var price_L :UILabel?
    
    var date_L :UILabel?
    
 
    
    
    
    // MARK:- 自定义属性
    var viewModel : Tasks? {
        didSet {
            // 1.nil值校验
            guard let viewModel = viewModel else {
                return
            }
            
            task_NameL?.text = viewModel.descriptionz
            
            
            if viewModel.plus_or_minus == "1"{
                
                price_L?.text = "+ \(viewModel.money!)"
            }else  if viewModel.plus_or_minus == "-1" {
              price_L?.text = "- \(viewModel.money!)"
            }
            
            
            
        

             date_L?.text = "\(viewModel.create_time! )"
            
        }
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {// 代码创建
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
        
    }
    
    
    func setupUI()  {
        
      
        
        
        let taskNameL = UILabel()
        
        task_NameL = taskNameL
        taskNameL.text = "恒泰开户"
        taskNameL.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(taskNameL)
        taskNameL.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(17)
            make.left.equalTo(self).offset(35)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        
        let priceL = UILabel()
        price_L = priceL
        priceL.text = "+ 20"
        priceL.font = UIFont.systemFont(ofSize: 20)
        self.addSubview(priceL)
        priceL.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(70)
        }
      
        
        let dateL = UILabel()
        date_L = dateL
        
        dateL.text = "2017.09.13 - 2017.03.30"
        dateL.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(dateL)
        dateL.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-15)
            make.left.equalTo(self).offset(35)
            make.width.equalTo(300)
            make.height.equalTo(15)
        }

    }
   
    
    
    override func awakeFromNib() {  // XIB代码创建
        super.awakeFromNib()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setHighlighted(isHighlighted, animated: true)
        //        self.backgroundColor = UIColor.red
    }
   
    
}

