//
//  ItemViewController.m
//  DateNote
//
//  Created by Jackal Wang on 2015/7/29.
//  Copyright (c) 2015年 EC. All rights reserved.
//

#import "ItemViewController.h"
#import "EventDateCell.h"
#import "EventDescCell.h"
#import "SqlClient.h"
#import "UIImageView+AFNetworking.h"


@interface ItemViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableDictionary *event;
    NSMutableArray *eventList;
}

@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventDateTableView.dataSource=self;
    self.eventDateTableView.delegate=self;
    self.eventDateTableView.separatorStyle=NO;
    
    self.eventDescTableView.dataSource=self;
    self.eventDescTableView.delegate=self;
    self.eventDescTableView.separatorStyle=NO;
    
    eventList = [SqlClient getMyEventByEventID:@"1"];
    event = eventList[0];
    self.titleLabel.text = event[@"e_title"];
    [self.image setImageWithURL:[NSURL URLWithString:event[@"img_url"]]];
//    self.image.image = [uiimage][UIImage imageWithContentsOfURL:theURL];
    NSLog(@"array = %@",[SqlClient getMyEventByEventID:@"1"]);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];  //取消選取
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.eventDateTableView) {
        //NSLog(@"eventDateTableView..........");
        return 1;
    }
    if (tableView == self.eventDescTableView) {
        //NSLog(@"eventDescTableView..........");
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.eventDateTableView) {
        EventDateCell *dateCell = [tableView dequeueReusableCellWithIdentifier:@"EventDateCell" forIndexPath:indexPath];
        dateCell.eventDate.text = event[@"e_time"];
        dateCell.eventTemplateName.text = event[@"t_name"];
        return dateCell;
    }
    
    if (tableView == self.eventDescTableView) {
        EventDescCell *descCell = [tableView dequeueReusableCellWithIdentifier:@"EventDescCell" forIndexPath:indexPath];
        descCell.eventDesc.text = event[@"desc"];
        return descCell;
    }
    
    return nil;
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
