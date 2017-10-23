//
//  ViewController.m
//  sinaPersonalV
//
//  Created by 唐超 on 6/7/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ViewController.h"
#import "TCPagesView.h"
#import "TableViewController.h"
//#import "task-Bridging-Header.h"
#import  "task-Swift.h"
#import <Kingfisher/Kingfisher.h>
//#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SecondTableViewController.h"
@interface ViewController ()<TcPageDelegate>

@property (nonatomic, strong) UIView * navgationView;

@property (nonatomic, strong) UIView * navBgView;

@property (nonatomic, strong) CAGradientLayer * separetorLayer;

@property (nonatomic, strong) UIImageView * avatarImageView;

@property (nonatomic, strong) UIImageView * taskImageV;

@property (nonatomic, strong) NSDictionary *taskInfoDic;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initUI];
    
    [self getTaskInfo];


}

-(void)getTaskInfo{
    
    
    //发送请求
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString * str = @"";
        BOOL login =   [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
        
        NSLog(@"%d",login);
        
        if (login) {
             str = [NSString stringWithFormat:@"http://61.183.83.170:30001/v1/task/one?userid=%@&id=%@",[User GetUser].id ,self.taskid];
        }else{
            
              str = [NSString stringWithFormat:@"http://61.183.83.170:30001/v1/task/one?id=%@" ,self.taskid];
        }
        
        
//        NSString * str = [NSString stringWithFormat:@"http://61.183.83.170:30001/v1/task/one?userid=%@&id=%@",[User GetUser].id ,self.taskid];
        NSURL *url = [NSURL URLWithString:str];
        
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            

            /*
             id    :    34
             title    :    平安证券开户
             description    :    平安证券开户
             image    :    http://pic.58pic.com/58pic/13/71/05/32M58PICZKY_1024.jpg
             price    :    10.00
             start_time    :    2017-09-29 10:39:43
             deadline    :    2017-11-29 10:39:43
             status    :    -1
             */
            
            
            
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.taskInfoDic = dict;
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"taskInfo" object:nil userInfo:dict[@"data"]];
            
            //1.确定URL
            NSURL *url = [NSURL URLWithString:dict[@"data"][@"image"]];
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.taskImageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loding"]];
            });
            
        }];
        [dataTask resume];
        
    });
}



- (void)initUI
{

    self.title= self.taskName;
    
    UIImageView * headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenWidth*9/16+200 )];
    headView.autoresizesSubviews = YES;
    headView.backgroundColor = [UIColor whiteColor];
    headView.clipsToBounds = YES;
    headView.image = [UIImage imageNamed:@"loding"];
    _taskImageV = headView;

    
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i <2; i++) {
        
        if (i == 0 ) {
             TableViewController * vc = [[TableViewController alloc] initWithStyle:UITableViewStylePlain];
            vc.taskinfo = self.taskName;
            [array addObject:vc];
        }else{
           SecondTableViewController   * vc = [[SecondTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [array addObject:vc];
        }
        
    }
    
    
    TCPagesView * view = [[TCPagesView alloc] initWithFrame:[UIScreen mainScreen].bounds titles:@[@"任务目标",@"任务奖励"] headHeight:screenWidth*9/16 +10 segmentHeight:50 + 10  headView:headView itemsMargin:30 itemWidth:150 viewControllers:array belongController:self];
    [self.view addSubview:view];
    view.delegate = self;
    

    UIView * bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight -  60 -64, screenWidth, 60)];
    bottomV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomV];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((screenWidth - 100)/2, 0  , 100, 40);
    button.titleLabel.text = @"立即开始";
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.layer.cornerRadius = 5 ;
    button.layer.masksToBounds  = true;
    button.titleLabel.textColor = [UIColor whiteColor];
    button.backgroundColor = [UIColor colorWithRed:228/255.0 green:118/255.0 blue:44/255.0 alpha:1];
    [button setTitle:@"立即开始" forState:UIControlStateNormal ];
    [button addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:button];
    
    
}

-(void)start{
    
      BOOL login =   [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
    
    NSLog(@"%d",login);
    
    if (login ) {
        
        ZBStartTaskController *star = [[ZBStartTaskController alloc]init];
        star.taskid = self.taskid;
        [self.navigationController pushViewController:star animated:YES];
    }else{
        
        ZBLoginController *login = [[ZBLoginController alloc]init];
        ZBNavVC *vc  = [[ZBNavVC alloc]initWithRootViewController:login];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
      
    }
    
    
    
}

- (void)scrollViewDidScrollOffSetY:(CGFloat )offsety
{

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
