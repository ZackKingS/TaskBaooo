//
//  SecondTableViewCell.m
//  task
//
//  Created by 柏超曾 on 2017/10/10.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

#import "SecondTableViewCell.h"

@interface   SecondTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *priceL;

@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation SecondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showinfo:) name:@"taskInfo" object:nil];
    
}

- (void)showinfo:(NSNotification *)note{
    
    //回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        NSString * start = [note.userInfo[@"start_time"] componentsSeparatedByString:@" "].firstObject;
       NSString * end =   [note.userInfo[@"deadline"] componentsSeparatedByString:@" "].firstObject;
        

//        self.time.text =  [NSString stringWithFormat:@"任务时间: %@ - %@ ",note.userInfo[@"start_time"],note.userInfo[@"deadline"]];
//
        
        self.time.text =  [NSString stringWithFormat:@"任务时间: %@ - %@ ",start,end];
        
        self.priceL.text = [NSString stringWithFormat:@"¥ %@ 元",note.userInfo[@"price"]];
        
    });
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
