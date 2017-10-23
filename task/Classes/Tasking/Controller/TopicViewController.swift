//
//  TopicViewController.swift
//  task
//
//  Created by 柏超曾 on 2017/9/15.
//  Copyright © 2017年 柏超曾. All rights reserved.
//


// 记录点击的顶部标题
//var topicTitle: TopicTitle?

import UIKit
import Foundation
class TopicViewController:  UIViewController,UITableViewDelegate,UITableViewDataSource{
    
   private lazy var viewModels : [Tasks] = [Tasks]()
    var topicTitle: TopicTitle?
    var tableView : UITableView?
    
    fileprivate var arrayy = [TopicTitle]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //         设置导航栏颜色
//        navigationController?.navigationBar.theme_barTintColor = "colors.homeNavBarTintColor"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("123")
        
        let first = UserDefaults.standard.object(forKey: "firstOpen")
        
        if (first != nil) {
            tableView = UITableView(frame:  CGRect(x: 0 , y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height ), style: UITableViewStyle.plain)
            tableView?.dataSource = self
            tableView?.delegate = self
            self.view.addSubview(tableView!)
            self.tableView?.register(UITableViewCell().classForCoder, forCellReuseIdentifier: "cell")
            /// 设置上拉和下拉刷新
            setRefreshh()
            view.backgroundColor = UIColor.globalBackgroundColor()
            automaticallyAdjustsScrollViewInsets = false
        }else{
            
            UserDefaults.standard.set("first", forKey: "firstOpen")
            
        }
        
        
//        tableView = UITableView(frame:  CGRect(x: 0 , y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height ), style: UITableViewStyle.plain)
//        tableView?.dataSource = self
//        tableView?.delegate = self
//        self.view.addSubview(tableView!)
//        self.tableView?.register(UITableViewCell().classForCoder, forCellReuseIdentifier: "cell")
//        /// 设置上拉和下拉刷新
//        setRefreshh()
//        view.backgroundColor = UIColor.globalBackgroundColor()
//        automaticallyAdjustsScrollViewInsets = false
 
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //每一块有多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrayy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = arrayy[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200;
    }
    

    
}


extension TopicViewController {
    
    /// 设置上拉和下拉刷新
    @objc fileprivate func setRefreshh() {
        
        
        let header = RefreshHeder(refreshingBlock: { [weak self] in
            // 获取标题数据
            NetworkTool.loadHomeTitlesData(fromViewController: String(describing: TasksViewController.self)) { (topTitles, homeTopicVCs) in
                
                
                self!.tableView?.mj_header.endRefreshing()
                self!.arrayy = topTitles
                self!.tableView?.reloadData()
            }
        })
        
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView?.mj_header = header
        tableView?.mj_header.beginRefreshing()
        tableView?.mj_header = header
        
    }
}

