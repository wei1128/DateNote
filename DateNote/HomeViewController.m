//
//  HomeViewController.m
//  DateNote
//
//  Created by Brian Huang on 7/13/15.
//  Copyright (c) 2015 EC. All rights reserved.
//

#import "HomeViewController.h"
#import "KDCalendarView.h"
#import "myEvent.h"
#import "BriefCell.h"
#import "commonHelper.h"

@interface HomeViewController () <KDCalendarDelegate, KDCalendarDataSource, UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet KDCalendarView *calendar;
@property (weak, nonatomic) IBOutlet UILabel *displayMonth;
@property (weak, nonatomic) NSArray *dateEvents;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.BriefTable.delegate=self;
    self.BriefTable.dataSource=self;
    
    self.calendar.delegate = self;
    self.calendar.dataSource = self;
    self.calendar.showsEvents = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSDate *today = [[NSDate alloc]init];
    [self.calendar setMonthDisplayed:today];

    [self.calendar setDateSelected:today];
    [self.calendar resetEvents:[myEvent from:[self startDate] to:[self endDate]]];

    [self calendarController:self.calendar didScrollToMonth:today];
}

-(NSDate*)startDate
{
    NSDateComponents *firstday = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:[NSDate date]];
    [firstday setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    firstday.day = 1;
    
    NSDate *sday = [[NSCalendar currentCalendar] dateFromComponents:firstday];
    
    NSDateComponents *offsetDateComponents = [[NSDateComponents alloc] init];
    offsetDateComponents.month = -6;
    sday = [[NSCalendar currentCalendar]dateByAddingComponents:offsetDateComponents toDate:sday options:0];
    
    return sday;
}

-(NSDate*)endDate
{
    NSDateComponents *firstday = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:[NSDate date]];
    [firstday setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    firstday.day = 1;
    
    NSDate *eday = [[NSCalendar currentCalendar] dateFromComponents:firstday];
    
    NSDateComponents *offsetDateComponents = [[NSDateComponents alloc] init];
    offsetDateComponents.year = 1;
    offsetDateComponents.second = -1;
    eday = [[NSCalendar currentCalendar]dateByAddingComponents:offsetDateComponents toDate:eday options:0];
    
    return eday;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)calendarController:(KDCalendarView*)calendarViewController didScrollToMonth:(NSDate*)date
{
    NSDateFormatter* headerFormatter = [[NSDateFormatter alloc] init];
    headerFormatter.dateFormat = @"MMMM, yyyy";
    self.displayMonth.text = [headerFormatter stringFromDate:date];
}

-(void)calendarController:(KDCalendarView*)calendarViewController didSelectDay:(NSDate*)date
{
    // hack for correct time in taiwan
    NSDateComponents *offsetDateComponents = [[NSDateComponents alloc] init];
    offsetDateComponents.day = 1;
    NSDate *newdate = [[NSCalendar currentCalendar]dateByAddingComponents:offsetDateComponents toDate:date options:0];
    
    self.dateEvents = [myEvent getEventsByDate:newdate];
    [self.BriefTable reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];  //取消選取
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",[self.dateEvents count]);
    return [self.dateEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BriefCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBriefCell" forIndexPath:indexPath];
    
    myEvent *me = self.dateEvents[indexPath.row];
    
    // title
    cell.titleLable.text = me.e_title;
    
    // color
    cell.dotView.backgroundColor = [commonHelper colorFromHexString:me.color];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"H:mm"];
    NSString *strDate = [dateFormatter stringFromDate:me.e_time];
    cell.hourminLabel.text = strDate;
    
    // template name
    cell.templateNameLabel.text = [NSString stringWithFormat:@"#%@", me.t_name];

    return cell;
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
