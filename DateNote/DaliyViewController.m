//
//  DaliyViewController.m
//  DateNote
//
//  Created by Man-Chun Hsieh on 7/13/15.
//  Copyright (c) 2015 EC. All rights reserved.
//

#import "DaliyViewController.h"
#import "DaliyCell.h"
#import "UIImageView+AFNetworking.h"
#import "SVPullToRefresh.h"
#import "myEvent.h"
#import "myTemplate.h"
#import "WebViewController.h"

@interface DaliyViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contentView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *filter;

@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSArray *my_templates;
@property (strong, nonatomic) NSArray *month_en;
@property (strong, nonatomic) NSArray *category;
@property (strong, nonatomic) NSDate *startTime;
@property (assign, nonatomic) NSInteger prePg;
@property (assign, nonatomic) NSInteger nextPg;

@end

@implementation DaliyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupView];

    self.month_en = @[@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December"];
    
    self.my_templates = [myTemplate getTemplates];
    [self setFilterTitle];
    
    [self initEvent];

    self.contentView.dataSource = self;
    self.contentView.delegate = self;
}
                   
- (void) initEvent {
    self.startTime = [[NSDate alloc]init];
    
    self.events = [[NSMutableArray alloc] init];
    self.prePg = 0;
    self.nextPg = 0;
    
    [self nextPage];
}

- (void) prePage {
    NSInteger index = self.filter.selectedSegmentIndex;
    NSMutableArray *newEvents = [[NSMutableArray alloc]init];
    NSArray *newArr = [[NSArray alloc]init];
    
    if (index == 0) {
        newArr = [[[myEvent before:self.startTime pg:self.prePg] reverseObjectEnumerator] allObjects];
        [newEvents addObjectsFromArray:newArr];
    } else {
        index--;
        myTemplate *mt = self.my_templates[index];
        newArr = [[[myEvent before:self.startTime pg:self.prePg mt_id:mt.mt_id] reverseObjectEnumerator] allObjects];
        [newEvents addObjectsFromArray:newArr];
    }
    
    [newEvents addObjectsFromArray:self.events];
    self.events = newEvents;
    
    self.prePg++;
}

- (void) nextPage {
    NSInteger index = self.filter.selectedSegmentIndex;
    
    if (index == 0) {
        [self.events addObjectsFromArray:[myEvent from:self.startTime pg:self.nextPg]];
    } else {
        index--;
        myTemplate *mt = self.my_templates[index];
        [self.events addObjectsFromArray:[myEvent from:self.startTime pg:self.nextPg mt_id:mt.mt_id]];
    }
    self.nextPg++;
}

-(void) setFilterTitle {
    [self.filter removeAllSegments];
    [self.filter insertSegmentWithTitle:@"全部分類" atIndex:0 animated:NO];
    
    for (int i = 0; i < self.my_templates.count; i++) {
        myTemplate *mt = self.my_templates[i];
        [self.filter insertSegmentWithTitle:mt.t_name atIndex:i + 1 animated:NO];
        [[[self.filter subviews] objectAtIndex:i + 1] setTintColor:[self colorFromHexString:mt.color]];
    }

    self.filter.selectedSegmentIndex=0;
}

- (void)setupView
{
    __weak DaliyViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [self.contentView addPullToRefreshWithActionHandler:^{
        NSLog(@"pull to refresh works");
        [weakSelf insertRowAtTop];
    }];
        
    // setup infinite scrolling

    [self.contentView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"infinite scrolling works");
        [weakSelf insertRowAtBottom];
    }];
    
}

#pragma mark - Actions
- (void)insertRowAtTop
{
    __weak DaliyViewController *weakSelf = self;

    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSInteger num = weakSelf.events.count;
        [weakSelf prePage];
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        
        for(NSInteger i = 0; i < weakSelf.events.count - num; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
       
        [weakSelf.contentView beginUpdates];
        
        [weakSelf.contentView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];

        [weakSelf.contentView endUpdates];

        [weakSelf.contentView.pullToRefreshView stopAnimating];
    });
}

- (void)insertRowAtBottom
{
    __weak DaliyViewController *weakSelf = self;

    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSInteger num = weakSelf.events.count;
        [weakSelf nextPage];
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        
        for(NSInteger i = num; i < weakSelf.events.count; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        [weakSelf.contentView beginUpdates];

        [weakSelf.contentView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];

        [weakSelf.contentView endUpdates];
        
        [weakSelf.contentView.infiniteScrollingView stopAnimating];
    });
}

- (IBAction)changeFilter:(UISegmentedControl *)sender {
    [self initEvent];
    [self.contentView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];  //取消選取

    myEvent *me = self.events[indexPath.row];
    if (me.e_detail_url && me.e_detail_url.length > 0) {
        WebViewController *webViewController = [[WebViewController alloc] initWithUrlString:me.e_detail_url];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DaliyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDaliyCell" forIndexPath:indexPath];
    myEvent *me = self.events[indexPath.row];

    // title
    cell.titleLable.text = me.e_title;
    // desc
    cell.descriptionLabel.text = me.desc;

    // month day hour min
    NSDate *currentDate = me.e_time;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour | NSCalendarUnitMinute fromDate:currentDate]; // Get necessary date components
    cell.dateLabel.text = [NSString stringWithFormat:@"%ld", components.day];
    cell.monthLabel.text = self.month_en[components.month - 1];
    cell.hourminLabel.text = [NSString stringWithFormat:@"%ld:%02ld", components.hour, components.minute];

    // reminder
    cell.reminderLabel.text = [self convertTimeToAgo:me.e_time];
    
    // color
    cell.dotView.backgroundColor = [self colorFromHexString:me.color];
    cell.colorView.backgroundColor = [self colorFromHexString:me.color];
    
    [cell.img setImageWithURL:[NSURL URLWithString:me.img_url]];
    
    // template name
    cell.templateNameLabel.text = [NSString stringWithFormat:@"#%@", me.t_name];
    
    return cell;
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
