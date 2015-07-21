//
//  BabyTemplateViewController.m
//  DateNote
//
//  Created by Man-Chun Hsieh on 7/21/15.
//  Copyright (c) 2015 EC. All rights reserved.
//

#import "BabyTemplateViewController.h"
#import "DetailViewController.h"

@interface BabyTemplateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *templateName;
@property (weak, nonatomic) IBOutlet UITextField *birthDay;
@property (weak, nonatomic) IBOutlet UINavigationItem *nav;
@end

@implementation BabyTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBirthDate];

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

- (void)setupBirthDate {
    dataPicker = [[UIDatePicker alloc] init];
    dataPicker.datePickerMode = UIDatePickerModeDate;
    
    UIToolbar *toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(ShowStartSelectedDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space, doneBtn, nil] animated:YES];
    
    [self.birthDay setInputView:dataPicker];
    [self.birthDay setInputAccessoryView:toolBar];
}


-(void)ShowStartSelectedDate{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    self.birthDay.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:dataPicker.date]];
    [self.birthDay resignFirstResponder];
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

    NSMutableDictionary *inputDic = [[NSMutableDictionary alloc] initWithDictionary:self.template];
    [inputDic setObject:self.birthDay.text forKey:@"start_time"];
    [inputDic setObject:self.templateName.text forKey:@"t_name"];
    vc.template = inputDic;
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
