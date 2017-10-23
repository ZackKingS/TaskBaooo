//
//  ZBLeftCell.swift
//  task
//
//  Created by 柏超曾 on 2017/9/25.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation
import UIKit

class ZBLeftCell: UITableViewCell {
    
    
    

    var listName: String?{
        
        didSet{
            jokeLabel.text = listName
        }
        
    }
    
    
    var rightListName: String?{
        didSet{
            rightJokeLabel.text = rightListName
        }
    }
    var leftListName: String?{
        didSet{
            leftIcon.image = UIImage.init(named: leftListName!)
        }
    }
    
    
    var jokeLabel: UILabel!
    
    var rightJokeLabel: UILabel!
    
     var leftIcon: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {// 代码创建
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
//        self.backgroundView = UIImageView.init(image: UIImage.init(named: "组-3"))
    }
    
    

    
    func setupUI()  {
        
        
        self.backgroundColor = UIColor.themeColor()
        
        
        
        let topLinbe = UIView()
        topLinbe.backgroundColor = UIColor.white
        self.addSubview(topLinbe)
        topLinbe.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
            make.height.equalTo(0.4)
        }
        
        
        let leftIconV = UIImageView()
        leftIcon = leftIconV
        self.addSubview(leftIconV)
        leftIconV.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(14)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(15)
            make.width.equalTo(15)
        }
        
        
        let taskNameL = UILabel()
        jokeLabel = taskNameL
        taskNameL.text = "余额"
        taskNameL.textColor = UIColor.white
        taskNameL.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(taskNameL)
        taskNameL.snp.makeConstraints { (make) in
//            make.top.equalTo(self).offset(5)
            make.left.equalTo(self).offset(40)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        let rightList = UILabel()
        
        rightJokeLabel = rightList
        
        rightList.text = "51.4元"
        rightList.textColor = UIColor.white
        rightList.font = UIFont.systemFont(ofSize: 17)
        rightList.textAlignment = .right
        self.addSubview(rightList)
        rightList.snp.makeConstraints { (make) in
            //            make.top.equalTo(self).offset(5)
//            make.left.equalTo(self).offset(kMaxLeftOffset - 55)
            
            make.right.equalTo(self).offset( -screenWidth / 4  - 70 )
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        

    }
    
}
