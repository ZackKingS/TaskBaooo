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
class TasksCell: UITableViewCell {
    
    var type :String?
    
    var task_NameL :UILabel?
    
    var price_L :UILabel?
    
        var rightTop_L :UILabel?
    
     var date_L :UILabel?
    
     var bgV :UIImageView?
    var fini :UIImageView?
    
    
    
    // MARK:- 自定义属性
    var viewModel : Tasks? {
        didSet {
            // 1.nil值校验
            guard let viewModel = viewModel else {
                return
            }
            

            task_NameL?.text = viewModel.title
            
            price_L?.text = viewModel.price
  
            
            if (type == "1") {
            
                
                let start = viewModel.start_time!.components(separatedBy: " ").first
                let end =  viewModel.deadline!.components(separatedBy: " ").first
                 
//                date_L?.text = viewModel.start_time! + " - " +  viewModel.deadline!
                
                date_L?.text = start! + " - " +  end!
                fini?.isHidden = true
                rightTop_L?.isHidden = false

            }else if type == "2" {
            
                 date_L?.text = "\(viewModel.create_time! )已完成该任务"
                     fini?.isHidden = false
                
                
                rightTop_L?.isHidden = true
                bgV?.image = UIImage.init(named: "mission_orange")
                
                
            }else if type == "3" {
                
                   rightTop_L?.isHidden = true
                
            }
            
            
            if viewModel.status == "-1" {
                rightTop_L?.text = "可开始"
                rightTop_L?.backgroundColor = UIColor.colorWithHexString(Color_Value: "508cee", alpha: 1)
                bgV?.image = UIImage.init(named: "mission_blue")
                
                
            }else if  viewModel.status == "0" {
                 rightTop_L?.text = "进行中"
                 rightTop_L?.backgroundColor = UIColor.colorWithHexString(Color_Value: "fc7979", alpha: 1)
                
                bgV?.image = UIImage.init(named: "mission_red")
           
                
            }
            else if  viewModel.status == "1" {
                rightTop_L?.text = "进行中"
                rightTop_L?.backgroundColor = UIColor.colorWithHexString(Color_Value: "fc7979", alpha: 1)
                
                bgV?.image = UIImage.init(named: "mission_red")
                
                
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
        
        let grayView = UIImageView.init(image: UIImage.init(named: "mission_blue"))
        addSubview(grayView)
        bgV = grayView
        grayView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(15)
            make.bottom.equalTo(self).offset(-5)
            make.right.equalTo(self).offset(-15)
        }
        
        
        
        let finiV = UIImageView.init(image: UIImage.init(named: "mytask_complete"))
        addSubview(finiV)
        fini = finiV
        finiV.snp.makeConstraints { (make) in

            make.right.equalTo(self).offset(-55)
            make.centerY.equalTo(self)
            make.width.equalTo(70)
            make.height.equalTo(50)
        }
        
        
        let taskNameL = UILabel()
        task_NameL = taskNameL
        taskNameL.text = "恒泰开户"
        taskNameL.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(taskNameL)
        taskNameL.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(17)
            make.left.equalTo(self).offset(35)
            make.width.equalTo(250)
            make.height.equalTo(30)
        }
        
        
        let priceL = UILabel()
        price_L = priceL
        priceL.text = "¥ 20"
        priceL.font = UIFont.systemFont(ofSize: 20)
        self.addSubview(priceL)
        priceL.snp.makeConstraints { (make) in

            make.top.equalTo(taskNameL.snp.bottom).offset(2)
            make.left.equalTo(self).offset(35)
            make.width.equalTo(100)
            make.height.equalTo(70)
        }
        
        
        
        let rightTopL = UILabel()
        rightTop_L = rightTopL
        rightTopL.text = "可开始"
        rightTopL.textAlignment = .center
        rightTopL.font = UIFont.systemFont(ofSize: 14)
        rightTopL.textColor = UIColor.white
        rightTopL.backgroundColor = UIColor.colorWithHexString(Color_Value: "508cee", alpha: 1)
        addSubview(rightTopL)
        rightTopL.frame = CGRect(x:screenWidth - 73, y:24, width:54,height : 24)
        let   corner  :UIRectCorner = UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.topLeft.rawValue) |  UInt8(UIRectCorner.bottomLeft.rawValue)));//这只圆角位置
        let  path = UIBezierPath.init(roundedRect: rightTopL.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width:5,height:5))
        let masklayer = CAShapeLayer()
        masklayer.frame = rightTopL.bounds;
        masklayer.path = path.cgPath;//设置路径
        rightTopL.layer.mask = masklayer
        
        
        
        let dateL = UILabel()
        date_L = dateL
        dateL.text = "2017.09.13 - 2017.03.30"
        dateL.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(dateL)
        dateL.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-15)
            make.left.equalTo(self).offset(35)
            make.width.equalTo(300)
            make.height.equalTo(15)
        }
        
        

        let button:ZBButton = ZBButton(type:.custom)
        button.setTitle("查看", for:.normal) //普通状态下的文字
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.colorWithHexString(Color_Value: "ff821e", alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(push), for: .touchUpInside)
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-15)
            make.right.equalTo(self).offset(-35)
            make.width.equalTo(43)
            make.height.equalTo(30)
        }
        
        
        
        
        let checkView = UIImageView.init(image: UIImage.init(named: "right_arr"))
        addSubview(checkView)
        checkView.snp.makeConstraints { (make) in
            make.leading.equalTo(button.snp.trailing).offset(-1)
            make.centerY.equalTo(button.snp.centerY)
            make.width.equalTo(10)
            make.height.equalTo(10)

        }
        
       
        
    }
    func push(){
        

    }
 
    
    override func awakeFromNib() {  // XIB代码创建
        super.awakeFromNib()
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setHighlighted(isHighlighted, animated: true)

    }

}
