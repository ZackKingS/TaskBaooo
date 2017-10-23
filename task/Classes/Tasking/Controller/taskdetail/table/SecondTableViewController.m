//
//  SecondTableViewController.m
//  task
//
//  Created by 柏超曾 on 2017/10/10.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

#import "SecondTableViewController.h"

#import "SecondTableViewCell.h"
@interface SecondTableViewController ()

@end

@implementation SecondTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 250;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    [self.tableView registerNib: [UINib nibWithNibName:@"SecondTableViewCell" bundle:nil] forCellReuseIdentifier:@"xxx"];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SecondTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"xxx" forIndexPath:indexPath];
    
    return cell;
}

@end
