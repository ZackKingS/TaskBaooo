//
//  ZBReadytToDrawController.swift
//  task
//
//  Created by 柏超曾 on 2017/11/2.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import Foundation

class ZBReadytToDrawController: UIViewController ,UITextFieldDelegate{


    
    var card :String?
    
    var name :String?
    

    @IBOutlet weak var bankNumL: UILabel!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var amountT: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfig()
        
        bankNumL.text = card
        nameL.text = name
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        amountT.resignFirstResponder()
    }
    
    
    
    @IBAction func next(_ sender: Any) {
        
        
    }
    
    
    func setupConfig() {
        
        
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius =  kScornerRadius

        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ] //UIFont(name: "Heiti SC", size: 24.0)!
        navigationItem.title = "提现";
        
    }
    
}
