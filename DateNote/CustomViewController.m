//
//  CustomViewController.m
//  DateNote
//
//  Created by Man-Chun Hsieh on 7/20/15.
//  Copyright (c) 2015 EC. All rights reserved.
//

#import "CustomViewController.h"
#import "DetailViewController.h"

@interface CustomViewController (){
NSArray* _titleSelectionData;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *nav;

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupStartDate];
    [self setupEndDate];
   
    // set nav
    self.nav.title = self.template[@"t_name"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    self.navigationController.navigationBar.translucent = NO;

    // 左邊 Filter
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Template"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(onCancelButton)];
    
    // 右邊 Filter
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"下一步"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(onDoneButton)];
}

- (void)setupStartDate {
    dataPicker = [[UIDatePicker alloc] init];
    dataPicker.datePickerMode = UIDatePickerModeDate;
    
    UIToolbar *toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(ShowStartSelectedDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space, doneBtn, nil] animated:YES];
    
    [self.startDate setInputView:dataPicker];
    [self.startDate setInputAccessoryView:toolBar];
}

- (void)setupEndDate {
    dataPicker = [[UIDatePicker alloc] init];
    dataPicker.datePickerMode = UIDatePickerModeDate;
    
    UIToolbar *toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(ShowEndSelectedDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space, doneBtn, nil] animated:YES];
    
    [self.endDate setInputView:dataPicker];
    [self.endDate setInputAccessoryView:toolBar];
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
    DetailViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];  //記得要用storyboard id 傳過去
    vc.template = self.template;
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


-(void)ShowStartSelectedDate{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/YYYY hh:mm a"];
    self.startDate.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:dataPicker.date]];
    [self.startDate resignFirstResponder];
}

-(void)ShowEndSelectedDate{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/YYYY hh:mm a"];
    self.endDate.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:dataPicker.date]];
    [self.endDate resignFirstResponder];
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
