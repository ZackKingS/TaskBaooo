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
import SnapKit
class BalanceCell: UITableViewCell {
    
  
    
    var task_NameL :UILabel?
    
    var price_L :UILabel?
    
    var date_L :UILabel?
    
 var icon :UIImageView?
    var leftConstrains: Constraint?
    
    
    // MARK:- 自定义属性
    var viewModel : Tasks? {
        didSet {
            // 1.nil值校验
            guard let viewModel = viewModel else {
                return
            }
            
            if  viewModel.descriptionz == "余额明细" {
                
                self.leftConstrains?.update(offset: 80)
                icon?.isHidden = false

            }else{
                icon?.isHidden = true
            }
            
            task_NameL?.text = viewModel.descriptionz
            task_NameL?.textColor = UIColor.colorWithHexString(Color_Value: "666666", alpha: 1)

            
           
            
            
            
            if viewModel.plus_or_minus == "1"{
                
                price_L?.text = "+ \(viewModel.money!)"
            }else  if viewModel.plus_or_minus == "-1" {
              price_L?.text = "- \(viewModel.money!)"
            }
            
            price_L?.textColor = UIColor.colorWithHexString(Color_Value: "333333", alpha: 1)
            
        
            
            if viewModel.create_time != nil {
                
                date_L?.text = "\(viewModel.create_time! )"
                date_L?.textColor = UIColor.colorWithHexString(Color_Value: "999999", alpha: 1)
            }

            
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
        
      
        
        
        let icon_wallet = UIImageView()
        icon = icon_wallet
        icon_wallet.image = UIImage.init(named: "account_detail_logo")
        self.addSubview(icon_wallet)
        icon_wallet.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(17)
            make.left.equalTo(self).offset(35)
            make.width.equalTo(26)
            make.height.equalTo(26)
        }
        
        
        
        let taskNameL = UILabel()
        
        task_NameL = taskNameL
        taskNameL.text = "恒泰开户"
        taskNameL.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(taskNameL)
        taskNameL.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(17)
//            make.left.equalTo(self).offset(35)
            make.width.equalTo(200)
            make.height.equalTo(30)
            
            self.leftConstrains =   make.left.equalTo(self).offset(35).constraint
            
        }
        

        
        let priceL = UILabel()
        price_L = priceL
        priceL.text = ""
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

