//
//  User.swift
//  task
//
//  Created by 柏超曾 on 2017/9/28.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import SwiftyJSON
import Foundation
class User : NSObject, NSCoding {
   
    
    var  avatar : String?
    var  alipay : String?
    var  credit_card : String?
    var  id : String?
    var  nickname : String?
    var  account : String?
    var  finished : String?
    var  username : String?
    var  email : String?
    var  tel : String?
    var  usersig : String?
   var  bank_card : String?
     var  card_name : String?
    
    // MARK:- 自定义构造函数  KVC实现字典转模型
    init(dict : [String : JSON]) {
        super.init()

        print(dict)
        


         tel =  dict["tel"]?.stringValue as String!
        nickname =  dict["nickname"]?.stringValue as String!
        id =  dict["id"]?.stringValue as String!
        account =  dict["account"]?.stringValue as String!
        finished =  dict["finished"]?.stringValue as String!
        
        bank_card =  dict["bank_card"]?.stringValue as String!
        card_name =  dict["card_name"]?.stringValue as String!
    }
    
   
    
   
    class  func   GetUser() -> User {
      let dataa =     UserDefaults.standard.object(forKey: "user") as! NSData
      let user : User = NSKeyedUnarchiver.unarchiveObject(with: dataa as Data   )  as! User
    
      return user
    
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    
    struct PropertyKey {
        static let id = "id"
        static let nickname = "nickname"
        static let account = "account"
        static let tel = "tel"
       static let finished = "finished"
        
        static let bank_card = "bank_card"
        static let card_name = "card_name"
    }
    


    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: PropertyKey.id) as? String
        nickname = aDecoder.decodeObject(forKey: PropertyKey.nickname) as? String
        tel = aDecoder.decodeObject(forKey: PropertyKey.tel) as? String
        account = aDecoder.decodeObject(forKey: PropertyKey.account) as? String
        finished = aDecoder.decodeObject(forKey: PropertyKey.finished) as? String
        
        bank_card = aDecoder.decodeObject(forKey: PropertyKey.bank_card) as? String
         card_name = aDecoder.decodeObject(forKey: PropertyKey.card_name) as? String
    }



    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(nickname, forKey: PropertyKey.nickname)
        aCoder.encode(tel, forKey: PropertyKey.tel)
        aCoder.encode(finished, forKey: PropertyKey.finished)
        aCoder.encode(account, forKey: PropertyKey.account)
        
        aCoder.encode(bank_card, forKey: PropertyKey.bank_card)
         aCoder.encode(card_name, forKey: PropertyKey.card_name)

    }

   

    
  
    
}
