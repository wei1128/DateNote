 //
//  DetailViewController.m
//  DateNote
//
//  Created by Man-Chun Hsieh on 7/21/15.
//  Copyright (c) 2015 EC. All rights reserved.
//

#import "DetailViewController.h"
#import "HomeViewcontroller.h"
#import "BabyCell.h"
#import "templateList.h"
#import "myEvent.h"
#import "UIImageView+AFNetworking.h"
#import "SqlClient.h"
#import "commonHelper.h"


@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *detailTable;
@property (weak, nonatomic) IBOutlet UINavigationItem *nav;
@property (strong, nonatomic) NSDictionary *templates;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSArray *month_en;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.month_en = @[@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December"];

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 10:00:00"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *birthday = [dateFormatter dateFromString:self.template[@"start_time"]];

    templateList *tl = [[templateList alloc] init];
    
    NSInteger templateID=[self.template[@"t_id"] intValue];
    self.templates = [tl commentTemplateName:self.template[@"t_name"] date:birthday templateId:templateID];

    self.events = self.templates[@"myEvents"];
    
    self.detailTable.dataSource=self;
    self.detailTable.delegate=self;
    
    
    // set nav
    self.nav.title = self.template[@"t_name"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    self.navigationController.navigationBar.translucent = NO;
    
    // 左邊 Filter
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"取消"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(onCancelButton)];
    
    // 右邊 Filter
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"完成"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(onDoneButton)];

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];  //取消選取
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BabyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBabyCell" forIndexPath:indexPath];
    
    myEvent *me = self.events[indexPath.row];
    
    // title
    cell.titleLable.text = me.e_title;
    // desc
    cell.descriptionLabel.text = me.desc;
    
    // month day hour min
    NSDate *currentDate = me.e_time;
    NSLog(@"%@", currentDate);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour | NSCalendarUnitMinute fromDate:currentDate]; // Get necessary date components
    cell.dateLabel.text = [NSString stringWithFormat:@"%ld", components.day];
    cell.monthLabel.text = self.month_en[components.month - 1];
    cell.hourminLabel.text = [NSString stringWithFormat:@"%ld:%02ld", components.hour, components.minute];
    
    // reminder
    cell.reminderLabel.text = [self convertTimeToAgo:me.e_time];
    
    // color
    cell.dotView.backgroundColor = [commonHelper colorFromHexString:me.color];
    cell.colorView.backgroundColor = [commonHelper colorFromHexString:me.color];
    
    [cell.img setImageWithURL:[NSURL URLWithString:me.img_url]];
    
    // template name
    cell.templateNameLabel.text = [NSString stringWithFormat:@"#%@", me.t_name];
    

    
    return cell;
}

- (NSString *)convertTimeToAgo:(NSDate *)createdDate
{
    NSTimeInterval time_get = [createdDate timeIntervalSince1970];
    NSTimeInterval time_now = [[NSDate date] timeIntervalSince1970];
    
    double difference = time_get - time_now;
    NSMutableArray *periods = [NSMutableArray arrayWithObjects:@"sec", @"min", @"hr", @"day", @"week", @"month", @"year", @"decade", nil];
    NSArray *lengths = [NSArray arrayWithObjects:@60, @60, @24, @7, @4.35, @12, @10, nil];
    int j = 0;
    for(j=0; difference >= [[lengths objectAtIndex:j] doubleValue]; j++){
        difference /= [[lengths objectAtIndex:j] doubleValue];
    }
    difference = roundl(difference);
    if(difference != 1){
        [periods insertObject:[[periods objectAtIndex:j] stringByAppendingString:@"s"] atIndex:j];
    }
    return [NSString stringWithFormat:@"%li %@", (long)difference, [periods objectAtIndex:j]];
}

- (void) onCancelButton{
    [self disMissViewFromLeft];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)disMissViewFromLeft{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
}

- (void) onDoneButton{
    [self presentViewFromRight];
    HomeViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];  //記得要用storyboard id 傳過去
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:NO completion:nil];
}

-(void)presentViewFromRight{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
