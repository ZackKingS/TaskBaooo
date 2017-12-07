//
//  ZBWebViewController.swift
//  task
//
//  Created by 柏超曾 on 2017/12/5.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

import UIKit

class ZBWebViewController: UIViewController {

    @IBOutlet weak var web: UIWebView!
    
    var url : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        web.loadRequest(URLRequest.init(url: URL.init(string: url!)!))
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
