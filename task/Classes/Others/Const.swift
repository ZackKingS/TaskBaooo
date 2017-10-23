//
//  Const.swift
//  TodayNews-Swift
//
//  Created by 杨蒙 on 17/2/8.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import UIKit
import AdSupport // 广告

enum CellType: Int {
    case normalCell = 0     // 一般的 cell
    case userCell = 32      // 带有用户的 cell
    case relationCell = 50  // 他们也在用头条
}

/// 屏幕的宽
let screenWidth = UIScreen.main.bounds.width
/// 屏幕的高
let screenHeight = UIScreen.main.bounds.height

/// iid 未登录用户 id，只要安装了今日头条就会生成一个 iid
/// 可以在自己的手机上安装一个今日头条，然后通过 charles 抓取一下这个 iid，
/// 替换成自己的，再进行测试
let IID: String = "5034850950"
/// iid 和 device_id 好像是绑定到一起的，不对应的话获取不到数据
let device_id: String = "6096495334"

let app_name = "news_article"

let channel = "App%20Store"

let device_platform = "iphone"
/// 当前时间
let date = Date()
let currentTimeInterval = UInt64(date.timeIntervalSince1970 * 1000)

let resolution = "\(screenWidth * 2)*\(screenHeight * 2)"
/// idfv
let idfv = UIDevice.current.identifierForVendor?.uuidString
/// 版本号
let versionCode = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
/// 系统版本号
let systemVersion = UIDevice.current.systemVersion
/// idfa
let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString


/// 服务器地址
//let BASE_URL = "http://lf.snssdk.com/"
//let BASE_URL = "http://ib.snssdk.com"
let BASE_URL = "https://is.snssdk.com/"



// 抽屉效果最大值
let kMaxLeftOffset:CGFloat = screenWidth * 0.618
// 左右间距
let kMargin:CGFloat = 15.0
// 导航栏高度
let kNavBarHeight: CGFloat = 64.0
// 导航栏高度
let kTabBarHeight: CGFloat = 49.0
/// 首页新闻间距
let khomePageTitleHeight: CGFloat = 40.0
/// 首页新闻间距
let kHomeMargin: CGFloat = 15.0
/// 微头条界面 头部视图 的高度
let kWeiTouTiaoHeaderHieght: CGFloat = 45
/// 我的界面 头部视图 的高度
let kMineHeaderViewHieght: CGFloat = screenHeight * 0.4
/// 关注详情界面 头部视图 的高度
var kConcernHeaderViewHieght: CGFloat = 330


// banner 高度
let kBannerHeight: CGFloat = 160.0



//圆角
let kLcornerRadius :CGFloat = 20

let kMcornerRadius :CGFloat = 10

let kScornerRadius :CGFloat = 5

/// iPhone 5
let isIPhone5 = screenHeight == 568 ? true : false
/// iPhone 6
let isIPhone6 = screenHeight == 667 ? true : false
/// iPhone 6P
let isIPhone6P = screenHeight == 736 ? true : false

let isNight = "isNight"

let TabBarDidSelectedNotification = "TabBarDidSelectedNotification"

let ZBLOGIN_KEY = "login" as String 

let ZBLOGINED_FLAG  :Bool = UserDefaults.standard.object(forKey: ZBLOGIN_KEY) as! Bool

let ZBLogin = UserDefaults.standard.object(forKey: ZBLOGIN_KEY)! as! Bool

let USER = "user"

//MARK: 测试接口
//----------------   用户接口---------------------------
//let BaseURL = "http://taskbao.dev.cnfol.wh/"

let BaseURL = "http://61.183.83.170:30001/"


//短信
let API_GETSMS_URL = BaseURL + "v1/user/smsverify"
//注册
let API_REGISTE_URL = BaseURL + "v1/user/Register"
//登录
let API_LOGIN_URL = BaseURL + "v1/user/login"
//找回
let API_GETPWDBACK_URL = BaseURL + "v1/user/resetpwd"

//查询明显
let API_GETIMCOME_URL = BaseURL + "v1/user/income"

//查询余额
let API_GETPROFILE_URL = BaseURL + "v1/user/profile"



//----------------   任务接口---------------------------
//获取任务列表
let API_GETTASKLIST_URL = BaseURL + "v1/task/list"
//获取单条任务详情
let API_GETTASKDETAIL_URL = BaseURL + "v1/task/one"
//上传图片
let API_UPLOADIMAGE_URL = BaseURL + "v1/task/donetask"

//已完成任务
let API_DONETASK_URL = BaseURL + "v1/task/donelist"


//更新
let  API_SOFTWARE_UPDATA_URL = BaseURL +  "v1/software"

let  API_ERROR_MESSAGE_URL = BaseURL +  "v1/software/applog"

//MARK: 正式接口
