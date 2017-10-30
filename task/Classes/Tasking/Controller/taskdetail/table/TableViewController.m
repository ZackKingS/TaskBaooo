//
//  TableViewController.m
//  test
//
//  Created by 唐超 on 5/8/17.
//  Copyright © 2017 唐超. All rights reserved.
//

#import "TableViewController.h"
#import "TaskDetailCell.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 250;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    [self.tableView registerNib: [UINib nibWithNibName:@"TaskDetailCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showinfo:) name:@"taskInfo" object:nil];
}

- (void)showinfo:(NSNotification *)note{
    
    //回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
       
        self.textFieldHeight =  [self calculateRowHeight:note.userInfo[@"description"] fontSize:14];
        
        [self.tableView reloadData];
        
    });
    
    
}

- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize{
    
    
    
    
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 30, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.textFieldHeight + 200;
    
//    return 1200;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    TaskDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textFieldHeight = self.textFieldHeight;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
