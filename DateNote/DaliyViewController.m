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
    
    if (index == 0) {
        [self.events addObjectsFromArray:[myEvent before:self.startTime pg:self.prePg]];
    } else {
        index--;
        myTemplate *mt = self.my_templates[index];
        [self.events addObjectsFromArray:[myEvent before:self.startTime pg:self.prePg mt_id:mt.mt_id]];
    }
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
        [[[self.filter subviews] objectAtIndex:i] setTintColor:[self colorFromHexString:mt.color]];
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

- (NSMutableArray *)mockEvents
{
    NSArray *array = @[@{@"me_id" : @"1", @"mt_id" : @"1", @"e_title" : @"煮紅豆湯", @"e_detail_url" : @"http://www.yahoo.com", @"e_time" : @"2015-07-16 12:00:00", @"r_id" : @"1",@"desc" : @"快喝紅豆湯,快喝紅豆湯,快喝紅豆湯,紅豆兩湯匙,砂糖半匙,一杯水,電鍋跳起來就可以喝了", @"img_url" : @"http://img1.groupon.com.tw/fi/9(1091).jpg", @"color": @"#FDFF37",@"t_name":@"女孩月事"},
                    @{@"me_id" : @"2", @"mt_id" : @"2", @"e_title" : @"Y! Summer Party", @"e_detail_url" : @"http://www.yahoo.com", @"e_time" : @"2015-07-20 14:00:00", @"r_id" : @"2",@"desc" : @"帶門票, 午餐券, 停車票, 住宿券, 照相機, 防曬油, 泳衣", @"img_url" : @"https://c2.staticflickr.com/8/7277/7772597482_a587f7278b.jpg", @"color": @"#FF3937",@"t_name":@"一起去郊遊"},
                    @{@"me_id" : @"3", @"mt_id" : @"3", @"e_title" : @"煮紅豆湯", @"e_detail_url" : @"http://www.yahoo.com", @"e_time" : @"2015-08-12 12:00:00", @"r_id" : @"3",@"desc" : @"快喝紅豆湯,快喝紅豆湯,快喝紅豆湯,紅豆兩湯匙,砂糖半匙,一杯水,電鍋跳起來就可以喝了", @"img_url" : @"http://img1.groupon.com.tw/fi/9(1091).jpg", @"color": @"#FDFF37",@"t_name":@"女孩月事"}];

    return [array mutableCopy];
}

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
    /*
    //self.events = self.my_templates;
    if([sender selectedSegmentIndex]>0){
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (int i =0; i< self.self.events.count; i++) {
            if(self.events[i][@"t_name"]==self.category[[sender selectedSegmentIndex]]){
                [temp addObject:self.events[i]];
            }
        }
        self.events = temp;
        temp = nil;
    }
    [self.contentView reloadData];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];  //取消選取
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
