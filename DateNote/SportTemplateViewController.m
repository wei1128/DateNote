//
//  SportTemplateViewController.m
//  DateNote
//
//  Created by Man-Chun Hsieh on 7/21/15.
//  Copyright (c) 2015 EC. All rights reserved.
//

#import "SportTemplateViewController.h"
#import "DetailViewController.h"

@interface SportTemplateViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *nav;
@end

@implementation SportTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
