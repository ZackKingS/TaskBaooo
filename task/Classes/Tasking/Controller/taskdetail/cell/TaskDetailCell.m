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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;

@end



@implementation TaskDetailCell




- (void)awakeFromNib {
    [super awakeFromNib];


//    NSLog(@"%f",self.textFieldHeight);
//
//    self.heightCons.constant = self.textFieldHeight;
    
    self.descri.scrollEnabled = NO;
    
    self.descri.editable = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showinfo:) name:@"taskInfo" object:nil];
    
}

- (void)showinfo:(NSNotification *)note{
    
    //回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSString * start = [note.userInfo[@"start_time"] componentsSeparatedByString:@" "].firstObject;
        NSString * end =   [note.userInfo[@"deadline"] componentsSeparatedByString:@" "].firstObject;
        
//         NSLog(@"%f",self.textFieldHeight);
        
        
        
//          self.textFieldHeight  = [self calculateRowHeight:dict[@"data"][@"description"] fontSize:14];
        
        self.heightCons.constant =   [self calculateRowHeight:note.userInfo[@"description"] fontSize:14]  + 15;
        
        
          NSLog(@"%f",  self.heightCons.constant);
        
           self.descri.text = note.userInfo[@"description"];
//        self.time.text =  [NSString stringWithFormat:@"任务时间: %@ - %@ ",note.userInfo[@"start_time"],note.userInfo[@"deadline"]];
        
        self.time.text =  [NSString stringWithFormat:@"任务时间: %@ - %@ ",start,end];

        
    });
    
 
}

- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize{
    
    
    
    
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(self.bounds.size.width - 30, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
