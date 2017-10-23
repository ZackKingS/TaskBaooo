//
//  TaskDetailCell.m
//  task
//
//  Created by 柏超曾 on 2017/10/10.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

#import "TaskDetailCell.h"

@interface   TaskDetailCell()

@property (weak, nonatomic) IBOutlet UITextView *descri;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *totle;

@end



@implementation TaskDetailCell




- (void)awakeFromNib {
    [super awakeFromNib];

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showinfo:) name:@"taskInfo" object:nil];
    
}

- (void)showinfo:(NSNotification *)note{
    
    //回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSString * start = [note.userInfo[@"start_time"] componentsSeparatedByString:@" "].firstObject;
        NSString * end =   [note.userInfo[@"deadline"] componentsSeparatedByString:@" "].firstObject;
        
        
        
        
           self.descri.text = note.userInfo[@"description"];
//        self.time.text =  [NSString stringWithFormat:@"任务时间: %@ - %@ ",note.userInfo[@"start_time"],note.userInfo[@"deadline"]];
        
        self.time.text =  [NSString stringWithFormat:@"任务时间: %@ - %@ ",start,end];

        
    });
    
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
